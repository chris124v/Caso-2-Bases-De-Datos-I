-- Script de creación de base de datos PromptAds

USE promptads;
GO

-- Tablas de multimedia
CREATE TABLE PAMediafileTypes (
    IdMediafileType TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE PAMediafiles (
    IdMediafile INT IDENTITY(1,1) PRIMARY KEY,
    encryptedURL VARBINARY(255) NOT NULL,
    IdMediafileType TINYINT NOT NULL,
    FOREIGN KEY (IdMediafileType) REFERENCES PAMediafileTypes(IdMediafileType)
);

-- Tablas de usuarios y organizaciones
CREATE TABLE PAUserStatus (
    IdUserStatus TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(40) NOT NULL
);

CREATE TABLE PAUsers (
    IdUser INT IDENTITY(1,1) PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(80) NOT NULL,
    passwordHash VARBINARY(250) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    lastLogin DATETIME NULL,
    IdUserStatus TINYINT NOT NULL,
    checksum VARBINARY(250) NULL,
    FOREIGN KEY (IdUserStatus) REFERENCES PAUserStatus(IdUserStatus)
);

CREATE TABLE PAOrganizations (
    IdOrganization INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    enabled BIT DEFAULT 1
);

CREATE TABLE PAUserPerOrganization (
    IdUserPerOrganization INT IDENTITY(1,1) PRIMARY KEY,
    IdUser INT NOT NULL,
    IdOrganization INT NOT NULL,
    enabled BIT DEFAULT 1,
    FOREIGN KEY (IdUser) REFERENCES PAUsers(IdUser),
    FOREIGN KEY (IdOrganization) REFERENCES PAOrganizations(IdOrganization)
);

-- Tablas de roles y permisos
CREATE TABLE PARoles (
    IdRole INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(200) NULL
);

CREATE TABLE PAUserXRoles (
    IdUser INT NOT NULL,
    IdRole INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    enabled BIT DEFAULT 1,
    checksum VARBINARY(250) NULL,
    PRIMARY KEY (IdUser, IdRole),
    FOREIGN KEY (IdUser) REFERENCES PAUsers(IdUser),
    FOREIGN KEY (IdRole) REFERENCES PARoles(IdRole)
);

CREATE TABLE PAPermissions (
    IdPermission INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200) NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    module VARCHAR(50) NOT NULL
);

CREATE TABLE PAPermissionXRoles (
    IdPermission INT NOT NULL,
    IdRole INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    enabled BIT DEFAULT 1,
    checksum VARBINARY(250) NULL,
    PRIMARY KEY (IdPermission, IdRole),
    FOREIGN KEY (IdPermission) REFERENCES PAPermissions(IdPermission),
    FOREIGN KEY (IdRole) REFERENCES PARoles(IdRole)
);

-- Tablas de horarios
CREATE TABLE PAScheduleRecurrencies (
    IdScheduleRecurrency TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    intervalDays INT NOT NULL
);

CREATE TABLE PASchedules (
    IdSchedule INT IDENTITY(1,1) PRIMARY KEY,
    IdScheduleRecurrency TINYINT NOT NULL,
    startDate DATETIME NOT NULL,
    endDate DATETIME NOT NULL,
    lastExecute DATETIME NULL,
    nextExecute DATETIME NOT NULL,
    enabled BIT DEFAULT 1,
    deleted BIT DEFAULT 0,
    FOREIGN KEY (IdScheduleRecurrency) REFERENCES PAScheduleRecurrencies(IdScheduleRecurrency)
);

-- Tablas de campañas
CREATE TABLE PACampaigns (
    IdCampaign INT IDENTITY(1,1) PRIMARY KEY,
    IdOrganization INT NOT NULL,
    name VARCHAR(60) NOT NULL,
    description VARCHAR(200) NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    endsAt DATETIME NULL,
    enabled BIT DEFAULT 1,
    deleted BIT DEFAULT 0,
    checksum VARBINARY(255) NULL,
    FOREIGN KEY (IdOrganization) REFERENCES PAOrganizations(IdOrganization)
);

