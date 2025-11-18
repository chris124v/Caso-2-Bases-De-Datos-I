USE [promptads]
GO

/****** Object:  Database [promptads]    Script Date: 2/11/2025 12:36:44 ******/

/****** Object:  Table [dbo].[PAAdBudgets]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAAdBudgets](
	[IdAdBudget] [int] IDENTITY(1,1) NOT NULL,
	[IdCampaignAd] [bigint] NOT NULL,
	[amount] [decimal](16, 2) NOT NULL,
	[IdCurrency] [smallint] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[isCurrent] [bit] NOT NULL,
 CONSTRAINT [PK_PAAdBudgets] PRIMARY KEY CLUSTERED 
(
	[IdAdBudget] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAAddresses]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAAddresses](
	[IdAddress] [int] IDENTITY(1,1) NOT NULL,
	[line1] [varchar](200) NOT NULL,
	[line2] [varchar](200) NOT NULL,
	[zipCode] [varchar](10) NOT NULL,
	[geolocation] [geography] NULL,
	[IdCity] [int] NOT NULL,
 CONSTRAINT [PK__PAAddres__F1CFF37F90F90B93] PRIMARY KEY CLUSTERED 
(
	[IdAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAAdMediafiles]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAAdMediafiles](
	[IdAdMediafile] [int] IDENTITY(1,1) NOT NULL,
	[IdCampaignAd] [bigint] NOT NULL,
	[IdMediafile] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[deleted] [bit] NOT NULL,
 CONSTRAINT [PK__PAAdMedi__E7D42D8EA3DFFD64] PRIMARY KEY CLUSTERED 
(
	[IdAdMediafile] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAAdPerformances]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAAdPerformances](
	[IdAdPerformance] [bigint] IDENTITY(1,1) NOT NULL,
	[IdPublishedAd] [bigint] NOT NULL,
	[reach] [bigint] NOT NULL,
	[budget] [decimal](16, 2) NOT NULL,
	[expenses] [decimal](16, 2) NOT NULL,
	[revenue] [decimal](16, 2) NOT NULL,
	[IdAdSentiment] [tinyint] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[IdLastAdPerformance] [bigint] NULL,
	[isCurrent] [bit] NOT NULL,
 CONSTRAINT [PK_PAAdPerformances] PRIMARY KEY CLUSTERED 
(
	[IdAdPerformance] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAAdPublics]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAAdPublics](
	[IdCampaignPublic] [int] IDENTITY(1,1) NOT NULL,
	[IdCampaignAd] [bigint] NOT NULL,
	[IdTargetPublic] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[enabled] [bit] NULL,
 CONSTRAINT [PK__PAAdPubl__666912D3597FC38D] PRIMARY KEY CLUSTERED 
(
	[IdCampaignPublic] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAAdSchedules]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAAdSchedules](
	[IdAdSchedule] [int] IDENTITY(1,1) NOT NULL,
	[IdPublishedAd] [bigint] NOT NULL,
	[IdSchedule] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK__PAAdSche__BFE2CB055A0425C1] PRIMARY KEY CLUSTERED 
(
	[IdAdSchedule] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAAdSentiments]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAAdSentiments](
	[IdAdSentiment] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_PAAdSentiments] PRIMARY KEY CLUSTERED 
(
	[IdAdSentiment] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAAdStatus]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAAdStatus](
	[IdAdStatus] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdAdStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAAdTypes]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAAdTypes](
	[IdAdType] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdAdType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PACampaignAds]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PACampaignAds](
	[IdCampaignAd] [bigint] IDENTITY(1,1) NOT NULL,
	[IdCampaign] [int] NOT NULL,
	[title] [varchar](80) NOT NULL,
	[description] [varchar](200) NOT NULL,
	[IdAdType] [tinyint] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[checksum] [varbinary](255) NULL,
 CONSTRAINT [PK__PACampai__6F5FC8BEA9FAB8BA] PRIMARY KEY CLUSTERED 
(
	[IdCampaignAd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PACampaigns]    Script Date: 15/11/2025 17:02:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PACampaigns](
	[IdCampaign] [int] IDENTITY(1,1) NOT NULL,
	[IdOrganization] [int] NOT NULL,
	[name] [varchar](60) NOT NULL,
	[description] [varchar](200) NOT NULL,
	[IdCity] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[startsAt] [date] NOT NULL,
	[endsAt] [date] NOT NULL,
	[IdCampaignStatus] [tinyint] NOT NULL,
	[deleted] [bit] NOT NULL,
	[checksum] [varbinary](255) NULL,
 CONSTRAINT [PK__PACampai__0AC4158316881AAB] PRIMARY KEY CLUSTERED 
(
	[IdCampaign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PACampaignStatus]    Script Date: 15/11/2025 17:02:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PACampaignStatus](
	[IdCampaignStatus] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_PACampaignStatus] PRIMARY KEY CLUSTERED 
(
	[IdCampaignStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PACampaignTransactions]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PACampaignTransactions](
	[IdCampaignTransaction] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](80) NOT NULL,
	[amount] [decimal](16, 2) NOT NULL,
	[IdCurrency] [smallint] NOT NULL,
	[IdCampaignTransactionType] [tinyint] NOT NULL,
	[createdAt] [datetime] NULL,
	[IdCampaignAd] [bigint] NOT NULL,
	[checksum] [varbinary](255) NULL,
 CONSTRAINT [PK__PACampai__BDD0B9753F316E50] PRIMARY KEY CLUSTERED 
(
	[IdCampaignTransaction] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PACampaignTransactionTypes]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PACampaignTransactionTypes](
	[IdCampaignTransactionType] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCampaignTransactionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAChannels]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAChannels](
	[IdChannel] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](60) NOT NULL,
 CONSTRAINT [PK__PAContac__21C9191F5E9C4928] PRIMARY KEY CLUSTERED 
(
	[IdChannel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PACities]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PACities](
	[IdCity] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](60) NOT NULL,
	[IdState] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCity] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PACountries]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PACountries](
	[IdCountry] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](60) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCountry] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PACurrencies]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PACurrencies](
	[IdCurrency] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](60) NOT NULL,
	[isoCode] [varchar](3) NOT NULL,
	[currencySymbol] [varchar](5) NOT NULL,
	[IdCountry] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCurrency] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAExchangeRates]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAExchangeRates](
	[IdExchangeRate] [smallint] IDENTITY(1,1) NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NULL,
	[exchangeRate] [decimal](10, 4) NOT NULL,
	[IdCurrencySource] [smallint] NOT NULL,
	[IdCurrencyDestiny] [smallint] NOT NULL,
	[isCurrent] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdExchangeRate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAFeaturePerSubscription]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAFeaturePerSubscription](
	[IdFeaturePerSubscription] [int] IDENTITY(1,1) NOT NULL,
	[IdSubscription] [smallint] NOT NULL,
	[IdSubscriptionFeature] [int] NOT NULL,
	[value] [varchar](80) NOT NULL,
	[unlimited] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdFeaturePerSubscription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAInfluencerContacts]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAInfluencerContacts](
	[IdInfluencerContact] [int] IDENTITY(1,1) NOT NULL,
	[IdInfluencer] [int] NOT NULL,
	[IdChannel] [smallint] NOT NULL,
	[value] [varchar](80) NOT NULL,
	[createdAt] [datetime] NULL,
	[enabled] [bit] NULL,
	[deleted] [bit] NULL,
 CONSTRAINT [PK__PAInflue__98512A2B5F07EFB0] PRIMARY KEY CLUSTERED 
(
	[IdInfluencerContact] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAInfluencerPublics]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAInfluencerPublics](
	[IdInfluencerPublic] [int] IDENTITY(1,1) NOT NULL,
	[IdInfluencer] [int] NOT NULL,
	[IdTargetPublic] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_PAInfluencerPublics] PRIMARY KEY CLUSTERED 
(
	[IdInfluencerPublic] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAInfluencers]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAInfluencers](
	[IdInfluencer] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](60) NOT NULL,
	[followers] [bigint] NOT NULL,
	[bio] [varchar](250) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdInfluencer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PALogLevels]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PALogLevels](
	[IdLogLevel] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdLogLevel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PALogs]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PALogs](
	[IdLog] [bigint] IDENTITY(1,1) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[description] [varchar](500) NOT NULL,
	[computer] [varchar](100) NOT NULL,
	[username] [varchar](50) NULL,
	[IdRef1] [bigint] NULL,
	[IdRef2] [bigint] NULL,
	[value1] [varchar](200) NULL,
	[value2] [varchar](200) NULL,
	[IdLogType] [tinyint] NOT NULL,
	[IdLogLevel] [tinyint] NOT NULL,
	[IdLogSource] [tinyint] NOT NULL,
	[checksum] [varbinary](250) NULL,
 CONSTRAINT [PK__PA_Logs__0C54DBC67590FB34] PRIMARY KEY CLUSTERED 
(
	[IdLog] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PALogSources]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PALogSources](
	[IdLogSource] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdLogSource] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PALogTypes]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PALogTypes](
	[IdLogType] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdLogType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAMediafiles]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAMediafiles](
	[IdMediafile] [int] IDENTITY(1,1) NOT NULL,
	[encryptedURL] [varbinary](255) NOT NULL,
	[IdMediafileType] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdMediafile] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAMediafileTypes]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAMediafileTypes](
	[IdMediafileType] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdMediafileType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAOrganizationContacts]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAOrganizationContacts](
	[IdOrganizationContact] [int] IDENTITY(1,1) NOT NULL,
	[IdOrganization] [int] NOT NULL,
	[IdChannel] [smallint] NOT NULL,
	[value] [varchar](80) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL,
	[deleted] [bit] NOT NULL,
 CONSTRAINT [PK_PAOrganizationContacts] PRIMARY KEY CLUSTERED 
(
	[IdOrganizationContact] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAOrganizations]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAOrganizations](
	[IdOrganization] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](60) NOT NULL,
	[legalName] [varchar](60) NULL,
	[email] [varchar](80) NULL,
	[createdAt] [datetime] NULL,
	[IdOrganizationStatus] [tinyint] NOT NULL,
 CONSTRAINT [PK__PAOrgani__C14A1C27D0B9E691] PRIMARY KEY CLUSTERED 
(
	[IdOrganization] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAOrganizationStatus]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAOrganizationStatus](
	[IdOrganizationStatus] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdOrganizationStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAPaymentMethods]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAPaymentMethods](
	[IdPaymentMethod] [tinyint] IDENTITY(1,1) NOT NULL,
	[serviceName] [varchar](30) NOT NULL,
	[IdAPISetup] [int] NULL,
	[logoIconURL] [varchar](255) NULL,
	[enabled] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPaymentMethod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAPayments]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAPayments](
	[IdPayment] [bigint] IDENTITY(1,1) NOT NULL,
	[IdPaymentMethod] [tinyint] NOT NULL,
	[IdPaymentType] [tinyint] NOT NULL,
	[transactionAmount] [decimal](16, 2) NOT NULL,
	[IdCurrency] [smallint] NOT NULL,
	[description] [varchar](100) NOT NULL,
	[createdAt] [datetime] NULL,
	[IdPaymentStatus] [tinyint] NOT NULL,
	[checksum] [varbinary](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPayment] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAPaymentStatus]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAPaymentStatus](
	[IdPaymentStatus] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](60) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPaymentStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAPaymentTypes]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAPaymentTypes](
	[IdPaymentType] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPaymentType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAPermissions]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAPermissions](
	[IdPermission] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](200) NOT NULL,
	[code] [varchar](20) NOT NULL,
	[module] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPermission] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAPermissionXRoles]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAPermissionXRoles](
	[IdPermission] [int] NOT NULL,
	[IdRole] [int] NOT NULL,
	[createdAt] [datetime] NULL,
	[enabled] [bit] NULL,
	[checksum] [varbinary](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPermission] ASC,
	[IdRole] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAPublicFeatures]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAPublicFeatures](
	[IdPublicFeature] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
	[dataType] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPublicFeature] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAPublicValues]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAPublicValues](
	[IdPublicValue] [int] IDENTITY(1,1) NOT NULL,
	[IdPublicFeature] [smallint] NOT NULL,
	[name] [varchar](80) NOT NULL,
	[minValue] [varchar](80) NULL,
	[maxValue] [varchar](80) NULL,
	[value] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPublicValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAPublishedAds]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAPublishedAds](
	[IdPublishedAd] [bigint] IDENTITY(1,1) NOT NULL,
	[IdCampaignAd] [bigint] NOT NULL,
	[IdOrganizationContact] [int] NULL,
	[IdInfluencerContact] [int] NULL,
	[body] [text] NULL,
	[redirectURL] [varchar](255) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[IdAdStatus] [tinyint] NOT NULL,
 CONSTRAINT [PK_PAPublishedAds] PRIMARY KEY CLUSTERED 
(
	[IdPublishedAd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAReactionsPerAd]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAReactionsPerAd](
	[IdReaction] [bigint] IDENTITY(1,1) NOT NULL,
	[IdAdPerformance] [bigint] NOT NULL,
	[IdReactionType] [tinyint] NOT NULL,
	[reactionNumber] [bigint] NOT NULL,
 CONSTRAINT [PK__PAReacti__6BDAE8072027B16C] PRIMARY KEY CLUSTERED 
(
	[IdReaction] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAReactionTypes]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAReactionTypes](
	[IdReactionType] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](20) NOT NULL,
	[reactionWeight] [smallint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdReactionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PARoles]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PARoles](
	[IdRole] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
	[description] [varchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdRole] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAScheduleRecurrencies]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAScheduleRecurrencies](
	[IdScheduleRecurrency] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[intervalDays] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdScheduleRecurrency] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PASchedules]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PASchedules](
	[IdSchedule] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
	[IdScheduleRecurrency] [tinyint] NOT NULL,
	[startDate] [date] NOT NULL,
	[endDate] [date] NOT NULL,
	[startHours] [time](7) NOT NULL,
	[endHours] [time](7) NOT NULL,
	[lastExecute] [datetime] NULL,
	[nextExecute] [datetime] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL,
	[deleted] [bit] NOT NULL,
 CONSTRAINT [PK__PASchedu__D16D3B620D80FB8E] PRIMARY KEY CLUSTERED 
(
	[IdSchedule] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAStates]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAStates](
	[IdState] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](60) NOT NULL,
	[IdCountry] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdState] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PASubscriptionFeatures]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PASubscriptionFeatures](
	[IdSubscriptionFeature] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
	[description] [varchar](200) NOT NULL,
	[dataType] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdSubscriptionFeature] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PASubscriptionPerUser]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PASubscriptionPerUser](
	[IdSubscriptionPerUser] [int] IDENTITY(1,1) NOT NULL,
	[IdUser] [int] NOT NULL,
	[IdSubscription] [smallint] NOT NULL,
	[enabled] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdSubscriptionPerUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PASubscriptions]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PASubscriptions](
	[IdSubscription] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
	[description] [varchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdSubscription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PATargetConfigurations]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PATargetConfigurations](
	[IdTargetConfiguration] [int] IDENTITY(1,1) NOT NULL,
	[IdTargetPublic] [int] NOT NULL,
	[IdPublicValue] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL,
	[deleted] [bit] NOT NULL,
 CONSTRAINT [PK__PATarget__4B697FD10DB35885] PRIMARY KEY CLUSTERED 
(
	[IdTargetConfiguration] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PATargetPublics]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PATargetPublics](
	[IdTargetPublic] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](80) NOT NULL,
	[description] [varchar](200) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK__PATarget__E38DC5943A4FF665] PRIMARY KEY CLUSTERED 
(
	[IdTargetPublic] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAUserPerOrganization]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAUserPerOrganization](
	[IdUserPerOrganization] [int] IDENTITY(1,1) NOT NULL,
	[IdUser] [int] NOT NULL,
	[IdOrganization] [int] NOT NULL,
	[enabled] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUserPerOrganization] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAUsers]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAUsers](
	[IdUser] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [varchar](50) NOT NULL,
	[lastName] [varchar](50) NOT NULL,
	[email] [varchar](80) NOT NULL,
	[passwordHash] [varbinary](250) NOT NULL,
	[createdAt] [datetime] NULL,
	[updatedAt] [datetime] NULL,
	[lastLogin] [datetime] NULL,
	[IdUserStatus] [tinyint] NOT NULL,
	[checksum] [varbinary](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAUserStatus]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAUserStatus](
	[IdUserStatus] [tinyint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUserStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAUserXRoles]    Script Date: 2/11/2025 12:36:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAUserXRoles](
	[IdUserRole] [int] IDENTITY(1,1) NOT NULL,
	[IdUser] [int] NOT NULL,
	[IdRole] [int] NOT NULL,
	[createdAt] [datetime] NULL,
	[enabled] [bit] NULL,
	[checksum] [varbinary](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUserRole] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAAdBudgets] ADD  CONSTRAINT [DF_PAAdBudgets_createdAt]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAAdBudgets] ADD  CONSTRAINT [DF_PAAdBudgets_isCurrent]  DEFAULT ((1)) FOR [isCurrent]
GO
ALTER TABLE [dbo].[PAAdMediafiles] ADD  CONSTRAINT [DF__PAAdMedia__creat__0C85DE4D]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAAdMediafiles] ADD  CONSTRAINT [DF__PAAdMedia__delet__0D7A0286]  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[PAAdPerformances] ADD  CONSTRAINT [DF_PAAdPerformances_reach]  DEFAULT ((0)) FOR [reach]
GO
ALTER TABLE [dbo].[PAAdPerformances] ADD  CONSTRAINT [DF_PAAdPerformances_createdAt]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAAdPerformances] ADD  CONSTRAINT [DF_PAAdPerformances_isCurrent]  DEFAULT ((1)) FOR [isCurrent]
GO
ALTER TABLE [dbo].[PAAdPublics] ADD  CONSTRAINT [DF_PAAdPublics_createdAt]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAAdPublics] ADD  CONSTRAINT [DF__PAAdPubli__enabl__2A164134]  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PAAdSchedules] ADD  CONSTRAINT [DF__PAAdSched__enabl__07C12930]  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PACampaignAds] ADD  CONSTRAINT [DF__PACampaig__creat__00200768]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PACampaignAds] ADD  CONSTRAINT [DF__PACampaig__updat__01142BA1]  DEFAULT (getdate()) FOR [updatedAt]
GO
ALTER TABLE [dbo].[PACampaigns] ADD  CONSTRAINT [DF__PACampaig__creat__73BA3083]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PACampaigns] ADD  CONSTRAINT [DF__PACampaig__updat__74AE54BC]  DEFAULT (getdate()) FOR [updatedAt]
GO
ALTER TABLE [dbo].[PACampaigns] ADD  CONSTRAINT [DF__PACampaig__enabl__75A278F5]  DEFAULT ((1)) FOR [IdCampaignStatus]
GO
ALTER TABLE [dbo].[PACampaigns] ADD  CONSTRAINT [DF__PACampaig__delet__76969D2E]  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[PACampaignTransactions] ADD  CONSTRAINT [DF__PACampaig__creat__3A4CA8FD]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAExchangeRates] ADD  DEFAULT ((1)) FOR [isCurrent]
GO
ALTER TABLE [dbo].[PAInfluencerContacts] ADD  CONSTRAINT [DF__PAInfluen__creat__2180FB33]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAInfluencerContacts] ADD  CONSTRAINT [DF__PAInfluen__enabl__22751F6C]  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PAInfluencerContacts] ADD  CONSTRAINT [DF__PAInfluen__delet__236943A5]  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[PAInfluencerPublics] ADD  CONSTRAINT [DF_PAInfluencerPublics_createdAt]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAInfluencerPublics] ADD  CONSTRAINT [DF_PAInfluencerPublics_enabled]  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PALogs] ADD  CONSTRAINT [DF__PA_Logs__created__6AEFE058]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAOrganizationContacts] ADD  CONSTRAINT [DF_PAOrganizationContacts_enabled]  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PAOrganizationContacts] ADD  CONSTRAINT [DF_PAOrganizationContacts_deleted]  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[PAPaymentMethods] ADD  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PAPayments] ADD  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAPermissionXRoles] ADD  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAPermissionXRoles] ADD  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PAPublishedAds] ADD  CONSTRAINT [DF_PAPublishedAds_createdAt]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAPublishedAds] ADD  CONSTRAINT [DF_PAPublishedAds_enabled]  DEFAULT ((1)) FOR [IdAdStatus]
GO
ALTER TABLE [dbo].[PASchedules] ADD  CONSTRAINT [DF__PASchedul__enabl__6EF57B66]  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PASchedules] ADD  CONSTRAINT [DF__PASchedul__delet__6FE99F9F]  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[PASubscriptionPerUser] ADD  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PATargetConfigurations] ADD  CONSTRAINT [DF_PATargetConfigurations_createdAt]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PATargetConfigurations] ADD  CONSTRAINT [DF__PATargetC__enabl__339FAB6E]  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PATargetConfigurations] ADD  CONSTRAINT [DF_PATargetConfigurations_deleted]  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[PATargetPublics] ADD  CONSTRAINT [DF_PATargetPublics_createdAt]  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PATargetPublics] ADD  CONSTRAINT [DF_PATargetPublics_enabled]  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PAUserPerOrganization] ADD  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PAUsers] ADD  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAUsers] ADD  DEFAULT (getdate()) FOR [updatedAt]
GO
ALTER TABLE [dbo].[PAUserXRoles] ADD  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [dbo].[PAUserXRoles] ADD  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[PAAdBudgets]  WITH CHECK ADD  CONSTRAINT [FK_PAAdBudgets_PACampaignAds] FOREIGN KEY([IdCampaignAd])
REFERENCES [dbo].[PACampaignAds] ([IdCampaignAd])
GO
ALTER TABLE [dbo].[PAAdBudgets] CHECK CONSTRAINT [FK_PAAdBudgets_PACampaignAds]
GO
ALTER TABLE [dbo].[PAAdBudgets]  WITH CHECK ADD  CONSTRAINT [FK_PAAdBudgets_PACurrencies] FOREIGN KEY([IdCurrency])
REFERENCES [dbo].[PACurrencies] ([IdCurrency])
GO
ALTER TABLE [dbo].[PAAdBudgets] CHECK CONSTRAINT [FK_PAAdBudgets_PACurrencies]
GO
ALTER TABLE [dbo].[PAAddresses]  WITH CHECK ADD  CONSTRAINT [FK__PAAddress__IdCit__3F466844] FOREIGN KEY([IdCity])
REFERENCES [dbo].[PACities] ([IdCity])
GO
ALTER TABLE [dbo].[PAAddresses] CHECK CONSTRAINT [FK__PAAddress__IdCit__3F466844]
GO
ALTER TABLE [dbo].[PAAdMediafiles]  WITH CHECK ADD  CONSTRAINT [FK__PAAdMedia__IdCam__0E6E26BF] FOREIGN KEY([IdCampaignAd])
REFERENCES [dbo].[PACampaignAds] ([IdCampaignAd])
GO
ALTER TABLE [dbo].[PAAdMediafiles] CHECK CONSTRAINT [FK__PAAdMedia__IdCam__0E6E26BF]
GO
ALTER TABLE [dbo].[PAAdMediafiles]  WITH CHECK ADD  CONSTRAINT [FK__PAAdMedia__IdMed__0F624AF8] FOREIGN KEY([IdMediafile])
REFERENCES [dbo].[PAMediafiles] ([IdMediafile])
GO
ALTER TABLE [dbo].[PAAdMediafiles] CHECK CONSTRAINT [FK__PAAdMedia__IdMed__0F624AF8]
GO
ALTER TABLE [dbo].[PAAdPerformances]  WITH CHECK ADD  CONSTRAINT [FK_PAAdPerformances_PAAdPerformances] FOREIGN KEY([IdLastAdPerformance])
REFERENCES [dbo].[PAAdPerformances] ([IdAdPerformance])
GO
ALTER TABLE [dbo].[PAAdPerformances] CHECK CONSTRAINT [FK_PAAdPerformances_PAAdPerformances]
GO
ALTER TABLE [dbo].[PAAdPerformances]  WITH CHECK ADD  CONSTRAINT [FK_PAAdPerformances_PAAdSentiments] FOREIGN KEY([IdAdSentiment])
REFERENCES [dbo].[PAAdSentiments] ([IdAdSentiment])
GO
ALTER TABLE [dbo].[PAAdPerformances] CHECK CONSTRAINT [FK_PAAdPerformances_PAAdSentiments]
GO
ALTER TABLE [dbo].[PAAdPerformances]  WITH CHECK ADD  CONSTRAINT [FK_PAAdPerformances_PAPublishedAds] FOREIGN KEY([IdPublishedAd])
REFERENCES [dbo].[PAPublishedAds] ([IdPublishedAd])
GO
ALTER TABLE [dbo].[PAAdPerformances] CHECK CONSTRAINT [FK_PAAdPerformances_PAPublishedAds]
GO
ALTER TABLE [dbo].[PAAdPublics]  WITH CHECK ADD  CONSTRAINT [FK__PAAdPubli__IdCam__2B0A656D] FOREIGN KEY([IdCampaignAd])
REFERENCES [dbo].[PACampaignAds] ([IdCampaignAd])
GO
ALTER TABLE [dbo].[PAAdPublics] CHECK CONSTRAINT [FK__PAAdPubli__IdCam__2B0A656D]
GO
ALTER TABLE [dbo].[PAAdPublics]  WITH CHECK ADD  CONSTRAINT [FK__PAAdPubli__IdTar__2BFE89A6] FOREIGN KEY([IdTargetPublic])
REFERENCES [dbo].[PATargetPublics] ([IdTargetPublic])
GO
ALTER TABLE [dbo].[PAAdPublics] CHECK CONSTRAINT [FK__PAAdPubli__IdTar__2BFE89A6]
GO
ALTER TABLE [dbo].[PAAdSchedules]  WITH CHECK ADD  CONSTRAINT [FK__PAAdSched__IdSch__09A971A2] FOREIGN KEY([IdSchedule])
REFERENCES [dbo].[PASchedules] ([IdSchedule])
GO
ALTER TABLE [dbo].[PAAdSchedules] CHECK CONSTRAINT [FK__PAAdSched__IdSch__09A971A2]
GO
ALTER TABLE [dbo].[PAAdSchedules]  WITH CHECK ADD  CONSTRAINT [FK_PAAdSchedules_PAPublishedAds] FOREIGN KEY([IdPublishedAd])
REFERENCES [dbo].[PAPublishedAds] ([IdPublishedAd])
GO
ALTER TABLE [dbo].[PAAdSchedules] CHECK CONSTRAINT [FK_PAAdSchedules_PAPublishedAds]
GO
ALTER TABLE [dbo].[PACampaignAds]  WITH CHECK ADD  CONSTRAINT [FK__PACampaig__IdAdT__03F0984C] FOREIGN KEY([IdAdType])
REFERENCES [dbo].[PAAdTypes] ([IdAdType])
GO
ALTER TABLE [dbo].[PACampaignAds] CHECK CONSTRAINT [FK__PACampaig__IdAdT__03F0984C]
GO
ALTER TABLE [dbo].[PACampaignAds]  WITH CHECK ADD  CONSTRAINT [FK__PACampaig__IdCam__02084FDA] FOREIGN KEY([IdCampaign])
REFERENCES [dbo].[PACampaigns] ([IdCampaign])
GO
ALTER TABLE [dbo].[PACampaignAds] CHECK CONSTRAINT [FK__PACampaig__IdCam__02084FDA]
GO
ALTER TABLE [dbo].[PACampaigns]  WITH CHECK ADD  CONSTRAINT [FK__PACampaig__IdOrg__778AC167] FOREIGN KEY([IdOrganization])
REFERENCES [dbo].[PAOrganizations] ([IdOrganization])
GO
ALTER TABLE [dbo].[PACampaigns] CHECK CONSTRAINT [FK__PACampaig__IdOrg__778AC167]
GO
ALTER TABLE [dbo].[PACampaigns]  WITH CHECK ADD  CONSTRAINT [FK_PACampaigns_PACampaignStatus] FOREIGN KEY([IdCampaignStatus])
REFERENCES [dbo].[PACampaignStatus] ([IdCampaignStatus])
GO
ALTER TABLE [dbo].[PACampaigns] CHECK CONSTRAINT [FK_PACampaigns_PACampaignStatus]
GO
ALTER TABLE [dbo].[PACampaigns]  WITH CHECK ADD  CONSTRAINT [FK_PACampaigns_PACities] FOREIGN KEY([IdCity])
REFERENCES [dbo].[PACities] ([IdCity])
GO
ALTER TABLE [dbo].[PACampaigns] CHECK CONSTRAINT [FK_PACampaigns_PACities]
GO
ALTER TABLE [dbo].[PACampaignTransactions]  WITH CHECK ADD  CONSTRAINT [FK__PACampaig__IdCam__3B40CD36] FOREIGN KEY([IdCampaignTransactionType])
REFERENCES [dbo].[PACampaignTransactionTypes] ([IdCampaignTransactionType])
GO
ALTER TABLE [dbo].[PACampaignTransactions] CHECK CONSTRAINT [FK__PACampaig__IdCam__3B40CD36]
GO
ALTER TABLE [dbo].[PACampaignTransactions]  WITH CHECK ADD  CONSTRAINT [FK_PACampaignTransactions_PACampaignAds] FOREIGN KEY([IdCampaignAd])
REFERENCES [dbo].[PACampaignAds] ([IdCampaignAd])
GO
ALTER TABLE [dbo].[PACampaignTransactions] CHECK CONSTRAINT [FK_PACampaignTransactions_PACampaignAds]
GO
ALTER TABLE [dbo].[PACampaignTransactions]  WITH CHECK ADD  CONSTRAINT [FK_PACampaignTransactions_PACurrencies] FOREIGN KEY([IdCurrency])
REFERENCES [dbo].[PACurrencies] ([IdCurrency])
GO
ALTER TABLE [dbo].[PACampaignTransactions] CHECK CONSTRAINT [FK_PACampaignTransactions_PACurrencies]
GO
ALTER TABLE [dbo].[PACities]  WITH CHECK ADD FOREIGN KEY([IdState])
REFERENCES [dbo].[PAStates] ([IdState])
GO
ALTER TABLE [dbo].[PACurrencies]  WITH CHECK ADD FOREIGN KEY([IdCountry])
REFERENCES [dbo].[PACountries] ([IdCountry])
GO
ALTER TABLE [dbo].[PAExchangeRates]  WITH CHECK ADD FOREIGN KEY([IdCurrencySource])
REFERENCES [dbo].[PACurrencies] ([IdCurrency])
GO
ALTER TABLE [dbo].[PAExchangeRates]  WITH CHECK ADD FOREIGN KEY([IdCurrencyDestiny])
REFERENCES [dbo].[PACurrencies] ([IdCurrency])
GO
ALTER TABLE [dbo].[PAFeaturePerSubscription]  WITH CHECK ADD FOREIGN KEY([IdSubscription])
REFERENCES [dbo].[PASubscriptions] ([IdSubscription])
GO
ALTER TABLE [dbo].[PAFeaturePerSubscription]  WITH CHECK ADD FOREIGN KEY([IdSubscriptionFeature])
REFERENCES [dbo].[PASubscriptionFeatures] ([IdSubscriptionFeature])
GO
ALTER TABLE [dbo].[PAInfluencerContacts]  WITH CHECK ADD  CONSTRAINT [FK__PAInfluen__IdCon__25518C17] FOREIGN KEY([IdChannel])
REFERENCES [dbo].[PAChannels] ([IdChannel])
GO
ALTER TABLE [dbo].[PAInfluencerContacts] CHECK CONSTRAINT [FK__PAInfluen__IdCon__25518C17]
GO
ALTER TABLE [dbo].[PAInfluencerContacts]  WITH CHECK ADD  CONSTRAINT [FK__PAInfluen__IdInf__245D67DE] FOREIGN KEY([IdInfluencer])
REFERENCES [dbo].[PAInfluencers] ([IdInfluencer])
GO
ALTER TABLE [dbo].[PAInfluencerContacts] CHECK CONSTRAINT [FK__PAInfluen__IdInf__245D67DE]
GO
ALTER TABLE [dbo].[PAInfluencerPublics]  WITH CHECK ADD  CONSTRAINT [FK_PAInfluencerPublics_PAInfluencers] FOREIGN KEY([IdInfluencer])
REFERENCES [dbo].[PAInfluencers] ([IdInfluencer])
GO
ALTER TABLE [dbo].[PAInfluencerPublics] CHECK CONSTRAINT [FK_PAInfluencerPublics_PAInfluencers]
GO
ALTER TABLE [dbo].[PAInfluencerPublics]  WITH CHECK ADD  CONSTRAINT [FK_PAInfluencerPublics_PATargetPublics] FOREIGN KEY([IdTargetPublic])
REFERENCES [dbo].[PATargetPublics] ([IdTargetPublic])
GO
ALTER TABLE [dbo].[PAInfluencerPublics] CHECK CONSTRAINT [FK_PAInfluencerPublics_PATargetPublics]
GO
ALTER TABLE [dbo].[PALogs]  WITH CHECK ADD  CONSTRAINT [FK__PA_Logs__IdLogLe__6CD828CA] FOREIGN KEY([IdLogLevel])
REFERENCES [dbo].[PALogLevels] ([IdLogLevel])
GO
ALTER TABLE [dbo].[PALogs] CHECK CONSTRAINT [FK__PA_Logs__IdLogLe__6CD828CA]
GO
ALTER TABLE [dbo].[PALogs]  WITH CHECK ADD  CONSTRAINT [FK__PA_Logs__IdLogSo__6DCC4D03] FOREIGN KEY([IdLogSource])
REFERENCES [dbo].[PALogSources] ([IdLogSource])
GO
ALTER TABLE [dbo].[PALogs] CHECK CONSTRAINT [FK__PA_Logs__IdLogSo__6DCC4D03]
GO
ALTER TABLE [dbo].[PALogs]  WITH CHECK ADD  CONSTRAINT [FK__PA_Logs__IdLogTy__6BE40491] FOREIGN KEY([IdLogType])
REFERENCES [dbo].[PALogTypes] ([IdLogType])
GO
ALTER TABLE [dbo].[PALogs] CHECK CONSTRAINT [FK__PA_Logs__IdLogTy__6BE40491]
GO
ALTER TABLE [dbo].[PAMediafiles]  WITH CHECK ADD FOREIGN KEY([IdMediafileType])
REFERENCES [dbo].[PAMediafileTypes] ([IdMediafileType])
GO
ALTER TABLE [dbo].[PAOrganizationContacts]  WITH CHECK ADD  CONSTRAINT [FK_PAOrganizationContacts_PAChannels] FOREIGN KEY([IdChannel])
REFERENCES [dbo].[PAChannels] ([IdChannel])
GO
ALTER TABLE [dbo].[PAOrganizationContacts] CHECK CONSTRAINT [FK_PAOrganizationContacts_PAChannels]
GO
ALTER TABLE [dbo].[PAOrganizationContacts]  WITH CHECK ADD  CONSTRAINT [FK_PAOrganizationContacts_PAOrganizations] FOREIGN KEY([IdOrganization])
REFERENCES [dbo].[PAOrganizations] ([IdOrganization])
GO
ALTER TABLE [dbo].[PAOrganizationContacts] CHECK CONSTRAINT [FK_PAOrganizationContacts_PAOrganizations]
GO
ALTER TABLE [dbo].[PAOrganizations]  WITH CHECK ADD  CONSTRAINT [FK_PAOrganizations_PAOrganizationStatus] FOREIGN KEY([IdOrganizationStatus])
REFERENCES [dbo].[PAOrganizationStatus] ([IdOrganizationStatus])
GO
ALTER TABLE [dbo].[PAOrganizations] CHECK CONSTRAINT [FK_PAOrganizations_PAOrganizationStatus]
GO
ALTER TABLE [dbo].[PAPayments]  WITH CHECK ADD FOREIGN KEY([IdCurrency])
REFERENCES [dbo].[PACurrencies] ([IdCurrency])
GO
ALTER TABLE [dbo].[PAPayments]  WITH CHECK ADD FOREIGN KEY([IdPaymentMethod])
REFERENCES [dbo].[PAPaymentMethods] ([IdPaymentMethod])
GO
ALTER TABLE [dbo].[PAPayments]  WITH CHECK ADD FOREIGN KEY([IdPaymentType])
REFERENCES [dbo].[PAPaymentTypes] ([IdPaymentType])
GO
ALTER TABLE [dbo].[PAPayments]  WITH CHECK ADD FOREIGN KEY([IdPaymentStatus])
REFERENCES [dbo].[PAPaymentStatus] ([IdPaymentStatus])
GO
ALTER TABLE [dbo].[PAPermissionXRoles]  WITH CHECK ADD FOREIGN KEY([IdPermission])
REFERENCES [dbo].[PAPermissions] ([IdPermission])
GO
ALTER TABLE [dbo].[PAPermissionXRoles]  WITH CHECK ADD FOREIGN KEY([IdRole])
REFERENCES [dbo].[PARoles] ([IdRole])
GO
ALTER TABLE [dbo].[PAPublicValues]  WITH CHECK ADD FOREIGN KEY([IdPublicFeature])
REFERENCES [dbo].[PAPublicFeatures] ([IdPublicFeature])
GO
ALTER TABLE [dbo].[PAPublishedAds]  WITH CHECK ADD  CONSTRAINT [FK_PAPublishedAds_PAAdStatus] FOREIGN KEY([IdAdStatus])
REFERENCES [dbo].[PAAdStatus] ([IdAdStatus])
GO
ALTER TABLE [dbo].[PAPublishedAds] CHECK CONSTRAINT [FK_PAPublishedAds_PAAdStatus]
GO
ALTER TABLE [dbo].[PAPublishedAds]  WITH CHECK ADD  CONSTRAINT [FK_PAPublishedAds_PACampaignAds] FOREIGN KEY([IdCampaignAd])
REFERENCES [dbo].[PACampaignAds] ([IdCampaignAd])
GO
ALTER TABLE [dbo].[PAPublishedAds] CHECK CONSTRAINT [FK_PAPublishedAds_PACampaignAds]
GO
ALTER TABLE [dbo].[PAPublishedAds]  WITH CHECK ADD  CONSTRAINT [FK_PAPublishedAds_PAInfluencerContacts] FOREIGN KEY([IdInfluencerContact])
REFERENCES [dbo].[PAInfluencerContacts] ([IdInfluencerContact])
GO
ALTER TABLE [dbo].[PAPublishedAds] CHECK CONSTRAINT [FK_PAPublishedAds_PAInfluencerContacts]
GO
ALTER TABLE [dbo].[PAPublishedAds]  WITH CHECK ADD  CONSTRAINT [FK_PAPublishedAds_PAOrganizationContacts] FOREIGN KEY([IdOrganizationContact])
REFERENCES [dbo].[PAOrganizationContacts] ([IdOrganizationContact])
GO
ALTER TABLE [dbo].[PAPublishedAds] CHECK CONSTRAINT [FK_PAPublishedAds_PAOrganizationContacts]
GO
ALTER TABLE [dbo].[PAReactionsPerAd]  WITH CHECK ADD  CONSTRAINT [FK__PAReactio__IdRea__151B244E] FOREIGN KEY([IdReactionType])
REFERENCES [dbo].[PAReactionTypes] ([IdReactionType])
GO
ALTER TABLE [dbo].[PAReactionsPerAd] CHECK CONSTRAINT [FK__PAReactio__IdRea__151B244E]
GO
ALTER TABLE [dbo].[PAReactionsPerAd]  WITH CHECK ADD  CONSTRAINT [FK_PAReactionsPerAd_PAAdPerformances] FOREIGN KEY([IdAdPerformance])
REFERENCES [dbo].[PAAdPerformances] ([IdAdPerformance])
GO
ALTER TABLE [dbo].[PAReactionsPerAd] CHECK CONSTRAINT [FK_PAReactionsPerAd_PAAdPerformances]
GO
ALTER TABLE [dbo].[PASchedules]  WITH CHECK ADD  CONSTRAINT [FK__PASchedul__IdSch__70DDC3D8] FOREIGN KEY([IdScheduleRecurrency])
REFERENCES [dbo].[PAScheduleRecurrencies] ([IdScheduleRecurrency])
GO
ALTER TABLE [dbo].[PASchedules] CHECK CONSTRAINT [FK__PASchedul__IdSch__70DDC3D8]
GO
ALTER TABLE [dbo].[PAStates]  WITH CHECK ADD FOREIGN KEY([IdCountry])
REFERENCES [dbo].[PACountries] ([IdCountry])
GO
ALTER TABLE [dbo].[PASubscriptionPerUser]  WITH CHECK ADD FOREIGN KEY([IdSubscription])
REFERENCES [dbo].[PASubscriptions] ([IdSubscription])
GO
ALTER TABLE [dbo].[PASubscriptionPerUser]  WITH CHECK ADD FOREIGN KEY([IdUser])
REFERENCES [dbo].[PAUsers] ([IdUser])
GO
ALTER TABLE [dbo].[PATargetConfigurations]  WITH CHECK ADD  CONSTRAINT [FK__PATargetC__IdPub__3587F3E0] FOREIGN KEY([IdPublicValue])
REFERENCES [dbo].[PAPublicValues] ([IdPublicValue])
GO
ALTER TABLE [dbo].[PATargetConfigurations] CHECK CONSTRAINT [FK__PATargetC__IdPub__3587F3E0]
GO
ALTER TABLE [dbo].[PATargetConfigurations]  WITH CHECK ADD  CONSTRAINT [FK__PATargetC__IdTar__3493CFA7] FOREIGN KEY([IdTargetPublic])
REFERENCES [dbo].[PATargetPublics] ([IdTargetPublic])
GO
ALTER TABLE [dbo].[PATargetConfigurations] CHECK CONSTRAINT [FK__PATargetC__IdTar__3493CFA7]
GO
ALTER TABLE [dbo].[PAUserPerOrganization]  WITH CHECK ADD  CONSTRAINT [FK__PAUserPer__IdOrg__59FA5E80] FOREIGN KEY([IdOrganization])
REFERENCES [dbo].[PAOrganizations] ([IdOrganization])
GO
ALTER TABLE [dbo].[PAUserPerOrganization] CHECK CONSTRAINT [FK__PAUserPer__IdOrg__59FA5E80]
GO
ALTER TABLE [dbo].[PAUserPerOrganization]  WITH CHECK ADD FOREIGN KEY([IdUser])
REFERENCES [dbo].[PAUsers] ([IdUser])
GO
ALTER TABLE [dbo].[PAUsers]  WITH CHECK ADD FOREIGN KEY([IdUserStatus])
REFERENCES [dbo].[PAUserStatus] ([IdUserStatus])
GO
ALTER TABLE [dbo].[PAUserXRoles]  WITH CHECK ADD FOREIGN KEY([IdRole])
REFERENCES [dbo].[PARoles] ([IdRole])
GO
ALTER TABLE [dbo].[PAUserXRoles]  WITH CHECK ADD FOREIGN KEY([IdUser])
REFERENCES [dbo].[PAUsers] ([IdUser])
GO
USE [master]
GO
ALTER DATABASE [promptads] SET  READ_WRITE 
GO
