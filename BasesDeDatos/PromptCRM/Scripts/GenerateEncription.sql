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

-- function para encriptar una columna
GO
CREATE FUNCTION EncryptColumn(@dataToEncrypt VARCHAR(MAX), @isSymmetricKeyOpen BIT)
RETURNS VARBINARY(MAX)
AS
BEGIN
	IF (@isSymmetricKeyOpen = 0)
	BEGIN
		OPEN SYMMETRIC KEY LlaveSimetricaMaster
		DECRYPTION BY CERTIFICATE CertEncripcion
	END

	RETURN ENCRYPTBYKEY(KEY_GUID('LlaveSimetricaMaster'), @dataToEncrypt)
END
GO


-- function para desencriptar una columna
GO
CREATE FUNCTION DecryptColumn(@dataToDecrypt VARBINARY(MAX), @isSymmetricKeyOpen BIT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	IF (@isSymmetricKeyOpen = 0)
	BEGIN
		OPEN SYMMETRIC KEY LlaveSimetricaMaster
		DECRYPTION BY CERTIFICATE CertEncripcion
	END

	RETURN CONVERT(VARCHAR, DECRYPTBYKEY(@dataToDecrypt))
END
GO