CREATE TABLE PAAdTypes (
    IdAdType TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE PAAdStatus (
    IdAdStatus TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE PACampaignAds (
    IdCampaignAd BIGINT IDENTITY(1,1) PRIMARY KEY,
    IdCampaign INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    description VARCHAR(200) NULL,
    body TEXT NULL,
    adMedia SMALLINT NULL,
    IdAdType TINYINT NOT NULL,
    redirectURL VARCHAR(255) NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    adSchedule INT NULL,
    IdAdStatus TINYINT NOT NULL,
    checksum VARBINARY(255) NULL,
    FOREIGN KEY (IdCampaign) REFERENCES PACampaigns(IdCampaign),
    FOREIGN KEY (IdAdType) REFERENCES PAAdTypes(IdAdType),
    FOREIGN KEY (IdAdStatus) REFERENCES PAAdStatus(IdAdStatus)
);

CREATE TABLE PAAdMediafiles (
    IdAdMediafile INT IDENTITY(1,1) PRIMARY KEY,
    IdCampaignAd BIGINT NOT NULL,
    IdMediafile INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    deleted BIT DEFAULT 0,
    FOREIGN KEY (IdCampaignAd) REFERENCES PACampaignAds(IdCampaignAd),
    FOREIGN KEY (IdMediafile) REFERENCES PAMediafiles(IdMediafile)
);

CREATE TABLE PAReactionTypes (
    IdReactionType TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE PAReactionsPerAd (
    IdReaction BIGINT IDENTITY(1,1) PRIMARY KEY,
    IdCampaignAd BIGINT NOT NULL,
    IdReactionType TINYINT NOT NULL,
    reactionNumber BIGINT NOT NULL,
    FOREIGN KEY (IdCampaignAd) REFERENCES PACampaignAds(IdCampaignAd),
    FOREIGN KEY (IdReactionType) REFERENCES PAReactionTypes(IdReactionType)
);

-- Tablas de influencers
CREATE TABLE PAAdMedias (
    IdAdMedia SMALLINT IDENTITY(1,1) PRIMARY KEY,
    IdAPISetup INT NULL,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE PAInfluencers (
    IdInfluencer INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(60) NOT NULL,
    followers BIGINT NULL,
    bio VARCHAR(250) NULL,
    IdAdMedia SMALLINT NOT NULL,
    FOREIGN KEY (IdAdMedia) REFERENCES PAAdMedias(IdAdMedia)
);

CREATE TABLE PAInfluencerPerAd (
    IdInfluencerPerCampaign INT IDENTITY(1,1) PRIMARY KEY,
    IdInfluencer INT NOT NULL,
    IdCampaignAd BIGINT NOT NULL,
    enabled BIT DEFAULT 1,
    FOREIGN KEY (IdInfluencer) REFERENCES PAInfluencers(IdInfluencer),
    FOREIGN KEY (IdCampaignAd) REFERENCES PACampaignAds(IdCampaignAd)
);

CREATE TABLE PAContactTypes (
    IdContactType TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL
);

CREATE TABLE PAInfluencerContacts (
    IdInfluencerContact INT IDENTITY(1,1) PRIMARY KEY,
    IdInfluencer INT NOT NULL,
    IdContactType TINYINT NOT NULL,
    value VARCHAR(80) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    enabled BIT DEFAULT 1,
    deleted BIT DEFAULT 0,
    FOREIGN KEY (IdInfluencer) REFERENCES PAInfluencers(IdInfluencer),
    FOREIGN KEY (IdContactType) REFERENCES PAContactTypes(IdContactType)
);

-- Tablas de públicos objetivo
CREATE TABLE PAPublicTypes (
    IdPublicType SMALLINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE PATargetPublics (
    IdTargetPublic INT IDENTITY(1,1) PRIMARY KEY,
    IdPublicType SMALLINT NOT NULL,
    value INT NOT NULL,
    maxRange INT NULL,
    FOREIGN KEY (IdPublicType) REFERENCES PAPublicTypes(IdPublicType)
);

CREATE TABLE PACampaignPublics (
    IdCampaignPublic INT IDENTITY(1,1) PRIMARY KEY,
    IdCampaign INT NOT NULL,
    IdTargetPublic INT NOT NULL,
    enabled BIT DEFAULT 1,
    FOREIGN KEY (IdCampaign) REFERENCES PACampaigns(IdCampaign),
    FOREIGN KEY (IdTargetPublic) REFERENCES PATargetPublics(IdTargetPublic)
);

-- Tablas de pagos y monedas
CREATE TABLE PACountries (
    IdCountry SMALLINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL
);

CREATE TABLE PACurrencies (
    IdCurrency SMALLINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    isoCode VARCHAR(3) NOT NULL,
    currencySymbol VARCHAR(5) NULL,
    IdCountry SMALLINT NULL,
    FOREIGN KEY (IdCountry) REFERENCES PACountries(IdCountry)
);

CREATE TABLE PAPaymentTypes (
    IdPaymentType TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200) NULL
);

CREATE TABLE PAPaymentStatus (
    IdPaymentStatus TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL
);

CREATE TABLE PAPayments (
    IdPayment BIGINT IDENTITY(1,1) PRIMARY KEY,
    IdPaymentMethod TINYINT NOT NULL,
    IdPaymentType TINYINT NOT NULL,
    transactionAmount DECIMAL(16,2) NOT NULL,
    IdCurrency SMALLINT NOT NULL,
    description VARCHAR(100) NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    IdPaymentStatus TINYINT NOT NULL,
    checksum VARBINARY(250) NULL
);

CREATE TABLE PAPaymentMethods (
    IdPaymentMethod TINYINT IDENTITY(1,1) PRIMARY KEY,
    serviceName VARCHAR(30) NOT NULL,
    IdAPISetup INT NULL,
    logoIconURL VARCHAR(255) NULL,
    enabled BIT DEFAULT 1
);

CREATE TABLE PACampaignExpenses (
    IdCampaignExpense INT IDENTITY(1,1) PRIMARY KEY,
    description VARCHAR(200) NULL,
    amount DECIMAL(16,2) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    IdCurrency SMALLINT NOT NULL,
    IdCampaign INT NOT NULL,
    IdPayment BIGINT NOT NULL,
    IdMediafile INT NULL,
    checksum VARBINARY(255) NULL,
    FOREIGN KEY (IdCurrency) REFERENCES PACurrencies(IdCurrency),
    FOREIGN KEY (IdCampaign) REFERENCES PACampaigns(IdCampaign),
    FOREIGN KEY (IdPayment) REFERENCES PAPayments(IdPayment),
    FOREIGN KEY (IdMediafile) REFERENCES PAMediafiles(IdMediafile)
);

CREATE TABLE PACampaignInvestments (
    IdCampaignInvestment INT IDENTITY(1,1) PRIMARY KEY,
    description VARCHAR(200) NULL,
    amount DECIMAL(16,2) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    IdCurrency SMALLINT NOT NULL,
    IdCampaign INT NOT NULL,
    IdPayment BIGINT NOT NULL,
    IdMediafile INT NULL,
    checksum VARBINARY(255) NULL,
    FOREIGN KEY (IdCurrency) REFERENCES PACurrencies(IdCurrency),
    FOREIGN KEY (IdCampaign) REFERENCES PACampaigns(IdCampaign),
    FOREIGN KEY (IdPayment) REFERENCES PAPayments(IdPayment),
    FOREIGN KEY (IdMediafile) REFERENCES PAMediafiles(IdMediafile)
);

-- Tablas de suscripciones
CREATE TABLE PASubscriptions (
    IdSubscription SMALLINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(200) NULL
);

CREATE TABLE PAFeatures (
    IdFeature INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(200) NULL,
    dataType VARCHAR(30) NOT NULL
);

CREATE TABLE PAFeaturePerSubscription (
    IdFeaturePerSubscription INT IDENTITY(1,1) PRIMARY KEY,
    IdSubscription SMALLINT NOT NULL,
    IdFeature INT NOT NULL,
    value VARCHAR(80) NULL,
    unlimited BIT DEFAULT 0,
    FOREIGN KEY (IdSubscription) REFERENCES PASubscriptions(IdSubscription),
    FOREIGN KEY (IdFeature) REFERENCES PAFeatures(IdFeature)
);

CREATE TABLE PASubscriptionPerUser (
    IdSubscriptionPerUser INT IDENTITY(1,1) PRIMARY KEY,
    IdUser INT NOT NULL,
    IdSubscription SMALLINT NOT NULL,
    enabled BIT DEFAULT 1,
    FOREIGN KEY (IdUser) REFERENCES PAUsers(IdUser),
    FOREIGN KEY (IdSubscription) REFERENCES PASubscriptions(IdSubscription)
);

-- Tablas de APIs
CREATE TABLE PAAPITypes (
    IdAPIType SMALLINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE PAAPISetups (
    IdAPISetup INT IDENTITY(1,1) PRIMARY KEY,
    APIName VARCHAR(50) NOT NULL,
    IdAPIType SMALLINT NOT NULL,
    APIkey VARCHAR(255) NOT NULL,
    URL VARCHAR(255) NOT NULL,
    configuration NVARCHAR(MAX),
    FOREIGN KEY (IdAPIType) REFERENCES PAAPITypes(IdAPIType)
);

CREATE TABLE PARequestStatus (
    IdRequestStatus SMALLINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    code VARCHAR(10) NOT NULL,
    message VARCHAR(50) NOT NULL
);

CREATE TABLE PANotificationRequests (
    IdNotificationRequest INT IDENTITY(1,1) PRIMARY KEY,
    IdCampaignAd BIGINT NOT NULL,
    IdContactType TINYINT NOT NULL,
    IdAPISetup INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    output NVARCHAR(MAX),
    IdRequestStatus SMALLINT NOT NULL,
    FOREIGN KEY (IdCampaignAd) REFERENCES PACampaignAds(IdCampaignAd),
    FOREIGN KEY (IdContactType) REFERENCES PAContactTypes(IdContactType),
    FOREIGN KEY (IdAPISetup) REFERENCES PAAPISetups(IdAPISetup),
    FOREIGN KEY (IdRequestStatus) REFERENCES PARequestStatus(IdRequestStatus)
);

CREATE TABLE PALogLevels (
    IdLogLevel TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE PALogTypes (
    IdLogType TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE PALogSources (
    IdLogSource TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE PALogs (
    IdLog BIGINT IDENTITY(1,1) PRIMARY KEY,
    createdAt DATETIME DEFAULT GETDATE(),
    description VARCHAR(500) NOT NULL,
    computer VARCHAR(100) NULL,
    username VARCHAR(50) NULL,
    IdRef1 BIGINT NULL,
    IdRef2 BIGINT NULL,
    value1 VARCHAR(200) NULL,
    value2 VARCHAR(200) NULL,
    IdLogType TINYINT NOT NULL,
    IdLogLevel TINYINT NOT NULL,
    IdLogSource TINYINT NOT NULL,
    checksum VARBINARY(250) NULL,
    FOREIGN KEY (IdLogType) REFERENCES PALogTypes(IdLogType),
    FOREIGN KEY (IdLogLevel) REFERENCES PALogLevels(IdLogLevel),
    FOREIGN KEY (IdLogSource) REFERENCES PALogSources(IdLogSource)
);

-- Agregar FK pendientes
ALTER TABLE PAAdMedias ADD CONSTRAINT FK_PAAdMedias_PAAPISetups 
    FOREIGN KEY (IdAPISetup) REFERENCES PAAPISetups(IdAPISetup);

ALTER TABLE PAPaymentMethods ADD CONSTRAINT FK_PAPaymentMethods_PAAPISetups 
    FOREIGN KEY (IdAPISetup) REFERENCES PAAPISetups(IdAPISetup);

ALTER TABLE PAPayments ADD CONSTRAINT FK_PAPayments_PAPaymentMethods 
    FOREIGN KEY (IdPaymentMethod) REFERENCES PAPaymentMethods(IdPaymentMethod);

ALTER TABLE PAPayments ADD CONSTRAINT FK_PAPayments_PAPaymentTypes 
    FOREIGN KEY (IdPaymentType) REFERENCES PAPaymentTypes(IdPaymentType);

ALTER TABLE PAPayments ADD CONSTRAINT FK_PAPayments_PAPaymentStatus 
    FOREIGN KEY (IdPaymentStatus) REFERENCES PAPaymentStatus(IdPaymentStatus);

ALTER TABLE PAPayments ADD CONSTRAINT FK_PAPayments_PACurrencies 
    FOREIGN KEY (IdCurrency) REFERENCES PACurrencies(IdCurrency);

ALTER TABLE PACampaignAds ADD CONSTRAINT FK_PACampaignAds_PASchedules 
    FOREIGN KEY (adSchedule) REFERENCES PASchedules(IdSchedule);
GO