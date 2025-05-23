USE [MOBILPOSERP]
GO
/****** Object:  Table [dbo].[TBLPOSCARI]    Script Date: 12.04.2025 01:05:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLPOSCARI](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirmaKodu] [nvarchar](20) NULL,
	[FirmaUnvan] [nvarchar](70) NULL,
	[Adres1] [nvarchar](50) NULL,
	[Adres2] [nvarchar](50) NULL,
	[Ilce] [nvarchar](15) NULL,
	[Il] [nvarchar](15) NULL,
	[VergiDairesi] [nvarchar](20) NULL,
	[VergiNo] [nchar](10) NULL,
	[TcNo] [nchar](11) NULL,
	[Ad] [nvarchar](20) NULL,
	[SoyaAd] [nvarchar](20) NULL,
	[CepTel] [nchar](11) NULL,
	[SabitTel] [nchar](11) NULL,
	[EMail] [nvarchar](40) NULL,
	[Alias] [nvarchar](40) NULL,
	[FiyatNo] [nvarchar](6) NULL,
	[MusteriKartNo] [nchar](20) NULL,
	[EDonusum] [nvarchar](10) NULL,
 CONSTRAINT [PK_TBLPOSCARI] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBLSATISFATBASLIK]    Script Date: 12.04.2025 01:05:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLSATISFATBASLIK](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SatFat_Firma_Id] [int] NOT NULL,
	[SatFat_BelgeNo] [nvarchar](16) NOT NULL,
	[SatFat_Tarih] [datetime] NOT NULL,
	[SatFat_BelgeNotu] [ntext] NULL,
	[SatFat_ParaBirimi] [nvarchar](3) NULL,
	[SatFat_BelgeKuru] [decimal](18, 2) NULL,
	[SatFat_DepoKodu] [int] NULL,
	[SatFat_İade] [bit] NULL,
	[SatFat_iptal] [bit] NULL,
	[SatFat_Aratoplam] [decimal](18, 4) NULL,
	[SatFat_Toplamiskonto] [decimal](18, 4) NULL,
	[SatFat_KdvToplam] [decimal](18, 4) NULL,
	[SatFat_GenelToplam] [decimal](18, 4) NULL,
	[SatFat_KdvOran1] [decimal](4, 2) NULL,
	[SatFat_KdvOran2] [decimal](4, 2) NULL,
	[SatFat_KdvOran3] [decimal](4, 2) NULL,
	[SatFat_KdvOran4] [decimal](4, 2) NULL,
	[SatFat_KdvOran5] [decimal](4, 2) NULL,
	[SatFat_KdvMatrah1] [decimal](18, 4) NULL,
	[SatFat_KdvMatrah2] [decimal](18, 4) NULL,
	[SatFat_KdvMatrah3] [decimal](18, 4) NULL,
	[SatFat_KdvMatrah4] [decimal](18, 4) NULL,
	[SatFat_KdvMatrah5] [decimal](18, 4) NULL,
	[SatFat_KdvTutari1] [decimal](18, 4) NULL,
	[SatFat_KdvTutari2] [decimal](18, 4) NULL,
	[SatFat_KdvTutari3] [decimal](18, 4) NULL,
	[SatFat_KdvTutari4] [decimal](18, 4) NULL,
	[SatFat_KdvTutari5] [decimal](18, 4) NULL,
	[SatFat_Kod1] [nvarchar](20) NULL,
	[SatFat_Kod2] [nvarchar](20) NULL,
	[SatFat_Kod3] [nvarchar](20) NULL,
	[SatFat_Sube] [nvarchar](15) NULL,
	[SatFat_Kasa] [nvarchar](15) NULL,
	[SatFat_KdvDahil] [bit] NULL,
	[SatFat_EvrakTuru] [nvarchar](10) NULL,
	[SatFat_Vade] [datetime] NULL,
	[SatFat_KaynakProgram] [nvarchar](10) NULL,
	[SatFat_OdemeTuru1] [nvarchar](11) NULL,
	[SatFat_OdemeTuru1Tutar] [decimal](18, 4) NULL,
	[SatFat_OdemeTuru2] [nvarchar](11) NULL,
	[SatFat_OdemeTuru2Tutar] [decimal](18, 4) NULL,
	[SatFat_FirmaUnvani] [nvarchar](70) NULL,
	[SatFat_FirmaAdi] [nvarchar](30) NULL,
	[SatFat_MerkezAktarim] [int] NULL,
 CONSTRAINT [PK_TBLSATISFATBASLIK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBLSATISFATHAREKET]    Script Date: 12.04.2025 01:05:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLSATISFATHAREKET](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BaslikID] [int] NULL,
	[StokKodu] [nvarchar](20) NULL,
	[PluNo] [int] NULL,
	[Barkod] [nvarchar](30) NULL,
	[DepartmanNo] [int] NULL,
	[Kdv] [decimal](4, 2) NULL,
	[Miktar] [decimal](18, 4) NULL,
	[Fiyat] [decimal](18, 4) NULL,
	[Tutar] [decimal](18, 4) NULL,
	[Tarih] [datetime] NULL,
	[BelgeTipi] [nvarchar](4) NULL,
	[KasiyerNo] [int] NULL,
	[DepartmanAdi] [nvarchar](15) NULL,
	[IskOrani] [decimal](4, 2) NULL,
	[IskTutari] [decimal](18, 4) NULL,
	[SERVERCOMPANYID] [int] NULL,
	[UrunAdi] [nvarchar](128) NULL,
	[ParaBirimi] [nvarchar](10) NULL,
	[Maliyet] [decimal](18, 2) NULL,
	[FiyatIndirimli] [decimal](18, 2) NULL,
	[FiyatKdvHaric] [decimal](18, 4) NULL,
	[BelgeNo] [nvarchar](20) NULL,
	[Birim] [nvarchar](10) NULL,
	[DepoID] [int] NULL,
	[DepoAdi] [nvarchar](14) NULL,
	[FirmaKodu] [nvarchar](20) NULL,
	[FirmaUnvani] [nvarchar](70) NULL,
	[KasiyerAdi] [nvarchar](15) NULL,
	[KasaSicil] [nvarchar](15) NULL,
 CONSTRAINT [PK_TBLSATISHAREKET] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TBLSATISFATHAREKET]  WITH NOCHECK ADD  CONSTRAINT [FK_TBLSATISFATHAREKET_TBLSATISFATBASLIK] FOREIGN KEY([BaslikID])
REFERENCES [dbo].[TBLSATISFATBASLIK] ([ID])
GO
ALTER TABLE [dbo].[TBLSATISFATHAREKET] CHECK CONSTRAINT [FK_TBLSATISFATHAREKET_TBLSATISFATBASLIK]
GO
