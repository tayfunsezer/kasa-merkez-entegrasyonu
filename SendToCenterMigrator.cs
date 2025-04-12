using System;
using System.Data;
using System.Data.SqlClient;
using System.Transactions;
using System.Collections.Generic;


public class SendToCenterMigrator
{
    private const string sourceConnStr = "your_source_connection_string";
    private const string destConnStr = "your_destination_connection_string";

    public void Migrate(string sicilNo, string kasaNo)
    {
        using (var scope = new TransactionScope())
        {
            try
            {
                using (SqlConnection sourceConn = new SqlConnection(sourceConnStr))
                using (SqlConnection destConn = new SqlConnection(destConnStr))
                {
                    sourceConn.Open();
                    destConn.Open();

                    

                    try
                    {
                        // Step 1: Insert into BELGE_CARI
                        var belgeIdsFromCari = InsertBelgeCari(sourceConn,destConn, sicilNo);

                        // Step 2: Insert into BELGE and HAREKET
                        InsertBelgeAndHareket(belgeIdsFromCari,sourceConn, destConn, sicilNo,kasaNo);

                        // Step 3: Mark source records as migrated
                        MarkAsMigrated(sourceConn);

                    }
                    catch (Exception ex)
                    {

                        Console.WriteLine("Error during migration: " + ex.Message);
                        throw;
                    }
                }

                // Complete the transaction scope (this commits the entire operation)
                scope.Complete();
                Console.WriteLine("Migration and Integration completed successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error during transaction scope: " + ex.Message);
                throw;

            }
        }
    }

        // Method to insert into BELGE_CARI table
    private Dictionary<int , string> InsertBelgeCari(SqlConnection sourceConnection,SqlConnection destConnection, string sicilNo)
    {
        // Query to get data to insert into BELGE_CARI
        string selectQuery = @"
            SELECT
                SF.SatFat_FirmaAdi AS Musteri_Adi,
                PC.SoyaAd AS Musteri_Soyad,
                PC.Adres1 + ' ' + PC.Adres2 AS Adres,
                PC.Il AS Il,
                PC.Ilce AS Ilce,
                PC.TcNo AS TcNo,
                PC.SabitTel AS TelNo,
                PC.CepTel AS GSMNo,
                PC.VergiDairesi AS Vdaire,
                PC.VergiNo AS Vno,
                SF.SatFat_Tarih AS Kayit_Tarihi,
                PC.EMail AS Email,
                SF.SatFat_FirmaAdi AS Musteri_Kart_No,
                SF.ID
            FROM
                TBLSATISFATBASLIK SF
            JOIN
                TBLPOSCARI PC ON SF.SatFat_Firma_Id = PC.ID
            WHERE
                SF.SatFat_MerkezAktarim = 0 AND SF.BelgeTipi IN ('EFA','EAR')"; //belge tipinin hareket tablopsunda olduğunu varsaydık.

        // Command to fetch data
        SqlCommand selectCommand = new SqlCommand(selectQuery,sourceConnection);
        SqlDataReader reader = selectCommand.ExecuteReader();
 
 
        // Create a DataTable to hold the records for bulk insert
        DataTable dt = new DataTable();
        dt.Columns.Add("Belge_ID", typeof(string));
        dt.Columns.Add("Firma", typeof(string));
        dt.Columns.Add("Musteri_Adi", typeof(string));
        dt.Columns.Add("Musteri_Soyad", typeof(string));
        dt.Columns.Add("Adres", typeof(string));
        dt.Columns.Add("Il", typeof(string));
        dt.Columns.Add("Ilce", typeof(string));
        dt.Columns.Add("TcNo", typeof(string));
        dt.Columns.Add("TelNo", typeof(string));
        dt.Columns.Add("GSMNo", typeof(string));
        dt.Columns.Add("Vdaire", typeof(string));
        dt.Columns.Add("Vno", typeof(string));
        dt.Columns.Add("Kayit_Tarihi", typeof(DateTime));
        dt.Columns.Add("Email", typeof(string));
        dt.Columns.Add("Musteri_Kart_No", typeof(string));

        
        Dictionary<int, string> mapping = new Dictionary<int, string>();

        // Populate the DataTable with rows
        while (reader.Read())
        {
            // Generate a unique Belge_ID for each row
            string belgeId = GenerateUniqueBelgeId(sicilNo);
            var baslikId = Convert.ToInt32(reader["ID"]);

            mapping.Add(baslikId,belgeId);

            // Add the row to the DataTable
            dt.Rows.Add(
                belgeId,                  // Belge_ID
                "0",                      // Firma
                reader["Musteri_Adi"],    // Musteri_Adi
                reader["Musteri_Soyad"],  // Musteri_Soyad
                reader["Adres"],          // Adres
                reader["Il"],             // Il
                reader["Ilce"],           // Ilce
                reader["TcNo"],           // TcNo
                reader["TelNo"],          // TelNo
                reader["GSMNo"],          // GSMNo
                reader["Vdaire"],         // Vdaire
                reader["Vno"],            // Vno
                reader["Kayit_Tarihi"],   // Kayit_Tarihi
                reader["Email"],          // Email
                reader["Musteri_Kart_No"] // Musteri_Kart_No
            );
        }

        reader.Close();

        dt.Columns.Remove("ID");

        // Use SqlBulkCopy to insert the data
        using (SqlBulkCopy bulkCopy = new SqlBulkCopy(destConnection))
        {
            bulkCopy.DestinationTableName = "BELGE_CARI"; // Destination table
            try
            {
                // Write the data to the destination table
                bulkCopy.WriteToServer(dt);

            }
            catch (Exception ex)
            {
                // Handle any errors that occur during the bulk copy
                throw;

            }
        }
        
        return mapping;
    }


