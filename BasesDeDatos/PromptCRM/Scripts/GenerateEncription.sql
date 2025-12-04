USE promptcrm

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'passworddeencripcion'

CREATE CERTIFICATE CertEncripcion
WITH SUBJECT = 'Certificado de encripcion para master'

CREATE SYMMETRIC KEY LlaveSimetricaMaster
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CertEncripcion

-- Cambiar el path para guardar el backup del certificado
/*
BACKUP CERTIFICATE CertEncripcion TO FILE = 'C:\Users\luanj\Documents\SQL Server Management Studio 21\Certs y Keys\Certificado.cer'
WITH PRIVATE KEY
	(
	FILE = 'C:\Users\luanj\Documents\SQL Server Management Studio 21\Certs y Keys\privatekey.key',
	ENCRYPTION BY PASSWORD = 'passwordcertificado'
	)
*/

GO
CREATE OR ALTER PROCEDURE dbo.OpenKey
AS
BEGIN
	OPEN SYMMETRIC KEY LlaveSimetricaMaster
	DECRYPTION BY CERTIFICATE CertEncripcion
END
GO

-- function para encriptar una columna
GO
CREATE FUNCTION EncryptValue(@dataToEncrypt VARCHAR(MAX))
RETURNS VARBINARY(MAX)
AS
BEGIN
	RETURN ENCRYPTBYKEY(KEY_GUID('LlaveSimetricaMaster'), @dataToEncrypt)
END
GO

-- function para desencriptar una columna
GO
CREATE FUNCTION DecryptValue(@dataToDecrypt VARBINARY(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN CONVERT(VARCHAR, DECRYPTBYKEY(@dataToDecrypt))
END
GO

/*
DELETE FROM dbo.PCRUsers
DBCC CHECKIDENT ('dbo.PCRUsers', RESEED, 0)

DELETE FROM dbo.PCRUserStatuses
DBCC CHECKIDENT ('dbo.PCRUserStatuses', RESEED, 0)

INSERT INTO dbo.PCRUserStatuses (StatusDescription)
VALUES ('Activo'), ('Inactivo')

DECLARE @IsKeyOpen INT = 0

IF @IsKeyOpen = 0 BEGIN
	EXEC dbo.OpenKey
	SET @IsKeyOpen = 1
END

INSERT INTO dbo.PCRUsers (
	FirstName,
	LastName,
	SSN,
	PasswordHash,
	PasswordSalt,
	LastLogin,
	Checksum,
	IdStatus,
	CreatedAt,
	UpdatedAt
)
VALUES (
	'Carlos',
	'Villalobos',
	dbo.EncryptValue('1-2345-6789'),
	00000,
	00000,
	CURRENT_TIMESTAMP,
	00000,
	1,
	CURRENT_TIMESTAMP,
	CURRENT_TIMESTAMP
)
*/

SELECT * FROM dbo.PCRUsers

EXEC dbo.OpenKey
SELECT
	FirstName,
	LastName,
	dbo.DecryptValue(SSN) AS Decrypted
FROM PCRUsers

CLOSE SYMMETRIC KEY LlaveSimetricaMaster