USE PromptCrm

/*
CREATE TYPE dbo.FirstNameMockup AS TABLE (
	IdFirstName INT IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(40)
)

CREATE TYPE dbo.LastNameMockup AS TABLE (
	IdLastName INT IDENTITY(1,1) PRIMARY KEY,
	LastName VARCHAR(40)
)

INSERT INTO dbo.PCRFeatureTypes (TypeName)
VALUES
	('FirstName'), ('LastName'), ('Age')

INSERT INTO dbo.PCRClientStatuses (StatusDescription)
VALUES
	('Active'), ('Inactive')

SELECT * FROM dbo.PCRFeatureTypes
SELECT * FROM dbo.PCRClientStatuses
*/

GO
CREATE OR ALTER PROCEDURE dbo.PCRSP_InsertClient
	@FirstNames dbo.FirstNameMockup READONLY,
	@LastNames dbo.LastNameMockup READONLY
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- Declaracion de otras variables
	DECLARE @MAXFirstNameID INT
	DECLARE @MAXLastNameID INT
	DECLARE @RandomFirstNameID INT
	DECLARE @RandomLastNameID INT
	DECLARE @RandomFirstName VARCHAR(40)
	DECLARE @RandomLastName VARCHAR(40)
	DECLARE @RandomAge INT
	DECLARE @ClientCode VARCHAR(50)
	DECLARE @NewClientID INT
	DECLARE @CurrentTime DATETIME

	-- Operaciones de select que no tengan que ser bloqueadas
	SELECT @MAXFirstNameID = MAX(IdFirstName) FROM @FirstNames
	SELECT @MAXLastNameID = MAX(IdLastName) FROM @LastNames

	SET @RandomFirstNameID = FLOOR(RAND() * @MAXFirstNameID + 1)
	SET @RandomLastNameID = FLOOR(RAND() * @MAXLastNameID + 1)

	SELECT @RandomFirstName = FirstName FROM @FirstNames
	WHERE IdFirstName = @RandomFirstNameID
	SELECT @RandomLastName = LastName FROM @LastNames
	WHERE IdLastName = @RandomLastNameID

	SET @RandomAge = FLOOR(RAND() * (75 - 15 + 1) + 15)

	SET @ClientCode = CAST(@RandomFirstNameID AS VARCHAR) + CAST(@RandomLastNameID AS VARCHAR) + CAST(@RandomAge AS VARCHAR)

	-- Inicio de la transaccion
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001

		-- A lo que vinimos
		SET @CurrentTime = CURRENT_TIMESTAMP

		INSERT INTO dbo.PCRClients (ClientCode, IdStatus, CreatedAt, UpdatedAt)
		VALUES
			(@ClientCode, 1, @CurrentTime, @CurrentTime)

		SELECT @NewClientID = SCOPE_IDENTITY()

		INSERT INTO dbo.PCRFeaturesPerClients (IdClient, IdFeatureType, FeatureValue, CreatedAt, UpdatedAt, Enabled)
		VALUES
			(@NewClientID, 1, @RandomFirstName, @CurrentTime, @CurrentTime, 1),
			(@NewClientID, 2, @RandomLastName, @CurrentTime, @CurrentTime, 1),
			(@NewClientID, 3, CAST(@RandomAge AS VARCHAR(40)), @CurrentTime, @CurrentTime, 1)
					
		IF @InicieTransaccion=1 BEGIN
			COMMIT
		END
	END TRY
	BEGIN CATCH
		-- en esencia, lo que hay  que hacer es registrar el error real, y enviar para arriba un error custom 
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()
		
		IF @InicieTransaccion=1 BEGIN
			ROLLBACK
		END
		-- el error original lo inserte en la tabla de logs, pero retorno a la capa superior un error en "bonito"
		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError) -- hay que sustituir el @message por un error personalizado bonito, lo ideal es sacarlo de sys.messages 
		-- en la tabla de sys.messages se pueden insertar mensajes personalizados de error, los cuales se les hace match con el numero en @CustomError
	END CATCH	
END
RETURN 0
GO

DECLARE @FirstNamesTVP AS dbo.FirstNameMockup
DECLARE @LastNamesTVP AS dbo.LastNameMockup

