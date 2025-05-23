USE [INTER_BOS]
GO
/****** Object:  Table [dbo].[BELGE]    Script Date: 12.04.2025 01:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BELGE](
	[ID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Belge_ID] [nvarchar](30) NULL,
	[Sicil_No] [nvarchar](12) NULL,
	[Kasa_No] [smallint] NULL,
	[Kasiyer_No] [smallint] NULL,
	[Tarih] [datetime] NULL,
	[Kapanis] [datetime] NULL,
	[Belge_Tipi] [nvarchar](3) NULL,
	[Belge_No] [int] NULL,
	[Musteri_Kart_No] [nvarchar](20) NULL,
	[Matrah] [decimal](15, 4) NULL,
	[Kdv] [decimal](15, 4) NULL,
	[Toplam] [decimal](15, 4) NULL,
	[Iptal] [tinyint] NULL,
	[Flag] [bit] NULL,
	[Z_No] [smallint] NULL,
	[Puan] [decimal](15, 4) NULL,
	[SERVERCOMPANYID] [smallint] NULL,
	[BELGETARIH] [datetime] NULL,
	[HOUR] [tinyint] NULL,
	[CASHTOTAL] [decimal](18, 4) NULL,
	[CANCELTOTAL] [decimal](18, 4) NULL,
	[DISCOUNTTOTAL] [decimal](18, 4) NULL,
	[CREDITTOTAL] [decimal](18, 4) NULL,
	[Belge_AltTipi] [tinyint] NULL,
	[Yetkili_Kasiyer_No] [smallint] NULL,
	[Musteri_Kodu] [nvarchar](20) NULL,
	[L_EXPORTED] [bit] NULL,
	[Notlar] [nvarchar](500) NULL,
	[Version] [nvarchar](50) NULL,
	[Merkez_Aktarim] [bit] NULL,
	[Eku_No] [int] NULL,
	[Olusturma] [datetime] NULL,
	[Sube_No] [smallint] NULL,
	[Ettn] [nvarchar](36) NULL,
	[Ebelge_FaturaNo] [nvarchar](16) NULL,
	[FisTerminal] [bit] NULL,
	[Ebelge] [bit] NULL,
	[Fiscal_Belge_Id] [nvarchar](50) NULL,
	[Fiscal_Belge_No] [int] NULL,
	[Fiscal_Donem_Belge_No] [int] NULL,
	[Belge_SiraNo] [int] NULL,
	[Dyn_Kasa] [bit] NULL,
	[BelgeGuid] [nvarchar](40) NULL,
	[DocumentID] [nvarchar](64) NULL,
 CONSTRAINT [PK_BELGE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_BELGE] UNIQUE NONCLUSTERED 
(
	[Belge_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BELGE_CARI]    Script Date: 12.04.2025 01:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BELGE_CARI](
	[Belge_ID] [nvarchar](30) NULL,
	[Firma] [bit] NULL,
	[Musteri_Adi] [nvarchar](100) NULL,
	[Musteri_Soyad] [nvarchar](50) NULL,
	[Adres] [nvarchar](120) NULL,
	[Il] [nvarchar](25) NULL,
	[Ilce] [nvarchar](25) NULL,
	[TcNo] [nvarchar](20) NULL,
	[TelNo] [nvarchar](20) NULL,
	[GSMNo] [nvarchar](20) NULL,
	[VDaire] [nvarchar](30) NULL,
	[VNo] [nvarchar](15) NULL,
	[Kayit_Tarihi] [datetime] NULL,
	[Email] [nvarchar](50) NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Musteri_Kodu] [nvarchar](20) NULL,
	[Musteri_Kart_No] [nvarchar](20) NULL,
 CONSTRAINT [PK_BELGE_CARI] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HAREKET]    Script Date: 12.04.2025 01:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HAREKET](
	[Belge_ID] [nvarchar](30) NULL,
	[Satir] [int] NOT NULL,
	[Tip] [nvarchar](3) NOT NULL,
	[Stok_Kodu] [nvarchar](30) NULL,
	[PLUNO] [int] NULL,
	[Barkod] [nvarchar](30) NULL,
	[Dep_No] [tinyint] NULL,
	[Kdv] [decimal](4, 2) NULL,
	[Adet] [decimal](15, 4) NULL,
	[Fiyat] [decimal](15, 4) NULL,
	[Tutar] [decimal](15, 4) NULL,
	[Ind_Flag] [tinyint] NULL,
	[Ind_Miktar] [decimal](15, 4) NULL,
	[Satici_No] [smallint] NULL,
	[Seri_No] [nvarchar](24) NULL,
	[Promo_ID] [int] NULL,
	[Puan] [decimal](15, 4) NULL,
	[SERVERCOMPANYID] [smallint] NULL,
	[HAREKETID] [bigint] IDENTITY(1,1) NOT NULL,
	[Tarih] [datetime] NULL,
	[Kasiyer_No] [smallint] NULL,
	[Belge_Fiyat] [decimal](15, 4) NULL,
	[Kalan_Adet] [decimal](15, 4) NULL,
	[Bagli_Satir] [int] NULL,
	[IMEI] [nvarchar](15) NULL,
	[Kontrat_No] [nvarchar](20) NULL,
	[Iade_Fiyat] [decimal](15, 4) NULL,
	[Aciklama] [nvarchar](50) NULL,
	[ReferansId] [nvarchar](50) NULL,
	[PDep_No] [tinyint] NULL,
	[PKdv] [decimal](4, 2) NULL,
	[PLimit] [decimal](15, 4) NULL,
	[Belge_Adet] [decimal](18, 4) NULL,
 CONSTRAINT [PK_HAREKET] PRIMARY KEY CLUSTERED 
(
	[HAREKETID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BELGE] ADD  CONSTRAINT [DF_BELGE_Iptal]  DEFAULT ((0)) FOR [Iptal]
GO
ALTER TABLE [dbo].[BELGE] ADD  CONSTRAINT [DF_BELGE_Flag]  DEFAULT ((0)) FOR [Flag]
GO
ALTER TABLE [dbo].[BELGE] ADD  CONSTRAINT [DF_BELGE_Puan]  DEFAULT ((0)) FOR [Puan]
GO
ALTER TABLE [dbo].[BELGE] ADD  CONSTRAINT [DF_BELGE_L_EXPORTED]  DEFAULT ((0)) FOR [L_EXPORTED]
GO
ALTER TABLE [dbo].[BELGE] ADD  CONSTRAINT [DF_BELGE_Merkez_Aktarim]  DEFAULT ((0)) FOR [Merkez_Aktarim]
GO
ALTER TABLE [dbo].[BELGE] ADD  CONSTRAINT [DF_BELGE_Olusturma]  DEFAULT (getdate()) FOR [Olusturma]
GO
ALTER TABLE [dbo].[BELGE_CARI] ADD  CONSTRAINT [DF_BELGE_CARI_Kayit_Tarihi]  DEFAULT (getdate()) FOR [Kayit_Tarihi]
GO
ALTER TABLE [dbo].[HAREKET] ADD  CONSTRAINT [DF__HAREKET__Dep_No__145C0A3F]  DEFAULT ((1)) FOR [Dep_No]
GO
ALTER TABLE [dbo].[HAREKET] ADD  CONSTRAINT [DF__HAREKET__Adet__15502E78]  DEFAULT ((0)) FOR [Adet]
GO
ALTER TABLE [dbo].[HAREKET] ADD  CONSTRAINT [DF__HAREKET__Fiyat__164452B1]  DEFAULT ((0)) FOR [Fiyat]
GO
ALTER TABLE [dbo].[HAREKET] ADD  CONSTRAINT [DF__HAREKET__Tutar__173876EA]  DEFAULT ((0)) FOR [Tutar]
GO
ALTER TABLE [dbo].[HAREKET] ADD  CONSTRAINT [DF__HAREKET__Ind_Fla__182C9B23]  DEFAULT ((0)) FOR [Ind_Flag]
GO
ALTER TABLE [dbo].[HAREKET] ADD  CONSTRAINT [DF__HAREKET__Ind_Mik__1920BF5C]  DEFAULT ((0)) FOR [Ind_Miktar]
GO
ALTER TABLE [dbo].[HAREKET] ADD  CONSTRAINT [DF__HAREKET__Puan__1920BF2D]  DEFAULT ((0)) FOR [Puan]
GO
ALTER TABLE [dbo].[BELGE_CARI]  WITH CHECK ADD  CONSTRAINT [FK_BELGE_CARI_BELGE] FOREIGN KEY([Belge_ID])
REFERENCES [dbo].[BELGE] ([Belge_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BELGE_CARI] CHECK CONSTRAINT [FK_BELGE_CARI_BELGE]
GO
ALTER TABLE [dbo].[HAREKET]  WITH CHECK ADD  CONSTRAINT [FK_HAREKET_BELGE] FOREIGN KEY([Belge_ID])
REFERENCES [dbo].[BELGE] ([Belge_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HAREKET] CHECK CONSTRAINT [FK_HAREKET_BELGE]
GO
