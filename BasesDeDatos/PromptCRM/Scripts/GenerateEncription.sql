USE PromptCrm

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'passworddeencripcion'

CREATE CERTIFICATE CertEncripcion
WITH SUBJECT = 'Certificado de encripcion para master'

CREATE SYMMETRIC KEY LlaveSimetricaMaster
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CertEncripcion

BACKUP CERTIFICATE CertEncripcion TO FILE = 'C:\Users\luanj\Documents\SQL Server Management Studio 21\Certs y Keys\Certificado.cer'
WITH PRIVATE KEY
	(
	FILE = 'C:\Users\luanj\Documents\SQL Server Management Studio 21\Certs y Keys\privatekey.key',
	ENCRYPTION BY PASSWORD = 'passwordcertificado'
	)

SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##'


-- PRUEBA
DELETE FROM dbo.PCRUserStatuses
DBCC CHECKIDENT('dbo.PCRUserStatuses', RESEED, 0)
INSERT INTO dbo.PCRUserStatuses (StatusDescription)
VALUES ('Activo'), ('Inactivo')

DELETE FROM dbo.PCRUsers
DBCC CHECKIDENT('dbo.PCRUsers', RESEED, 0)

DECLARE @Salt UNIQUEIDENTIFIER = NEWID()
DECLARE @Password NVARCHAR(30) = 'carlitos99'
DECLARE @SaltCast VARBINARY(36) = CAST(@Salt AS VARBINARY(36))
DECLARE @SaltedPassword VARBINARY(MAX) = CONVERT(VARBINARY(MAX), @Password) + @SaltCast
DECLARE @PasswordHash VARBINARY(MAX) = HASHBYTES('SHA2_512', @SaltedPassword)

-- ENCRIPCION
OPEN SYMMETRIC KEY LlaveSimetricaMaster
DECRYPTION BY CERTIFICATE CertEncripcion

INSERT INTO dbo.PCRUsers (FirstName, LastName, Email, SSN, PasswordHash, PasswordSalt, LastLogin, Checksum, IDStatus, CreatedAt, UpdatedAt)
VALUES
	('Carlos',
	'Rodriguez',
	'carlosro@gmail.com',
	ENCRYPTBYKEY(KEY_GUID('LlaveSimetricaMaster'), '1-2345-6789'),
	@PasswordHash,
	@SaltCast,
	CURRENT_TIMESTAMP,
	CHECKSUM('Carlos', 'Rodriguez', 'carlosro@gmail.com'),
	1,
	DATEADD(DAY, -30, CURRENT_TIMESTAMP),
	DATEADD(DAY, -15, CURRENT_TIMESTAMP));

CLOSE SYMMETRIC KEY LlaveSimetricaMaster

SELECT * FROM dbo.PCRUsers

--- DESENCRIPCION
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'passworddeencripcion'

OPEN SYMMETRIC KEY LlaveSimetricaMaster
DECRYPTION BY CERTIFICATE CertEncripcion

SELECT
	FirstName,
	LastName,
	Email,
	CONVERT(VARCHAR, DECRYPTBYKEY(SSN)) AS SSN,
	PasswordHash,
	PasswordSalt
FROM dbo.PCRUsers

CLOSE SYMMETRIC KEY LlaveSimetricaMaster