INSERT INTO @FirstNamesTVP (FirstName)
VALUES
	('Liam'),('Olivia'),('Noah'),('Emma'),('Amelia'),('Mateo'),('Sophia'),('Aiden'),('Isabella'),('Lucas'),
	('Mia'),('Ethan'),('Charlotte'),('James'),('Ava'),('Benjamin'),('Harper'),('Elijah'),('Luna'),('Alexander'),
	('Sofia'),('Logan'),('Ella'),('Jacob'),('Mila'),('Michael'),('Layla'),('Daniel'),('Zoe'),('Henry'),
	('Camila'),('Jackson'),('Gianna'),('Sebastian'),('Aria'),('Jack'),('Chloe'),('Samuel'),('Ellie'),('David'),
	('Grace'),('Joseph'),('Nora'),('Carter'),('Hazel'),('Owen'),('Scarlett'),('Wyatt'),('Victoria'),('John'),
	('Riley'),('Leo'),('Aurora'),('Luke'),('Lily'),('Julian'),('Penelope'),('Hudson'),('Hannah'),('Grayson'),
	('Zoey'),('Isaac'),('Stella'),('Gabriel'),('Maya'),('Levi'),('Paisley'),('Anthony'),('Savannah'),('Dylan'),
	('Addison'),('Ezra'),('Natalie'),('Charles'),('Elena'),('Josiah'),('Brooklyn'),('Christopher'),('Audrey'),('Caleb'),
	('Lucy'),('Elias'),('Claire'),('Joshua'),('Violet'),('Nathan'),('Bella'),('Andrew'),('Aurélien'),('Yara'),
	('Mateusz'),('Ines'),('Rafael'),('Ananya'),('Diego'),('Amina'),('Santiago'),('Mei'),('Giovanni'),('Tariq'),
	('Hiroshi'),('Fatima'),('Omar'),('Priya'),('Stefan'),('Elsa'),('Lucía'),('Andrei'),('Nadia'),('Tobias'),
	('Saskia'),('Ronan'),('Maeve'),('Alejandro'),('Marisol'),('Igor'),('Leila'),('Jonas'),('Marta'),('Ivan'),
	('Sinead'),('Arjun'),('Chiara'),('Nikolai'),('Aisha'),('Marcus'),('Petra'),('Victor'),('Freya'),('Noor'),
	('Fernando'),('Eleni'),('Paolo'),('Anita'),('Jamal'),('Diana'),('Yuki'),('Sakura'),('Khalid'),('Zainab'),
	('Marek'),('Eva'),('Otto'),('Klara'),('Pierre'),('Camille'),('Ahmet'),('Leyla'),('Mustafa'),('Aylin'),
	('Raj'),('Kiran'),('Luis'),('Isidora'),('Nikola'),('Teodora'),('Anton'),('Katya'),('Boris'),('Milena'),
	('Viktor'),('Irena'),('Henrik'),('Astrid'),('Leif'),('Sanna'),('Erik'),('Elin'),('Bjorn'),('Maja'),
	('Filip'),('Nika'),('Matej'),('Dominik'),('Lucija'),('Tomas'),('Zuzana'),('Adam'),('Veronika'),('Jiri'),
	('Ema'),('Petr'),('Lucie'),('Krzysztof'),('Magda'),('Lukasz'),('Agnieszka'),('Janusz'),('Kasia'),('Marcin'),
	('Ola'),('Ryszard'),('Basia'),('Hans'),('Greta'),('Fritz'),('Helga'),('Karl'),('Ingrid'),('Franz'),
	('Liesel'),('Wolfgang'),('Monika'),('Stefan'),('Sabine'),('Uwe'),('Anke'),('Bernd'),('Heike'),('Jochen'),
	('Ulrike'),('Dirk'),('Renate'),('Pascal'),('Élodie'),('Laurent'),('François'),('Amélie'),('Hugo'),('Juliette'),
	('Luc'),('Sophie'),('Nicolas'),('Chloé'),('Antoine'),('Manon'),('Julien'),('Émilie'),('Giuseppe'),('Giulia'),
	('Marco'),('Francesca'),('Luca'),('Martina'),('Matteo'),('Sara'),('Davide'),('Alice'),('Stefano'),('Laura'),
	('Giorgio'),('Valentina'),('Hassan'),('Amira'),('Ali'),('Yasmin'),('Karim'),('Mahmoud'),('Aisha'),('Ahmed'),
	('Samira'),('Ibrahim'),('Fatma'),('Lina'),('Youssef'),('Noor'),('Adil'),('Salma'),('Chen'),('Li'),
	('Wei'),('Mei'),('Jun'),('Xiao'),('Ling'),('Ting'),('Hao'),('Lan'),('Min'),('Rui'),
	('Yan'),('Fen'),('Bo'),('Jing'),('Shan'),('Qian'),('Ping'),('Hui'),('Haruto'),('Yui'),
	('Ren'),('Aoi'),('Sota'),('Hana'),('Yuto'),('Riku'),('Hina'),('Kaito'),('Mio'),('Itsuki'),
	('Rin'),('Kota'),('Ayaka'),('Joon'),('Soojin'),('Minho'),('Hyun'),('Eunji'),('Taeyang'),('Yuna'),
	('Seojin'),('Minji'),('Juan'),('Valeria'),('Carlos'),('Fernanda'),('José'),('Mariana'),('Miguel'),('Isabella'),
	('Javier'),('Daniela'),('Luis'),('Lucía'),('Fernando'),('Gabriela'),('Raúl'),('Paula'),('Pablo'),('Elena'),
	('Sergio'),('Natalia'),('Manuel'),('Rocío'),('Jorge'),('Lola'),('Ramón'),('Inés'),('Thiago'),('Bruna'),
	('Gabriel'),('Beatriz'),('Rafael'),('Larissa'),('Matheus'),('Juliana'),('Pedro'),('Fernanda'),('João'),('Isabela')