    private void InsertBelgeAndHareket(Dictionary<int, string> belgeIdsFromCari ,SqlConnection sourceConn, SqlConnection destConn, string sicilNo, string kasaNo)
    {
        // Fetch BELGE data
        var getBelgeDataCmd = new SqlCommand(@"
            SELECT 
                SF.SatFat_BelgeNo, SF.SatFat_FirmaAdi, SF.SatFat_Tarih, SF.ID, '' as SicilNo,  SatFat_Tarih as Kapanis, 0 as Iptal, 0 as Flag, 0 as Puan,  SatFat_Tarihas BelgeTarihi
                SF.SatFat_EvrakTuru, SF.SatFat_Aratoplam, SF.SatFat_KdvToplam, SF.SatFat_GenelToplam, 
            FROM TBLSATISFATBASLIK SF
            WHERE SF.SatFat_MerkezAktarim = 0
        ", sourceConn);

        SqlDataReader reader = getBelgeDataCmd.ExecuteReader();
        DataTable belgeDataTable = new DataTable();
        belgeDataTable.Load(reader);

        // Add Belge_ID column
        belgeDataTable.Columns.Add("Belge_ID", typeof(string));

        // Generate Belge_ID per row
        foreach (DataRow row in belgeDataTable.Rows)
        {
            var baslikId = Convert.ToInt32(row["ID"]);
            if (belgeIdsFromCari.ContainsKey(baslikId))
            {
                // If exists, get the value (the Belge_ID from the dictionary)
                row["Belge_ID"] = belgeIdsFromCari[baslikId];
            }
            else
            {
                 row["Belge_ID"] = GenerateUniqueBelgeId(sicilNo);
            }

            row["SicilNo"] = kasaNo;
        }

        // Insert BELGE with bulk copy
        using (SqlBulkCopy bulkCopy = new SqlBulkCopy(destConn))
        {
            bulkCopy.DestinationTableName = "BELGE";
            bulkCopy.ColumnMappings.Add("Belge_ID", "Belge_ID");
            bulkCopy.ColumnMappings.Add("SatFat_Tarih", "Tarih");
            bulkCopy.ColumnMappings.Add("SatFat_EvrakTuru", "Belge_Tipi");
            bulkCopy.ColumnMappings.Add("SatFat_Aratoplam", "Matrah");
            bulkCopy.ColumnMappings.Add("SatFat_KdvToplam", "Kdv");
            bulkCopy.ColumnMappings.Add("SatFat_GenelToplam", "Toplam");
            bulkCopy.ColumnMappings.Add("SatFat_FirmaAdi", "Musteri_Adi");
            bulkCopy.ColumnMappings.Add("SatFat_BelgeNo", "Belge_No");
            bulkCopy.ColumnMappings.Add("Kapanis", "Kapanis");
            bulkCopy.ColumnMappings.Add("Iptal", "Iptal");
            bulkCopy.ColumnMappings.Add("Flag", "Flag");
            bulkCopy.ColumnMappings.Add("Puan", "Puan");




            bulkCopy.WriteToServer(belgeDataTable);
        }

        // Fetch HAREKET data (include BaslikID for mapping)
        var getHareketDataCmd = new SqlCommand(@"
            SELECT 
                BelgeNo -1 as Satir, StokKodu, PluNo, Barkod, DepartmanNo, Kdv, Miktar, H.BaslikID, KasiyerNo, 
                Fiyat, Tutar, SERVERCOMPANYDID, Tarih, N'Sat' as Tip, 0 as Ind_Flag, 0 as Ind_Miktar, 0 as Satici_No, 0 as Belge_Satir, Miktar as Kalan_Adet, Fiyat as Belge_Fiyat, Miktar as Belge_Adet, Fiyat as İade_Fiyat
            FROM TBLSATISFATHAREKET H
            WHERE SatFat_MerkezAktarim = 0
        ", sourceConn);

        SqlDataReader hareketReader = getHareketDataCmd.ExecuteReader();
        DataTable hareketDataTable = new DataTable();
        hareketDataTable.Load(hareketReader);

        // Add Belge_ID column
        hareketDataTable.Columns.Add("Belge_ID", typeof(string));

        // Match Belge_ID by BaslikID
        foreach (DataRow hareketRow in hareketDataTable.Rows)
        {
            int baslikId = Convert.ToInt32(hareketRow["BaslikID"]);
            DataRow[] matchingBelge = belgeDataTable.Select($"ID = {baslikId}");

            if (matchingBelge.Length > 0)
            {
                hareketRow["Belge_ID"] = matchingBelge[0]["Belge_ID"];
            }
            else
            {
                throw new Exception($"Belge_ID not found for BaslikID = {baslikId}");
                
            }
        }

        // Insert HAREKET with bulk copy
        using (SqlBulkCopy hareketBulkCopy = new SqlBulkCopy(destConn))
        {
            //kaynak,hedef
            hareketBulkCopy.DestinationTableName = "HAREKET";
            hareketBulkCopy.ColumnMappings.Add("Belge_ID", "Belge_ID");
            hareketBulkCopy.ColumnMappings.Add("Satir", "Satir");
            hareketBulkCopy.ColumnMappings.Add("StokKodu", "Stok_Kodu");
            hareketBulkCopy.ColumnMappings.Add("PluNo", "PLUNO");
            hareketBulkCopy.ColumnMappings.Add("Barkod", "Barkod");
            hareketBulkCopy.ColumnMappings.Add("DepartmanNo", "Dep_No");
            hareketBulkCopy.ColumnMappings.Add("Kdv", "Kdv");
            hareketBulkCopy.ColumnMappings.Add("Miktar", "Adet");
            hareketBulkCopy.ColumnMappings.Add("Fiyat", "Fiyat");
            hareketBulkCopy.ColumnMappings.Add("Tutar", "Tutar");
            hareketBulkCopy.ColumnMappings.Add("SERVERCOMPANYDID", "SERVERCOMPANYDID");
            hareketBulkCopy.ColumnMappings.Add("Tarih", "Tarih");
            hareketBulkCopy.ColumnMappings.Add("KasiyerNo", "Kasiyer_No");

            
            hareketBulkCopy.ColumnMappings.Add("Tip", "Tip");
            hareketBulkCopy.ColumnMappings.Add("Ind_Flag", "Ind_Flag");
            hareketBulkCopy.ColumnMappings.Add("Ind_Miktar", "Ind_Miktar");
            hareketBulkCopy.ColumnMappings.Add("Satici_No", "Satici_No");
            hareketBulkCopy.ColumnMappings.Add("Belge_Satir", "Belge_Satir");

            hareketBulkCopy.ColumnMappings.Add("Kalan_Adet", "Kalan_Adet");
            hareketBulkCopy.ColumnMappings.Add("Belge_Fiyat", "Belge_Fiyat");

            hareketBulkCopy.ColumnMappings.Add("Belge_Adet", "Belge_Adet");
            hareketBulkCopy.ColumnMappings.Add("İade_Fiyat", "İade_Fiyat");



            hareketBulkCopy.WriteToServer(hareketDataTable);
        }
    }


    // Method to mark source records as migrated
    private void MarkAsMigrated(SqlConnection sourceConn)
    {
        var updateSourceCmd = new SqlCommand(@"
            UPDATE TBLSATISFATBASLIK 
            SET SatFat_MerkezAktarim = 1 
            WHERE SatFat_MerkezAktarim = 0  AND BelgeTipi IN ('EFA','EAR', 'FIS')
        ", sourceConn);

        updateSourceCmd.ExecuteNonQuery();
    }

    // Method to generate a unique 19-digit Belge_ID
    private string GenerateUniqueBelgeId(string kasaSicilNo)
    {
        string uniquePart = DateTime.Now.Ticks.ToString() + new Random().Next(10000, 99999).ToString();
        string fullBelgeId = kasaSicilNo + uniquePart;
        return fullBelgeId.PadLeft(19, '0').Substring(0, 19); // Ensure it's exactly 19 digits
    }
}
