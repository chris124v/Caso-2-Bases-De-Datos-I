-- Crear base de datos
USE promptads;
GO

-- Tablas de ubicación geográfica
CREATE TABLE PACountries (
    IdCountry TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL
);

CREATE TABLE PAStates (
    IdState INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    IdCountry TINYINT NOT NULL,
    FOREIGN KEY (IdCountry) REFERENCES PACountries(IdCountry)
);

CREATE TABLE PACities (
    IdCity INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    IdState INT NOT NULL,
    FOREIGN KEY (IdState) REFERENCES PAStates(IdState)
);

CREATE TABLE PAAddresses (
    IdAddress INT IDENTITY(1,1) PRIMARY KEY,
    line1 VARCHAR(200) NOT NULL,
    line2 VARCHAR(200) NOT NULL,
    zipCode VARCHAR(10) NOT NULL,
    IdCity INT NOT NULL,
    FOREIGN KEY (IdCity) REFERENCES PACities(IdCity)
);

CREATE TABLE PACurrencies (
    IdCurrency SMALLINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    isoCode VARCHAR(3) NOT NULL,
    currencySymbol VARCHAR(5) NOT NULL,
    IdCountry TINYINT NOT NULL,
    FOREIGN KEY (IdCountry) REFERENCES PACountries(IdCountry)
);

CREATE TABLE PAExchangeRates (
    IdExchangeRate SMALLINT IDENTITY(1,1) PRIMARY KEY,
    startDate DATETIME NOT NULL,
    endDate DATETIME NULL,
    exchangeRate DECIMAL(10,4) NOT NULL,
    IdCurrencySource SMALLINT NOT NULL,
    IdCurrencyDestiny SMALLINT NOT NULL,
    isCurrent BIT DEFAULT 1,
    FOREIGN KEY (IdCurrencySource) REFERENCES PACurrencies(IdCurrency),
    FOREIGN KEY (IdCurrencyDestiny) REFERENCES PACurrencies(IdCurrency)
);

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

CREATE TABLE PAOrganizationStatus (
    IdOrganizationStatus TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE PAOrganizations (
    IdOrganization INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    legalName VARCHAR(60) NOT NULL,
    email VARCHAR(80) NOT NULL,
    createdAt DATETIME NOT NULL,
    organizationStatus TINYINT NOT NULL,
    FOREIGN KEY (organizationStatus) REFERENCES PAOrganizationStatus(IdOrganizationStatus)
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
    description VARCHAR(200) NOT NULL
);

CREATE TABLE PAUserXRoles (
    IdUserRole INT IDENTITY(1,1) PRIMARY KEY,
    IdUser INT NOT NULL,
    IdRole INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    enabled BIT DEFAULT 1,
    checksum VARBINARY(250) NULL,
    FOREIGN KEY (IdUser) REFERENCES PAUsers(IdUser),
    FOREIGN KEY (IdRole) REFERENCES PARoles(IdRole)
);

CREATE TABLE PAPermissions (
    IdPermission INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200) NOT NULL,
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
    name VARCHAR(30) NOT NULL,
    IdScheduleRecurrency TINYINT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    startHours TIME NOT NULL,
    endHours TIME NOT NULL,
    lastExecute DATETIME NULL,
    nextExecute DATETIME NOT NULL,
    createdAt DATETIME NOT NULL,
    enabled BIT DEFAULT 1,
    deleted BIT DEFAULT 0,
    FOREIGN KEY (IdScheduleRecurrency) REFERENCES PAScheduleRecurrencies(IdScheduleRecurrency)
);