INSERT INTO @LastNamesTVP (LastName)
VALUES
	('Smith'),('Johnson'),('Williams'),('Brown'),('Jones'),('Garcia'),('Miller'),('Davis'),('Rodriguez'),('Martinez'),
	('Hernandez'),('Lopez'),('Gonzalez'),('Wilson'),('Anderson'),('Thomas'),('Taylor'),('Moore'),('Jackson'),('Martin'),
	('Lee'),('Perez'),('Thompson'),('White'),('Harris'),('Sanchez'),('Clark'),('Ramirez'),('Lewis'),('Robinson'),
	('Walker'),('Young'),('Allen'),('King'),('Wright'),('Scott'),('Torres'),('Nguyen'),('Hill'),('Flores'),
	('Green'),('Adams'),('Nelson'),('Baker'),('Hall'),('Rivera'),('Campbell'),('Mitchell'),('Carter'),('Roberts'),
	('Gomez'),('Phillips'),('Evans'),('Turner'),('Diaz'),('Parker'),('Cruz'),('Edwards'),('Collins'),('Reyes'),
	('Stewart'),('Morris'),('Morales'),('Murphy'),('Cook'),('Rogers'),('Gutierrez'),('Ortiz'),('Morgan'),('Cooper'),
	('Peterson'),('Bailey'),('Reed'),('Kelly'),('Howard'),('Ramos'),('Kim'),('Cox'),('Ward'),('Richardson'),
	('Watson'),('Brooks'),('Chavez'),('Wood'),('James'),('Bennett'),('Gray'),('Mendoza'),('Ruiz'),('Hughes'),
	('Price'),('Alvarez'),('Castillo'),('Sanders'),('Patel'),('Myers'),('Long'),('Ross'),('Foster'),('Jimenez'),
	('Powell'),('Jenkins'),('Perry'),('Russell'),('Sullivan'),('Bell'),('Coleman'),('Butler'),('Henderson'),('Barnes'),
	('Fisher'),('Vasquez'),('Simmons'),('Romero'),('Jordan'),('Patterson'),('Alexander'),('Hamilton'),('Graham'),('Reynolds'),
	('Griffin'),('Wallace'),('Moreno'),('West'),('Cole'),('Hayes'),('Bryant'),('Herrera'),('Gibson'),('Ellis'),
	('Tran'),('Medina'),('Aguilar'),('Stevens'),('Murray'),('Ford'),('Castro'),('Marshall'),('Owens'),('Harrison'),
	('Fernandez'),('McDonald'),('Woods'),('Washington'),('Kennedy'),('Wells'),('Vargas'),('Henry'),('Chen'),('Freeman'),
	('Shaw'),('Mendez'),('Weaver'),('Chang'),('Kimura'),('Sato'),('Tanaka'),('Yamamoto'),('Kobayashi'),('Ito'),
	('Nakamura'),('Watanabe'),('Suzuki'),('Takahashi'),('Matsumoto'),('Yamaguchi'),('Ogawa'),('Abe'),('Kondo'),('Ishikawa'),
	('Kato'),('Shimizu'),('Mori'),('Fujita'),('Hashimoto'),('Yoshida'),('Inoue'),('Takeuchi'),('Sasaki'),('Nakagawa'),
	('Yamashita'),('Sakai'),('Endo'),('Okada'),('Matsuda'),('Hayashi'),('Ueda'),('Imai'),('Hara'),('Nakano'),
	('Hara'),('Sakamoto'),('Arai'),('Miyazaki'),('Maeda'),('Tsuji'),('Okamoto'),('Hirano'),('Matsui'),('Kaneko'),
	('Ishii'),('Yasuda'),('Kojima'),('Hirano'),('Kawasaki'),('Hirano'),('Sano'),('Yano'),('Fukuda'),('Ono'),
	('Takahara'),('Okubo'),('Tajima'),('Murakami'),('Fukuoka'),('Itoh'),('Aoyama'),('Honda'),('Nishimura'),('Goto'),
	('Kuroda'),('Matsuno'),('Arakawa'),('Nakajima'),('Okawa'),('Higuchi'),('Amano'),('Nishi'),('Yamada'),('Hirano'),
	('Dubois'),('Lefevre'),('Moreau'),('Laurent'),('Simon'),('Michel'),('Garcia'),('Bernard'),('Dupont'),('Durand'),
	('Lemoine'),('Renard'),('Petit'),('Marchand'),('Moulin'),('Girard'),('Roux'),('Blanc'),('Fontaine'),('Guerin'),
	('Leclerc'),('Rousseau'),('Faure'),('Chevalier'),('Barbier'),('Francois'),('Henry'),('Lopez'),('Louis'),('Benoit'),
	('Lambert'),('Roy'),('Pires'),('Santos'),('Ferreira'),('Oliveira'),('Costa'),('Pereira'),('Carvalho'),('Sousa'),
	('Rodrigues'),('Nunes'),('Gomes'),('Martins'),('Fernandes'),('Araujo'),('Correia'),('Ribeiro'),('Teixeira'),('Almeida'),
	('Pinto'),('Monteiro'),('Cunha'),('Barros'),('Machado'),('Vieira'),('Fonseca'),('Figueiredo'),('Cardoso'),('Lopes'),
	('Rocha'),('Mendes'),('Freitas'),('Henriques'),('Tavares'),('Amaral'),('Antunes'),('Rebelo'),('Esteves'),('Nogueira'),
	('Navarro'),('Morales'),('Dominguez'),('Campos'),('Vega'),('Delgado'),('Pascual'),('Muñoz'),('Rojas'),('Herrera'),
	('Benitez'),('Silva'),('Torres'),('Cardenas'),('Castillo'),('Acosta'),('Flores'),('Guerrero'),('Villarreal'),('Serrano'),
	('Carrillo'),('Ramos'),('Ortega'),('Suarez'),('Maldonado'),('Espinoza'),('Cervantes'),('Valdez'),('Escobar'),('Salazar'),
	('Navarro'),('Vazquez'),('Santos'),('Costa'),('Nielsen'),('Hansen'),('Jensen'),('Pedersen'),('Andersen'),('Christensen'),
	('Larsen'),('Olsen'),('Rasmussen'),('Johansen'),('Madsen'),('Knudsen'),('Mortensen'),('Thomsen'),('Simonsen'),('Petersen'),
	('Sorensen'),('Svendsen'),('Poulsen'),('Christiansen'),('Bang'),('Holm'),('Bach'),('Krogh'),('Bruun'),('Moller'),
	('Eriksen'),('Hedegaard'),('Lauridsen'),('Frandsen'),('Bak'),('Jeppesen'),('Bertelsen'),('Nyman'),('Virtanen'),('Korhonen'),
	('Laine'),('Heikkinen'),('Koskinen'),('Järvinen'),('Lehtinen'),('Saarinen'),('Salonen'),('Heinonen'),('Nieminen'),('Mäkinen'),
	('Hämäläinen'),('Rantanen'),('Ojala'),('Leppänen'),('Ahonen'),('Koivisto'),('Tuominen'),('Räsänen'),('Seppälä'),('Kinnunen')

DECLARE @i INT = 0
WHILE @i < 500000
BEGIN
	EXEC dbo.PCRSP_InsertClient @FirstNamesTVP, @LastNamesTVP
	SET @i = @i + 1
END

/*
DELETE FROM dbo.PCRFeaturesPerClients
DELETE FROM dbo.PCRClients
SELECT * FROM dbo.PCRClients
SELECT * FROM dbo.PCRFeaturesPerClients
DBCC CHECKIDENT ('dbo.PCRClients', RESEED, 0)
*/