-- Tablas de campañas
CREATE TABLE PACampaigns (
    IdCampaign INT IDENTITY(1,1) PRIMARY KEY,
    IdOrganization INT NOT NULL,
    name VARCHAR(60) NOT NULL,
    description VARCHAR(200) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    endsAt DATETIME NOT NULL,
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

CREATE TABLE PAAdMedias (
    IdAdMedia SMALLINT IDENTITY(1,1) PRIMARY KEY,
    IdAPISetup INT NULL,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE PACampaignAds (
    IdCampaignAd BIGINT IDENTITY(1,1) PRIMARY KEY,
    IdCampaign INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    description VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    IdAdMedia SMALLINT NOT NULL,
    IdAdType TINYINT NOT NULL,
    redirectURL VARCHAR(255) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    IdAdStatus TINYINT NOT NULL,
    checksum VARBINARY(255) NULL,
    FOREIGN KEY (IdCampaign) REFERENCES PACampaigns(IdCampaign),
    FOREIGN KEY (IdAdMedia) REFERENCES PAAdMedias(IdAdMedia),
    FOREIGN KEY (IdAdType) REFERENCES PAAdTypes(IdAdType),
    FOREIGN KEY (IdAdStatus) REFERENCES PAAdStatus(IdAdStatus)
);

CREATE TABLE PAAdSchedules (
    IdAdSchedule INT IDENTITY(1,1) PRIMARY KEY,
    IdCampaignAd BIGINT NOT NULL,
    IdSchedule INT NOT NULL,
    enabled BIT DEFAULT 1,
    FOREIGN KEY (IdCampaignAd) REFERENCES PACampaignAds(IdCampaignAd),
    FOREIGN KEY (IdSchedule) REFERENCES PASchedules(IdSchedule)
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

-- Tablas de reacciones
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
CREATE TABLE PAInfluencers (
    IdInfluencer INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(60) NOT NULL,
    followers BIGINT NOT NULL,
    bio VARCHAR(250) NOT NULL,
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
CREATE TABLE PATargetPublics (
    IdTargetPublic INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(80) NOT NULL
);

CREATE TABLE PAAdPublics (
    IdCampaignPublic INT IDENTITY(1,1) PRIMARY KEY,
    IdCampaignAd BIGINT NOT NULL,
    IdTargetPublic INT NOT NULL,
    enabled BIT DEFAULT 1,
    FOREIGN KEY (IdCampaignAd) REFERENCES PACampaignAds(IdCampaignAd),
    FOREIGN KEY (IdTargetPublic) REFERENCES PATargetPublics(IdTargetPublic)
);

CREATE TABLE PAPublicFeatures (
    IdPublicFeature SMALLINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    dataType VARCHAR(30) NOT NULL
);

CREATE TABLE PAPublicValues (
    IdPublicValue INT IDENTITY(1,1) PRIMARY KEY,
    IdPublicFeature SMALLINT NOT NULL,
    name VARCHAR(30) NOT NULL,
    minValue VARCHAR(80) NULL,
    maxValue VARCHAR(80) NULL,
    value VARCHAR(80) NULL,
    FOREIGN KEY (IdPublicFeature) REFERENCES PAPublicFeatures(IdPublicFeature)
);

CREATE TABLE PATargetConfigurations (
    IdTargetConfiguration INT IDENTITY(1,1) PRIMARY KEY,
    IdTargetPublic INT NOT NULL,
    IdPublicValue INT NOT NULL,
    enabled BIT DEFAULT 1,
    FOREIGN KEY (IdTargetPublic) REFERENCES PATargetPublics(IdTargetPublic),
    FOREIGN KEY (IdPublicValue) REFERENCES PAPublicValues(IdPublicValue)
);

-- Tablas de transacciones
CREATE TABLE PACampaignTransactionTypes (
    IdCampaignTransactionType TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE PACampaignTransactions (
    IdCampaignTransaction INT IDENTITY(1,1) PRIMARY KEY,
    description VARCHAR(80) NOT NULL,
    amount DECIMAL(16,2) NOT NULL,
    IdCampaignTransactionType TINYINT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    IdCampaignAd BIGINT NOT NULL,
    IdPayment BIGINT NOT NULL,
    IdMediafile INT NULL,
    checksum VARBINARY(255) NULL,
    FOREIGN KEY (IdCampaignTransactionType) REFERENCES PACampaignTransactionTypes(IdCampaignTransactionType),
    FOREIGN KEY (IdCampaignAd) REFERENCES PACampaignAds(IdCampaignAd)
);

-- Tablas de pagos
CREATE TABLE PAPaymentTypes (
    IdPaymentType TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200) NOT NULL
);

CREATE TABLE PAPaymentStatus (
    IdPaymentStatus TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) NOT NULL
);

CREATE TABLE PAPaymentMethods (
    IdPaymentMethod TINYINT IDENTITY(1,1) PRIMARY KEY,
    serviceName VARCHAR(30) NOT NULL,
    IdAPISetup INT NULL,
    logoIconURL VARCHAR(255) NULL,
    enabled BIT DEFAULT 1
);

CREATE TABLE PAPayments (
    IdPayment BIGINT IDENTITY(1,1) PRIMARY KEY,
    IdPaymentMethod TINYINT NOT NULL,
    IdPaymentType TINYINT NOT NULL,
    transactionAmount DECIMAL(16,2) NOT NULL,
    IdCurrency SMALLINT NOT NULL,
    description VARCHAR(100) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    IdPaymentStatus TINYINT NOT NULL,
    checksum VARBINARY(250) NULL,
    FOREIGN KEY (IdPaymentMethod) REFERENCES PAPaymentMethods(IdPaymentMethod),
    FOREIGN KEY (IdPaymentType) REFERENCES PAPaymentTypes(IdPaymentType),
    FOREIGN KEY (IdCurrency) REFERENCES PACurrencies(IdCurrency),
    FOREIGN KEY (IdPaymentStatus) REFERENCES PAPaymentStatus(IdPaymentStatus)
);

-- Tablas de suscripciones
CREATE TABLE PASubscriptions (
    IdSubscription SMALLINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(200) NOT NULL
);

CREATE TABLE PASubscriptionFeatures (
    IdSubscriptionFeature INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(200) NOT NULL,
    dataType VARCHAR(30) NOT NULL
);

CREATE TABLE PAFeaturePerSubscription (
    IdFeaturePerSubscription INT IDENTITY(1,1) PRIMARY KEY,
    IdSubscription SMALLINT NOT NULL,
    IdSubscriptionFeature INT NOT NULL,
    value VARCHAR(80) NOT NULL,
    unlimited BIT NOT NULL,
    FOREIGN KEY (IdSubscription) REFERENCES PASubscriptions(IdSubscription),
    FOREIGN KEY (IdSubscriptionFeature) REFERENCES PASubscriptionFeatures(IdSubscriptionFeature)
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
    configuration NVARCHAR(MAX) NOT NULL,
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
    createdAt DATETIME NOT NULL,
    output NVARCHAR(MAX) NOT NULL,
    IdRequestStatus SMALLINT NOT NULL,
    FOREIGN KEY (IdCampaignAd) REFERENCES PACampaignAds(IdCampaignAd),
    FOREIGN KEY (IdContactType) REFERENCES PAContactTypes(IdContactType),
    FOREIGN KEY (IdAPISetup) REFERENCES PAAPISetups(IdAPISetup),
    FOREIGN KEY (IdRequestStatus) REFERENCES PARequestStatus(IdRequestStatus)
);

-- Tablas de Logs
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
GO

-- Agregar FK pendientes después de crear todas las tablas
ALTER TABLE PAAdMedias ADD CONSTRAINT FK_PAAdMedias_PAAPISetups 
    FOREIGN KEY (IdAPISetup) REFERENCES PAAPISetups(IdAPISetup);

ALTER TABLE PAPaymentMethods ADD CONSTRAINT FK_PAPaymentMethods_PAAPISetups 
    FOREIGN KEY (IdAPISetup) REFERENCES PAAPISetups(IdAPISetup);

ALTER TABLE PACampaignTransactions ADD CONSTRAINT FK_PACampaignTransactions_PAPayments 
    FOREIGN KEY (IdPayment) REFERENCES PAPayments(IdPayment);

ALTER TABLE PACampaignTransactions ADD CONSTRAINT FK_PACampaignTransactions_PAMediafiles 
    FOREIGN KEY (IdMediafile) REFERENCES PAMediafiles(IdMediafile);
GO