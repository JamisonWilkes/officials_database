-- GameOfficialScheduler create script
-- CS3550 
-- Jamison Wilkes
---------------------------------------
USE Master; -- to ensure that we are not in the GameOfficialScheduler database when we create it

-----------------------
--Drop the database if it exists
-----------------------------
IF EXISTS (SELECT * FROM sys.sysdatabases WHERE name = 'gameOfficialScheduler')
	DROP DATABASE gameOfficialScheduler;

---------------------------------------
--Create the database
--Your file path will need to match wehre ever you have your SQL Server installation
--on your computer.
---------------------------------------------------
CREATE DATABASE [gameOfficialScheduler]
ON PRIMARY
(NAME = N'gameOfficialScheduler',
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\gameOfficialScheduler.mdf',
SIZE = 5MB,
FILEGROWTH = 1MB)
LOG ON
(NAME = N'gameOfficialScheduler_LOG',
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\gameOfficialSchedulerLog.mdf',
SIZE = 2MB,
FILEGROWTH = 1MB);

GO
---------------------------
--Make sure that you attach to the correct database
-----------------------------------------------------
USE gameOfficialScheduler;
----------------------------------------------------
--Drop tables if they exist
--Tables must be dropped in the proper order 
-------------------------------------------
IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosUser'
	) DROP TABLE gosUser;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosSecurityAnswer'
	) DROP TABLE gosSecurityAnswer;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosSecurityQuestion'
	) DROP TABLE gosSecurityQuestion;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosOfficial'
	) DROP TABLE gosOfficial;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosGameOfficial'
	) DROP TABLE gosGameOfficial;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosArbiter'
	)DROP TABLE gosArbiter;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosSportLevel'
	) DROP TABLE gosSportLevel;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosOfficiatingPosition'
	) DROP TABLE gosOfficiatingPosition;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosAthleticDirector'
	) DROP TABLE gosAthleticDirector;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosCoach'
	) DROP TABLE gosCoach;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosSchool'
	) DROP TABLE gosSchool;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosGame'
	) DROP TABLE gosGame;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosSite'
	) DROP TABLE gosSite;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosPayment'
) DROP TABLE gosPayment;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'gosGameOfficialPaymentHistory'
) DROP TABLE gosGameOfficialPaymentHistory

------------
--Create Tables
---------------
CREATE TABLE gosUser(
	odUser_id int NOT NULL IDENTITY(1,1),
	emailAddress NVarchar(255) NOT NULL,
	firstName NVarchar(25) NOT NULL,
	lastName NVarchar(50) NOT NULL,
	streetAddress NVarchar(255) NOT NULL,
	city NVarchar(50) NOT NULL,
	state NVarchar(2) NOT NULL,
	zip NVarchar(9) NOT NULL,
	cellPhoneNumber NVarchar(10),
	homePhoneNumber NVarchar(10),
	workPhoneNumber NVarchar(10)
);

CREATE TABLE gosSecurityQuestion(
	odQuestion_id int NOT NULL IDENTITY(1,1),
	question NVarchar(255) NOT NULL
);

CREATE TABLE gosSecurityAnswer(
	odUser_id int NOT NULL ,
	odQuestion_id int NOT NULL,
	answer NVarchar(255) NOT NULL
);

CREATE TABLE gosCoach(
	odUser_id int NOT NULL,
	odSchool_id int NOT NULL, 
	sport NVarchar(25) NOT NULL
);

CREATE TABLE gosSchool(
	odSchool_id int NOT NULL IDENTITY(1,1),
	schoolName NVarchar(50) NOT NULL,
	phoneNumber NVarchar(10) NOT NULL,
	streetAddress NVarchar(255) NOT NULL,
	city NVarchar(50) NOT NULL,
	state NVarchar(2) NOT NULL,
	zip NVarchar(9) NOT NULL
);

CREATE TABLE gosArbiter(
	odUser_id int NOT NULL IDENTITY(1,1),
	odSportLevel_id int NOT NULL
);

CREATE TABLE gosOfficial(
	odUser_id int NOT NULL,
	feesAccumulated money NULL
);

CREATE TABLE gosPayment(
	odSportLevel_id int NOT NULL,
	paymentAmount money NULL
)

CREATE TABLE gosGameOfficialPaymentHistory(
	odPaymentHistory_id int NOT NULL,
	odUser_id int NOT NULL,
	odGame_id int NOT NULL,
	odPosition_id int NOT NULL,
	paymentAmount money NULL
)

CREATE TABLE gosGameOfficial(
	odUser_id int NOT NULL ,
	odGame_id int NOT NULL ,
	odPosition_id int NOT NULL 
);

CREATE TABLE gosSportLevel(
	odSportLevel_id int NOT NULL IDENTITY(1,1),
	sport NVarchar(25) NOT NULL,
	level NVarchar(25) NOT NULL
);

CREATE TABLE gosOfficiatingPosition(
	odPosition_id int NOT NULL IDENTITY(1,1),
	positionName NVarchar(25) NOT NULL
);

CREATE TABLE gosGame(
	odGame_id int NOT NULL IDENTITY(1,1),
	gameDateTime dateTime NOT NULL,
	odSportLevel_id int NOT NULL,
	odSite_id int NOT NULL,
	homeTeam int NOT NULL,
	visitingTeam int NOT NULL
);

CREATE TABLE gosSite(
	odSite_id int NOT NULL IDENTITY(1,1),
	siteName NVarchar(255) NOT NULL,
	--homeTeam NVarchar(10) NOT NULL,
	--visitingTeam NVarchar(10) NOT NULL,
	phoneNumber NVarchar(10) NOT NULL,
	streetAddress NVarchar(255) NOT NULL,
	city NVarchar(50) NOT NULL,
	state NVarchar(2) NOT NULL,
	zip NVarchar(9) NOT NULL
);

CREATE TABLE gosAthleticDirector(
	odUser_id int NOT NULL ,
	odSchool_id int NOT NULL 
);
---------------------
--Create Primary Keys
----------------------
ALTER TABLE gosUser
	ADD CONSTRAINT PK_gosUser
	PRIMARY KEY CLUSTERED (odUser_id);

ALTER TABLE gosSecurityQuestion
	ADD CONSTRAINT PK_gosSecurityQuestion
	PRIMARY KEY CLUSTERED (odQuestion_id);

ALTER TABLE gosSecurityAnswer
	ADD CONSTRAINT PK_gosSecurityAnswer_odUserID_odQuestionID
	PRIMARY KEY CLUSTERED (odUser_id, odQuestion_id);

ALTER TABLE gosOfficial
	ADD CONSTRAINT PK_gosOfficial_odUserID
	PRIMARY KEY CLUSTERED (odUser_id);

ALTER TABLE gosPayment
	ADD CONSTRAINT PK_gosPayment
	PRIMARY KEY CLUSTERED (odSportLevel_id)

ALTER TABLE gosGameOfficial
	ADD CONSTRAINT PK_gosGameOfficial_odUserID_odGameID_odPositionID
	PRIMARY KEY CLUSTERED (odUser_id, odGame_id, odPosition_id);

ALTER TABLE gosSportLevel
	ADD CONSTRAINT PK_gosSportLevel_odSportLevelID
	PRIMARY KEY CLUSTERED (odSportLevel_id);

ALTER TABLE gosOfficiatingPosition
	ADD CONSTRAINT PK_gosOfficiatingPosition_odPositionID
	PRIMARY KEY CLUSTERED (odPosition_id);

ALTER TABLE gosArbiter
	ADD CONSTRAINT PK_gosArbiter_odUserID
	PRIMARY KEY CLUSTERED (odUser_id);

ALTER TABLE gosGame
	ADD CONSTRAINT PK_gosGame_odGameID
	PRIMARY KEY CLUSTERED (odGame_id);
	
ALTER TABLE gosAthleticDirector
	ADD CONSTRAINT PK_gosAthleticDirector_odUserID_odSchoolID
	PRIMARY KEY CLUSTERED (odUser_id, odSchool_id);

ALTER TABLE gosCoach
	ADD CONSTRAINT PK_gosCoach_odUserID_odSchoolID
	PRIMARY KEY CLUSTERED (odUser_id, odSchool_id);

ALTER TABLE gosSchool
	ADD CONSTRAINT PK_gosSchool_odSchoolID
	PRIMARY KEY CLUSTERED (odSchool_id);

ALTER TABLE gosSite
	ADD CONSTRAINT PK_gosSite_odSiteId
	PRIMARY KEY CLUSTERED (odSite_id);

ALTER TABLE gosGameOfficialPaymentHistory
	ADD CONSTRAINT PK_gosGameOfficialPaymentHistory_odPaymentHistoryID
	PRIMARY KEY CLUSTERED (odPaymentHistory_id);

----------------------
--Create Foreign Keys
----------------------
ALTER TABLE gosSecurityAnswer
	ADD CONSTRAINT FK_gosSecurityAnswer_odUserID
	FOREIGN KEY (odUser_id) REFERENCES gosUser(odUser_id);

ALTER TABLE gosSecurityAnswer
	ADD CONSTRAINT FK_gosSecurityAnswer_odQuestionID
	FOREIGN KEY(odQuestion_id) REFERENCES gosSecurityQuestion(odQuestion_id);

--ALTER TABLE gosOfficial
--	ADD CONSTRAINT FK_gosOfficial_odUserID
--	FOREIGN KEY(odUser_id) REFERENCES gosUser(odUser_id);

ALTER TABLE gosGameOfficial
	ADD CONSTRAINT FK_gosGameOfficial_odUserID
	FOREIGN KEY(odUser_id) REFERENCES gosOfficial(odUser_id);

ALTER TABLE gosGameOfficial
	ADD CONSTRAINT FK_gosGameOfficial_odGameID
	FOREIGN KEY (odGame_id) REFERENCES gosGame(odGame_id);

ALTER TABLE gosGameOfficial
	ADD CONSTRAINT FK_gosGameOfficial_odPositionID
	FOREIGN KEY (odPosition_id) REFERENCES gosOfficiatingPosition(odPosition_id);

ALTER TABLE gosPayment
	ADD CONSTRAINT FK_gosPayment_odSportLevel_ID
	FOREIGN KEY(odSportLevel_id) REFERENCES gosSportLevel(odSportLevel_id);

ALTER TABLE gosArbiter
	ADD CONSTRAINT FK_gosArbiter_odUserID
	FOREIGN KEY(odUser_id) REFERENCES gosUser(odUser_id);

ALTER TABLE gosAthleticDirector
	ADD CONSTRAINT FK_gosAthleticDirector_odUserID
	FOREIGN KEY (odUser_id) REFERENCES gosUser(odUser_id);

ALTER TABLE gosAthleticDirector
	ADD CONSTRAINT FK_gosAthleticDirector_odSchoolID
	FOREIGN KEY(odSchool_id) REFERENCES gosSchool(odSchool_id);


ALTER TABLE gosCoach
	ADD CONSTRAINT FK_gosCoach_odUserID
	FOREIGN KEY(odUser_id) REFERENCES gosUser(odUser_id);

ALTER TABLE gosCoach
	ADD CONSTRAINT FK_gosCoach_odSchoolID
	FOREIGN KEY(odSchool_id) REFERENCES gosSchool(odSchool_id);

--ALTER TABLE gosCoach
--	ADD CONSTRAINT FK_gosCoach_sport
--	FOREIGN KEY(sport) REFERENCES gosSportLevel(odSportsLevel_id);

ALTER TABLE gosGame
	ADD CONSTRAINT FK_gosGame_odSportLevelID
	FOREIGN KEY(odSportLevel_id) REFERENCES gosSportLevel(odSportLevel_id);

ALTER TABLE gosGame
	ADD CONSTRAINT FK_gosGame_odSiteID
	FOREIGN KEY(odSite_id) REFERENCES gosSite(odSite_id);

ALTER TABLE gosGame
	ADD CONSTRAINT FK_gosGame_odHomeTeamID
	FOREIGN KEY(homeTeam) REFERENCES gosSchool(odSchool_id);

ALTER TABLE gosGame
	ADD CONSTRAINT FK_gosGame_odVisitingTeamID
	FOREIGN KEY(visitingTeam) REFERENCES gosSchool(odSchool_id);

ALTER TABLE gosGameOfficialPaymentHistory
	ADD CONSTRAINT FK_gosGameOfficialPaymentHistory_odUserID
	FOREIGN KEY(odUser_id) REFERENCES gosUser(odUser_id);

ALTER TABLE gosGameOfficialPaymentHistory
	ADD CONSTRAINT FK_gosGameOfficialPaymentHistory_odGameID
	FOREIGN KEY(odGame_id) REFERENCES gosGame(odGame_id);

ALTER TABLE gosGameOfficialPaymentHistory
	ADD CONSTRAINT FK_gosGameOfficialPaymentHistory_odPositionID
	FOREIGN KEY(odPosition_id) REFERENCES gosOfficiatingPosition(odPosition_id);
	
	

-----------------------
--Create Alternate Keys
-----------------------
ALTER TABLE gosUser
	ADD CONSTRAINT AK_gosUser_emailAddress
	UNIQUE (emailAddress);

ALTER TABLE gosSite
	ADD CONSTRAINT AK_gosSite_SiteName
	UNIQUE (SiteName);
	
--ALTER TABLE gosSecurityQuestion
--	ADD CONSTRAINT AK_gosSecurityQuestion_question
--	UNIQUE (question);

ALTER TABLE gosSportLevel
	ADD CONSTRAINT AK_gosSportLevel_sport_level
	UNIQUE (sport, level);
	
ALTER TABLE gosOfficiatingPosition
	ADD CONSTRAINT AK_gosOfficiatingPosition_positionName
	UNIQUE (positionName);

ALTER TABLE gosSchool
	ADD CONSTRAINT AK_gosSchool_schoolName
	UNIQUE (schoolName);

ALTER TABLE gosGame
	ADD CONSTRAINT AK_gosGame_gameDateTime_odSportLevelID_odSiteID
	UNIQUE(gameDateTime, odSportLevel_id, odSite_id);


	

ALTER TABLE gosGameOfficialPaymentHistory
	ADD CONSTRAINT AK_gosGameOfficialPaymentHistory_odUserID_odGameID_odPositionID
	UNIQUE(odUser_id, odGame_id, odPosition_id)


----------------------------------
--Insert Data
------------------------------------

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'adambaxter@yahoo.com',
	'Adam',
	'Baxter',
	'1969 N 250 E',
	'Layton',
	'UT',
	'84041',
	'8013183890',
	NULL,
	'8017743323'
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'sheldonb@hotmail.com',
	'Sheldon',
	'Bennett',
	'770 OAKMONT LN.',
	'Fruit Heights',
	'UT',
	'84037',
	'8017260200',
	NULL,
	NULL
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'lbirdland@gmail.com',
	'Lars',
	'Birdland',
	'527 Dartmouth Drive',
	'Morgan',
	'UT',
	'84050',
	'8019277676',
	'8019277634',
	NULL
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'marvdeyoung@outlook.com',
	'Marv',
	'DeYoung',
	'1228 N 310 E',
	'Layton',
	'UT',
	'84040',
	'8016406046',
	NULL,
	NULL
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'john.eliason@gmail.com',
	'John',
	'Eliason',
	'402 S 750 W',
	'Riverdale',
	'UT',
	'84405',
	'8017264706',
	NULL,
	NULL
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'shawnf@gmail.com',
	'Shawn',
	'Fernandez',
	'4934 S 3900 W',
	'Roy',
	'UT',
	'84067',
	'8013645907',
	NULL,
	'8013685829'
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'francis.morgan@gmail.com',
	'Morgan',
	'Francis',
	'288 E Primrose Rd',
	'Layton',
	'UT',
	'84040',
	'8013098023',
	NULL,
	'8016226471'
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'gardner1@comcast.net',
	'Randy',
	'Gardner',
	'152 29th Street',
	'Ogden',
	'UT',
	'84403',
	'8016985376',
	'8016212832',
	NULL
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'david.hansen0000@hotmail.com',
	'David',
	'Hansen',
	'527 North 4200 West',
	'West Point',
	'UT',
	'84015',
	'8014987536',
	NULL,
	NULL
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'dennish@msn.com',
	'Dennis',
	'Hooper',
	'1941 S 1350 W',
	'Syracuse',
	'UT',
	'84075',
	'8017325739',
	NULL,
	Null
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'jeff.jackson1@gmail.com',
	'Jeffrey',
	'Jackson',
	'840 East 1000 North',
	'Logan',
	'UT',
	'84321',
	'4357302126',
	NULL,
	NULL
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'kevin.andersen@ccsdut.org',
	'Kevin',
	'Andersen',
	' 255 South 800 East',
	'Hyrum',
	'UT',
	'84319',
	NULL,
	NULL,
	'4357927765'
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'clair.anderson@loganschools.org',
	'Clair',
	'Anderson',
	'162 W 100 S',
	'Logan',
	'UT',
	'843215298',
	NULL,
	NULL,
	'4357552380'
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'kdanderson@dsdmail.net',
	'Kelly',
	'Anderson',
	'665 S 2000 W',
	'Syracuse',
	'UT',
	'84075',
	NULL,
	NULL,
	'8014027900'
);
INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'marquette@dsdmail.net',
	'Mitch',
	'Arquette',
	'325 S Main St',
	'Kaysville',
	'UT',
	'840372598',
	NULL,
	NULL,
	'8014028800'
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'afresques@dsdmail.net',
	'Andrew',
	'Fresques',
	'N Hillfield Rd.',
	'Layton',
	'Ut',
	'84041',
	NULL,
	NULL,
	'8014028500'
);

INSERT INTO gosUser(
	emailAddress,
	firstName,
	lastname,
	streetAddress,
	city,
	[state],
	zip,
	cellPhoneNumber,
	homePhoneNumber,
	workPhoneNumber
)
VALUES
(
	'jana.brown@besd.net',
	'Jana',
	'Brown',
	'1450 S Main St',
	'Garland',
	'Ut',
	'843129797',
	NULL,
	NULL,
	'4352572500'
);

----------------------------------------------------------------------------------------------
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Bear River High School',
	'4352572500',
	'1450 S Main St',
	'Garland',
	'Ut',
	'843129797'
);
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Bountiful High School',
	'8014023900',
	'695 Orchard Dr',
	'Bountiful',
	'UT',
	'84010'
);

INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Box Elder High School',
	'4357344840',
	'380 S 600 W',
	'Brigham City',
	'UT',
	'843022442'
);
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Clearfield High School',
	'8014028200',
	'931 S Falcon Drive',
	'Clearfield',
	'UT',
	'84015'
);
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Davis High School',
	'8014028800',
	'325 S Main St',
	'Kaysville',
	'Ut',
	'840372598'
);

INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Farmington High School',
	'8014029050',
	'548 Glovers Ln',
	'Farmington',
	'UT',
	'840250588'
);

INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Fremont High School',
	'8014524000',
	'1900 N 4700 W',
	'Ogden',
	'UT',
	'84404'
);

INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Layton High School',
	'8014024800',
	'440 Wasatch Dr',
	'Layton',
	'Ut',
	'840413272'
);

INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Logan High School',
	'4357552380',
	'162 W 100 S',
	'Logan',
	'UT',
	'843215298'
);
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Morgan High School',
	'8018293418',
	'55 Trojan Blvd',
	'Morgan',
	'UT',
	'840500917'
);
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Mountain Crest High School',
	'4357927765',
	'255 South 800 East',
	'Hyrum',
	'UT',
	'84319'
);
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Northridge High School',
	'8014028500',
	'2430 N Hillfield Rd.',
	'Layton',
	'Ut',
	'84041'
);
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Roy High School',
	'8017744922',
	'2150 W 4800 S',
	'Roy',
	'Ut',
	'840671899'
);
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Sky View High School',
	'4355636273',
	'520 S 250 E',
	'Smithfield',
	'UT',
	'843351699'
);
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Syracuse High School',
	'8014027900',
	'665 S 2000 W',
	'Syracuse',
	'Ut',
	'84075'
);
INSERT INTO gosSchool(
	schoolName,
	phoneNumber,
	streetAddress,
	city,
	[state],
	zip
)
VALUES(
	'Weber High School',
	'8017463700',
	'3650 N 500 W',
	'Ogden',
	'UT',
	'844141455'
);
---------------------------------------------------------------------------------------------
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Bear River High School',
	'4352572500',
	'1450 S Main St',
	'Garland',
	'Ut',
	'843129797'
);
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Clearfield High School',
	'8014028200',
	'931  S Falcon Drive',
	'Clearfield',
	'UT',
	'84015'
);
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Dee Event Center',
	'8016266000',
	'4400 Harrison Blvd',
	'Ogden',
	'UT',
	'84403'
);
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Farmington High School',
	'8014029050',
	'548 Glovers Ln',
	'Farmington',
	'UT',
	'840250588'
);
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Fremont High School',
	'8014524000',
	'1900 N 4700 W',
	'Ogden',
	'UT',
	'84404'
);
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Layton High School',
	'8014024800',
	'440 Wasatch Dr',
	'Layton',
	'Ut',
	'840413272'
);
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Morgan High School',
	'8018293418',
	'55 Trojan Blvd',
	'Morgan',
	'UT',
	'840500917'
);
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Mountain Crest High School',
	'4357927765',
	'255 South 800 East',
	'Hyrum',
	'UT',
	'84319'
);
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Northridge High School',
	'8014028500',
	'2430 N Hillfield Rd.',
	'Layton',
	'Ut',
	'84041'
);
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Roy High School',
	'8017744922',
	'2150 W 4800 S',
	'Roy',
	'Ut',
	'840671899'
);
INSERT INTO gosSite(
	siteName,
	phoneNumber,
	streetAddress,
	city,
	state,
	zip
)
VALUES(
	'Sky View High School',
	'4355636273',
	'520 South 250 East',
	'Smithfield',
	'UT',
	'84335'

);
-------------------------------------------------------------------------------

INSERT INTO gosSecurityQuestion(
question)
VALUES('What was your childhood nickname?');

INSERT INTO gosSecurityQuestion(
question)
VALUES('What is the name of your favorite childhood friend?');

INSERT INTO gosSecurityQuestion(
question)
VALUES('In what city did you meet your spouse/significant other?');

INSERT INTO gosSecurityQuestion(
question)
VALUES('What street did you live on in third grade?');

INSERT INTO gosSecurityQuestion(
question)
VALUES('What is your oldest sibling’s birthday month and year? (e.g., January 1900)');

INSERT INTO gosSecurityQuestion(
question)
VALUES('What is the middle name of your youngest child?');

--------------------------------------------------------------------------------------------------------------------
-----------------------
--Adam Baxter Answers
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'adambaxter@yahoo.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('John Thompson')
);

INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'adambaxter@yahoo.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What was your childhood nickname?'),
	('Bax')
);

---------------------------
--Sheldon's answers
---------------------------
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'sheldonb@hotmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('Remmington Basil')
);
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'sheldonb@hotmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What street did you live on in third grade?'),
	('Liberty Way')
);

---------------------
--Lar's Answers
--------------------
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'lbirdland@gmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('Steve Sharp')
);
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'lbirdland@gmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What street did you live on in third grade?'),
	('Washington Blvd')
);

------------------------
--Marv's Answers
-----------------------
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'marvdeyoung@outlook.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'In what city did you meet your spouse/significant other?'),
	('Ogden')
);
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'marvdeyoung@outlook.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('Chad Keetch')
);

------------------
--John's answers
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'john.eliason@gmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'In what city did you meet your spouse/significant other?'),
	('Provo')
);
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'john.eliason@gmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('Stephanie Ricks')
);

-------------------
--Shawn's answers
------------------
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'shawnf@gmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('George Roberts')
);
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'shawnf@gmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the middle name of your youngest child?'),
	('Sydney')
);

-------------------
--Morgan's answers
-------------------
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'francis.morgan@gmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('Marcus Duncan')
);
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'francis.morgan@gmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the middle name of your youngest child?'),
	('Sofie')
);

-----------------
--Randy's answers
----------------
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'gardner1@comcast.net'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('Wynn Jacklin')
);
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'gardner1@comcast.net'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the middle name of your youngest child?'),
	('Charlie')
);

---------------------
--Davids answers
--------------------
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'david.hansen0000@hotmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('Julia Jensen')
);
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'david.hansen0000@hotmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the middle name of your youngest child?'),
	('Cole')
);

---------------------
--Dennis answers
--------------------
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'dennish@msn.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('Ryan Reese')
);
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'dennish@msn.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the middle name of your youngest child?'),
	('Jessica')
);

---------------------
--Jeffreys answers
--------------------
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'jeff.jackson1@gmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the name of your favorite childhood friend?'),
	('Rodney Ricks')
);
INSERT INTO gosSecurityAnswer(
	odUser_id,
	odQuestion_id,
	answer
)
VALUES
(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'jeff.jackson1@gmail.com'),
	(SELECT odQuestion_id FROM gosSecurityQuestion WHERE question = 'What is the middle name of your youngest child?'),
	('Asher')
);

-------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO gosAthleticDirector(
	odUser_id,
	odSchool_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'kevin.andersen@ccsdut.org'),
	(SELECT odSchool_id FROM gosSchool WHERE schoolName = 'Mountain Crest High School')
);
INSERT INTO gosAthleticDirector(
	odUser_id,
	odSchool_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'clair.anderson@loganschools.org'),
	(SELECT odSchool_id FROM gosSchool WHERE schoolName = 'Logan High School')
);
INSERT INTO gosAthleticDirector(
	odUser_id,
	odSchool_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'kdanderson@dsdmail.net'),
	(SELECT odSchool_id FROM gosSchool WHERE schoolName = 'Syracuse High School')
);
INSERT INTO gosAthleticDirector(
	odUser_id,
	odSchool_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'marquette@dsdmail.net'),
	(SELECT odSchool_id FROM gosSchool WHERE schoolName = 'Davis High School')
);
------------------------------------------------------------------------------------------

INSERT INTO gosSportLevel(
	sport,
	[level]
)
VALUES(
	'Football',
	'Varsity'
);
INSERT INTO gosSportLevel(
	sport,
	[level]
)
VALUES(
	'Volleyball',
	'Varsity'
);


INSERT INTO gosSportLevel(
	sport,
	[level]
)
VALUES(
	'Football',
	'Junior Varsity'
);
INSERT INTO gosSportLevel(
	sport,
	[level]
)
VALUES(
	'Volleyball',
	'Junior Varsity'
);

INSERT INTO gosSportLevel(
	sport,
	[level]
)
VALUES(
	'Football',
	'Sophmore'
);
INSERT INTO gosSportLevel(
	sport,
	[level]
)
VALUES(
	'Volleyball',
	'Sophmore'
);

INSERT INTO gosSportLevel(
	sport,
	[level]
)
VALUES(
	'Volleyball',
	'Freshman'
);

--------------------------------------------------------------------------------------
/*
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-28 7:00 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Football' AND level = 'Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Northridge High School'),
	'Northridge',
	'Davis'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-28 7:00 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Football' AND level = 'Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Fremont High School'),
	'Fremont',
	'Roy'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-28 7:00 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Football' AND level = 'Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Layton High School'),
	'Layton',
	'Syracuse'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-28 7:00 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Football' AND level = 'Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Clearfield High School'),
	'Clearfield',
	'Weber'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 6:00 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Morgan High School'),
	'Morgan',
	'Bountiful'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 4:45 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Junior Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Morgan High School'),
	'Morgan',
	'Bountiful'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 3:30 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Sophmore'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Morgan High School'),
	'Morgan',
	'Bountiful'
);

INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 6:00 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Sky View High School'),
	'Sky View',
	'Box Elder'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 4:45 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Junior Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Sky View High School'),
	'Sky View',
	'Box Elder'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 3:30 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Sophmore'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Sky View High School'),
	'Sky View',
	'Box Elder'
);


INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 6:00 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Farmington High School'),
	'Farmington',
	'Logan'
);

INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 4:45 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Junior Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Farmington High School'),
	'Farmington',
	'Logan'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 3:30 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Sophmore'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Farmington High School'),
	'Farmington',
	'Logan'
);

INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 6:00 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Bear River High School'),
	'Bear River',
	'Layton'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 4:45 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Junior Varsity'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Bear River High School'),
	'Bear River',
	'Layton'
);
INSERT INTO gosGame(
	gameDateTime,
	odSportLevel_id,
	odSite_id,
	homeTeam,
	visitingTeam
)
VALUES(
	CONVERT(datetime, '2020-08-27 3:30 PM'),
	(SELECT odSportLevel_id FROM gosSportLevel WHERE sport = 'Volleyball' AND level = 'Sophmore'),
	(SELECT odSite_id FROM gosSite WHERE siteName = 'Bear River High School'),
	'Bear River',
	'Layton'
);
*/
----------------------------------------------------------------------------
/*
INSERT INTO gosOfficiatingPosition(
	positionName
)
VALUES(
	'Referee'
);
INSERT INTO gosOfficiatingPosition(
	positionName
)
VALUES(
	'Umpire'
);
INSERT INTO gosOfficiatingPosition(
	positionName
)
VALUES(
	'HeadLinesman'
);
INSERT INTO gosOfficiatingPosition(
	positionName
)
VALUES(
	'LineJudge'
);
INSERT INTO gosOfficiatingPosition(
	positionName
)
VALUES(
	'BackJudge'
);
*/
---------------------------------------------------------------------------

INSERT INTO gosCoach(
	odUser_id,
	odSchool_id,
	sport
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'marquette@dsdmail.net'),
	(SELECT odSchool_id FROM gosSchool WHERE schoolName = 'Davis High School'),
	'Football'
);
INSERT INTO gosCoach(
	odUser_id,
	odSchool_id,
	sport
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'afresques@dsdmail.net'),
	(SELECT odSchool_id FROM gosSchool WHERE schoolName = 'Northridge High School'),
	'Football'
);
INSERT INTO gosCoach(
	odUser_id,
	odSchool_id,
	sport
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'jana.brown@besd.net'),
	(SELECT odSchool_id FROM gosSchool WHERE schoolName = 'Bear River High School'),
	'Volleyball'
);

/*
-----------------------------------------------------------------------------------------------
--Game 1
----------------------------
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'adambaxter@yahoo.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Northridge' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'sheldonb@hotmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Northridge' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'lbirdland@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Northridge' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'HeadLinesman')
);

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'marvdeyoung@outlook.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Northridge' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'BackJudge')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'john.eliason@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Northridge' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'LineJudge')
);

--------------------------------
--Game 2
--------------------------------
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'shawnf@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Fremont' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'francis.morgan@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Fremont' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'gardner1@comcast.net'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Fremont' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'HeadLinesman')
);

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'david.hansen0000@hotmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Fremont' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'BackJudge')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'dennish@msn.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Fremont' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'LineJudge')
);
--------------------------------
--Game 3
--------------------------------
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'jeff.jackson1@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Layton' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'adambaxter@yahoo.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Layton' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'sheldonb@hotmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Layton' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'HeadLinesman')
);

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'marvdeyoung@outlook.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Layton' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'BackJudge')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'john.eliason@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Layton' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'LineJudge')
);

--------------------------------
--Game 4
--------------------------------
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'shawnf@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Clearfield' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'francis.morgan@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Clearfield' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'gardner1@comcast.net'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Clearfield' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'HeadLinesman')
);

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'david.hansen0000@hotmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Clearfield' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'BackJudge')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'jeff.jackson1@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-28 7:00 PM') AND homeTeam = 'Clearfield' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'LineJudge')
);

-------------------------------------------
--Volleyball games group 1
--------------------------------------------
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'adambaxter@yahoo.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 6:00 PM') AND homeTeam = 'Morgan' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'sheldonb@hotmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 6:00 PM') AND homeTeam = 'Morgan' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'adambaxter@yahoo.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 4:45 PM') AND homeTeam = 'Morgan' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'sheldonb@hotmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 4:45 PM') AND homeTeam = 'Morgan' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'adambaxter@yahoo.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 3:30 PM') AND homeTeam = 'Morgan' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'marvdeyoung@outlook.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 3:30 PM') AND homeTeam = 'Morgan' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);

--Games group 2

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'lbirdland@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 6:00 PM') AND homeTeam = 'Sky View' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'marvdeyoung@outlook.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 6:00 PM') AND homeTeam = 'Sky View' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'lbirdland@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 4:45 PM') AND homeTeam = 'Sky View' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'marvdeyoung@outlook.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 4:45 PM') AND homeTeam = 'Sky View' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'lbirdland@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 3:30 PM') AND homeTeam = 'Sky View' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'marvdeyoung@outlook.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 3:30 PM') AND homeTeam = 'Sky View' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);


---------------------------
--Games group 3

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'shawnf@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 6:00 PM') AND homeTeam = 'Farmington' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'john.eliason@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 6:00 PM') AND homeTeam = 'Farmington' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'shawnf@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 4:45 PM') AND homeTeam = 'Farmington' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'john.eliason@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 4:45 PM') AND homeTeam = 'Farmington' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'shawnf@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 3:30 PM') AND homeTeam = 'Farmington' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'john.eliason@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 3:30 PM') AND homeTeam = 'Farmington' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);


----------------------
--Games group 4

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'francis.morgan@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 6:00 PM') AND homeTeam = 'Bear River' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'gardner1@comcast.net'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 6:00 PM') AND homeTeam = 'Bear River' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);

INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'francis.morgan@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 4:45 PM') AND homeTeam = 'Bear River' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'gardner1@comcast.net'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 4:45 PM') AND homeTeam = 'Bear River' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'francis.morgan@gmail.com'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 3:30 PM') AND homeTeam = 'Bear River' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Referee')
);
INSERT INTO gosGameOfficial(
	odUser_id,
	odGame_id,
	odPosition_id
)
VALUES(
	(SELECT odUser_id FROM gosUser WHERE emailAddress = 'gardner1@comcast.net'),
	(SELECT odGame_id FROM gosGame WHERE gameDatetime = CONVERT(datetime, '2020-08-27 3:30 PM') AND homeTeam = 'Bear River' ),
	(SELECT odPosition_id FROM gosOfficiatingPosition WHERE positionName = 'Umpire')
);
*/






-------------------------------
--Create get user id funcion
-------------------------------
IF EXISTS
(SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getUserID')
)
DROP FUNCTION dbo.udf_getUserID;
GO
CREATE FUNCTION dbo.udf_getUserID(@emailaddress NVarchar(255))
RETURNS INT 
AS
BEGIN

DECLARE @odUser_id INT;
SELECT @odUser_id = odUser_id
FROM gosUser
WHERE emailAddress = @emailaddress;

IF @odUser_id IS NULL
SET @odUser_id = -1;
RETURN @odUser_id;
END
GO

------------------------------------
--Create Get Security Question ID Function
--------------------------------------------
IF EXISTS(SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getQuestionID')
)
DROP FUNCTION dbo.udf_getQuestionID;
GO

CREATE FUNCTION dbo.udf_getQuestionID(@question NVarchar(255))
RETURNS INT
AS BEGIN

DECLARE @odQuestion_id INT;
SELECT @odQuestion_id = odQuestion_id 
FROM gosSecurityQuestion
WHERE question = @question;

IF @odQuestion_id IS NULL
SET @odQuestion_id = -1;
RETURN @odQuestion_id;
END
GO

------------------------------------
--Create Get School ID Function
--------------------------------------------
IF EXISTS(SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getSchoolID')
)
DROP FUNCTION dbo.udf_getSchoolID;
GO

CREATE FUNCTION dbo.udf_getSchoolID(@schoolName NVarchar(50))
RETURNS INT
AS BEGIN

DECLARE @odSchool_id INT;
SELECT @odSchool_id = odSchool_id 
FROM gosSchool
WHERE schoolName = @schoolName;

IF @odSchool_id IS NULL
SET @odSchool_id = -1;
RETURN @odSchool_id;
END
GO
------------------------------------
--Create Get Sport Level ID Function
--------------------------------------------
IF EXISTS(SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getSportLevelID')
)
DROP FUNCTION dbo.udf_getSportLevelID;
GO

CREATE FUNCTION dbo.udf_getSportLevelID(@sport NVarchar(25), @level NVarchar(25))
RETURNS INT
AS BEGIN

DECLARE @odSportLevel_id INT;
SELECT @odSportLevel_id = odSportLevel_id 
FROM gosSportLevel
WHERE sport = @sport AND
	  [level] = @level;

IF @odSportLevel_id IS NULL
SET @odSportLevel_id = -1;
RETURN @odSportLevel_id;
END
GO

------------------------------------
--Create Get SITE ID Function
--------------------------------------------
IF EXISTS(SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getSiteID')
)
DROP FUNCTION dbo.udf_getSiteID;
GO

CREATE FUNCTION dbo.udf_getSiteID(@siteName NVarchar(255))
RETURNS INT
AS BEGIN

DECLARE @odSite_id INT;
SELECT @odSite_id = odSite_id 
FROM gosSite
WHERE siteName = @siteName;

IF @odSite_id IS NULL
SET @odSite_id = -1;
RETURN @odSite_id;
END
GO

------------------------------------
--Create Get Game ID Function
--------------------------------------------
IF EXISTS(SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getGameID')
)
DROP FUNCTION dbo.udf_getGameID;
GO

CREATE FUNCTION dbo.udf_getGameID(@sport NVarchar(25), @level NVarchar(25), @siteName NVarchar(255), @gameDateTime datetime)
RETURNS INT
AS BEGIN

DECLARE @odGame_id INT;
SELECT @odGame_id = odGame_id 
FROM gosGame
WHERE odSite_id = dbo.udf_getSiteID(@siteName) 
AND gameDateTime = CONVERT(datetime, @gameDateTime) 
AND odSportLevel_id = dbo.udf_getSportLevelID(@sport, @level);

IF @odGame_id IS NULL
SET @odGame_id = -1;
RETURN @odGame_id;
END
GO

------------------------------------
--Create Get Position ID Function
--------------------------------------------
IF EXISTS(SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getPositionID')
)
DROP FUNCTION dbo.udf_getPositionID;
GO

CREATE FUNCTION dbo.udf_getPositionID(@positionName NVarchar(25))
RETURNS INT
AS BEGIN

DECLARE @odPosition_id INT;
SELECT @odPosition_id = odPosition_id 
FROM gosOfficiatingPosition
WHERE odPosition_id = @positionName;

IF @odPosition_id IS NULL
SET @odPosition_id = -1;
RETURN @odPosition_id;
END
GO

------------------------------------
--Create Get Official ID Function
--------------------------------------------
IF EXISTS(SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getOfficialID')
)
DROP FUNCTION dbo.udf_getOfficialID;
GO

CREATE FUNCTION dbo.udf_getOfficialID(@emailAddress NVarchar(255))
RETURNS INT
AS BEGIN

DECLARE @odUser_id INT;
SELECT @odUser_id = odUser_id 
FROM gosUser
WHERE emailAddress = @emailAddress;

IF @odUser_id IS NULL
SET @odUser_id = -1;
RETURN @odUser_id;
END
GO


-----------------------------------------------------------------------------------------------------------------------------------
--Create Procedures
-----------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddSportLevel')
DROP PROCEDURE usp_AddSportLevel;
GO

CREATE PROCEDURE [dbo].usp_AddSportLevel
@sport NVarchar(25),
@level NVarchar(25)

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosSportLevel(
		sport,
		[level]
		)
		VALUES
		(
			@sport,
			@level
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosSportLevel Table failed'
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddOfficiatingPosition')
DROP PROCEDURE usp_AddOfficiatingPosition;
GO

CREATE PROCEDURE [dbo].usp_AddOfficiatingPosition
@positionName NVarchar(25)

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosOfficiatingPosition(
		positionName
		)
		VALUES
		(
		@positionName
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosOfficiatingPosition Table failed'
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddSecurityQuestion')
DROP PROCEDURE usp_AddSecurityQuestion;
GO

CREATE PROCEDURE [dbo].usp_AddSecurityQuestion
@question NVarchar(255)

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosSecurityQuestion(
		question
		)
		VALUES
		(
		@question
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosSecurityQuestion Table failed'
	END CATCH
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddSite')
DROP PROCEDURE usp_AddSite;
GO

CREATE PROCEDURE [dbo].usp_AddSite
@siteName NVarchar(255),
@phoneNumber NVarchar(10),
@streetAdress NVarchar(255),
@city NVarchar(50),
@state NVarchar(2),
@zip NVarchar(9)

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosSite(
		siteName,
		phoneNumber,
		streetAddress,
		city,
		state,
		zip
		)
		VALUES
		(
		@siteName,
		@phoneNumber,
		@streetAdress,
		@city,
		@state,
		@zip
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosSiteName Table failed'
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddSchool')
DROP PROCEDURE usp_AddSchool;
GO

CREATE PROCEDURE [dbo].usp_AddSchool
@schoolName NVarchar(50),
@phoneNumber NVarchar(10),
@streetAdress NVarchar(255),
@city NVarchar(50),
@state NVarchar(2),
@zip NVarchar(9)

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosSchool(
		schoolName,
		phoneNumber,
		streetAddress,
		city,
		state,
		zip
		)
		VALUES
		(
		@schoolName,
		@phoneNumber,
		@streetAdress,
		@city,
		@state,
		@zip
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosSchoolName Table failed'
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddUser')
DROP PROCEDURE usp_AddUser;
GO

CREATE PROCEDURE [dbo].usp_AddUser
@emailAddress NVarchar(255),
@firstName NVarchar(25),
@lastName NVarchar(50),
@streetAddress NVarchar (255),
@city NVarchar(50),
@state NVarchar(2),
@zip NVarchar(9),
@cellPhoneNumber NVarchar(10),
@homePhoneNumber NVarchar(10) Null,
@workPhoneNumber NVarchar(10) Null

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosUser(
			emailAddress,
			firstName,
			lastName,
			streetAddress,
			city,
			[state],
			zip,
			cellPhoneNumber,
			homePhoneNumber,
			workPhoneNumber

		)
		VALUES
		(
		@emailAddress,
		@firstName,
		@lastName,
		@streetAddress,
		@city,
		@state,
		@zip,
		@cellPhoneNumber,
		@homePhoneNumber,
		@workPhoneNumber
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosUser Table failed'
	END CATCH
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddGame')
DROP PROCEDURE usp_AddGame;
GO

CREATE PROCEDURE [dbo].usp_AddGame
@gameDateTime dateTime,
@sport NVarchar(25),
@level NVarchar(25),
@siteName NVarchar(255),
@homeTeam NVarchar(255),
@visitingTeam NVarchar(255)

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosGame(
			gameDateTime,
			odSportLevel_id,
			odSite_id,
			homeTeam,
			visitingTeam

		)
		VALUES
		( 
			(SELECT CONVERT(datetime, @gameDateTime)),
			(SELECT dbo.udf_getSportLevelID(@sport, @level)),
			(SELECT dbo.udf_getSiteID(@siteName)),
			(SELECT dbo.udf_getSchoolID(@homeTeam)),
			(SELECT dbo.udf_getSchoolID(@visitingTeam))
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosGame Table failed'
	END CATCH
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddAD')
DROP PROCEDURE usp_AddAD;
GO

CREATE PROCEDURE [dbo].usp_AddAD
@emailAddress NVarchar(255),
@schoolName NVarchar(255)

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosAthleticDirector(
		odUser_id,
		odSchool_id
		)
		VALUES
		(
			(dbo.udf_getUserID(@emailAddress)),
			(dbo.udf_getSchoolID(@schoolName))
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosAthleticDirector Table failed'
	END CATCH
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddCoach')
DROP PROCEDURE usp_AddCoach;
GO
CREATE PROCEDURE [dbo].usp_AddCoach
@emailAddress NVarchar(255),
@schoolName NVarchar(255),
@sport NVarchar(25)

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosCoach(
		odUser_id,
		odSchool_id,
		sport
		)
		VALUES
		(
			(dbo.udf_getUserID(@emailAddress)),
			(dbo.udf_getSchoolID(@schoolName)),
			@sport
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosCoach Table failed'
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddAnswer')
DROP PROCEDURE usp_AddAnswer;
GO
CREATE PROCEDURE [dbo].usp_AddAnswer
@emailAddress NVarchar(255),
@question NVarchar(255),
@answer NVarchar(255)

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosSecurityAnswer(
		odUser_id,
		odQuestion_id,
		answer
		)
		VALUES
		(
			(dbo.udf_getUserID(@emailAddress)),
			(dbo.udf_getQuestionID(@question)),
			@answer
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosSecurityAnswer Table failed'
	END CATCH
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddGameOfficial')
DROP PROCEDURE usp_AddGameOfficial;
GO

CREATE PROCEDURE [dbo].usp_AddGameOfficial
@emailAddress NVarchar(255),
@siteName NVarchar(255),
@gameDateTime datetime,
@positionName NVarchar(255),
@sport NVarchar(25),
@level NVarchar(25)




AS 
BEGIN 
	BEGIN TRY

		IF NOT EXISTS(
			SELECT ggo.odGame_id
			FROM gosGameOfficial ggo INNER JOIN gosGame gg 
			ON ggo.odGame_id = gg.odGame_id
			WHERE ggo.odUser_id = dbo.udf_getUserID(@emailAddress)
			AND gg.gameDateTime = @gameDateTime 
			) 

			INSERT INTO gosGameOfficial(
			odUser_id,
			odGame_id,
			odPosition_id
			)
			VALUES
			(
				(SELECT dbo.udf_getOfficialID(@emailAddress)), 
				(SELECT dbo.udf_getGameID(@level, @sport,@siteName, @gameDateTime)),
				(SELECT dbo.udf_getPositionID(@positionName))
			);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosGameOfficial Table failed'
	END CATCH
END
GO
--EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com', @sport = 'Football', @level = 'Varsity', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Referee' ;





IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'udp_AddGameOfficialPayment')
DROP PROCEDURE udp_AddGameOfficialPayment;
GO

CREATE PROCEDURE [dbo].udp_AddGameOfficialPayment
@sport NVarchar(25),
@level NVarchar(25),
@gameDateTime dateTime,
@siteName NVarchar(255),
@emailAddress NVarchar(255),
@positionName NVarchar(25)

AS 
BEGIN 
	BEGIN TRY
		DECLARE
		@currentFeesAccum money,
		@gameFeePayment money,
		@newFeesAccum money

		SET @currentFeesAccum = (SELECT feesAccumulated FROM gosOfficial) --SELECT go to the fosOfficial table and get the fees accumulated value for the official)
		SET @gameFeePayment =  IF ((SELECT sport from gosSportLevel = 'Football') AND (SELECT [level] from gosSportLevel = 'Varsity')) THEN @gameFeePayment = 74.00
								ELSE IF(SELECT sport from gosSportLevel = 'Football') AND (SELECT [level] from gosSportLevel = 'Junior Varsity')) THEN @gameFeePayment = 59.00
								ELSE IF(SELECT sport from gosSportLevel = 'Football') AND (SELECT [level] from gosSportLevel = 'Sophmore')) THEN @gameFeePayment = 59.00
								ELSE IF(SELECT sport from gosSportLevel = 'Volleyball') AND (SELECT [level] from gosSportLevel = 'Varsity')) THEN @gameFeePayment = 59.00
								ELSE IF(SELECT sport from gosSportLevel = 'Football') AND (SELECT [level] from gosSportLevel = 'Sophmore')) THEN @gameFeePayment = 47.00
								ELSE IF(SELECT sport from gosSportLevel = 'Football') AND (SELECT [level] from gosSportLevel = 'Junior Varsity')) THEN @gameFeePayment = 59.00--Use the sport level and get the payment amount function
		SET @newFeesAccum = @currentFeesAccum  + @gameFeePayment;--Adding the current fees accumulated to the game fee payment

		IF NOT EXISTS (
			SELECT dbo.
			SELECT statement to look in the payment history table to see if the officail has been paid for this game
		)
		UPDATE gosOfficial
		SET feesAccumulated = @newFeesAccum 
		WHERE the user ID matches the officials ID;

		INSERT INTO gosGameOfficialPaymentHistory(
			odUser_id,
			odGame_id,
			odPosition_id,
			paymentAmount
		)
		VALUES
		(
			dbo.udf_getUserID(@emailAddress),
			dbo.udf_getGameID(@level, @sport,@siteName, @gameDateTime),
			dbo.udf_getPositionID(@positionName),
			@newFeesAccum
		);

	END TRY

	BEGIN CATCH
	PRINT 'Fee insertion into Game official Payment failed'
	END CATCH
END
GO




IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddOfficial')
DROP PROCEDURE usp_AddOfficial;
GO
CREATE PROCEDURE [dbo].usp_AddOfficial
@emailAddress NVarchar(255),
@feesAccumulated money

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosOfficial(
		odUser_id,
		feesAccumulated
		)
		VALUES
		(
			(dbo.udf_getUserID(@emailAddress)),
			@feesAccumulated
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosOfficial Table failed'
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'usp_AddArbiter')
DROP PROCEDURE usp_AddArbiter;
GO
CREATE PROCEDURE [dbo].usp_AddArbiter
@emailAddress NVarchar(255),
@sport NVarchar(25),
@level NVarchar(25)

AS 
BEGIN 
	BEGIN TRY
		INSERT INTO gosArbiter(
		odUser_id,
		odSportLevel_id
		)
		VALUES
		(
			(SELECT dbo.udf_getUserID(@emailAddress)),
			(SELECT dbo.udf_getSportLevelID(@sport, @level))
		);
	END TRY

	BEGIN CATCH
	PRINT 'Insert into gosArbiter Table failed'
	END CATCH
END
GO



--------------------------------
--Create View
--------------------------------
IF EXISTS(
	SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.udv_GameTeams')
)
DROP VIEW dbo.udv_GameTeams
GO
CREATE VIEW dbo.udv_GameTeams
AS
SELECT HTT.HomeTeamName, VTT.VisitingTeamName, HTT.gameDateTime, HTT.odSportLevel_id, Sport, [level], HTT.homeTeam, VTT.visitingTeam
FROM
(SELECT DISTINCT gsc.schoolName AS HomeTeamName, gameDateTime, odSportLevel_id, gg.homeTeam
FROM gosGame gg
INNER JOIN gosSchool gsc
ON gg.homeTeam = gsc.odSchool_id)HTT
INNER JOIN
(SELECT DISTINCT gsc.schoolName AS VisitingTeamName, gameDateTime, odSportLevel_id, gg.visitingTeam
FROM gosGame gg
INNER JOIN gosSchool gsc
ON gg.visitingTeam = gsc.odSchool_id)VTT
ON HTT.gameDateTime = VTT.gameDateTime
AND HTT.odSportLevel_id = VTT.odSportLevel_id
INNER JOIN gosSportLevel gsp
ON gsp.odSportLevel_id = HTT.odSportLevel_id
GO



IF EXISTS(
	SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.udv_GameOfficialPaymentHistory')
)
DROP VIEW dbo.udv_GameOfficialPaymentHistory
GO
CREATE VIEW dbo.udv_GameOfficialPaymentHistory
AS
SELECT firstName, lastname, HTT.HomeTeamName, VTT.VisitingTeamName, HTT.gameDateTime, HTT.odSportLevel_id, Sport, [level], HTT.homeTeam, VTT.visitingTeam
FROM
(SELECT DISTINCT gsc.schoolName AS HomeTeamName, gameDateTime, odSportLevel_id, gg.homeTeam
FROM gosGame gg
INNER JOIN gosSchool gsc
ON gg.homeTeam = gsc.odSchool_id)HTT
INNER JOIN
(SELECT DISTINCT gsc.schoolName AS VisitingTeamName, gameDateTime, odSportLevel_id, gg.visitingTeam
FROM gosGame gg
INNER JOIN gosSchool gsc
ON gg.visitingTeam = gsc.odSchool_id)VTT
ON HTT.gameDateTime = VTT.gameDateTime
AND HTT.odSportLevel_id = VTT.odSportLevel_id
INNER JOIN gosSportLevel gsp
ON gsp.odSportLevel_id = HTT.odSportLevel_id
GO




--EXECUTE usp_AddSportLevel @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddSportLevel @sport = 'Basketball-Men', @level = 'Varsity';
EXECUTE usp_AddSportLevel @sport = 'Basketball-Women', @level = 'Varsity';
--EXECUTE usp_AddSportLevel @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddSportLevel @sport = 'Baseball', @level = 'Varsity';
EXECUTE usp_AddSportLevel @sport = 'Softball', @level = 'Varsity';
EXECUTE usp_AddSportLevel @sport = 'Soccer-Men', @level = 'Varsity';
EXECUTE usp_AddSportLevel @sport = 'Soccer-Women', @level = 'Varsity';

--EXECUTE usp_AddSportLevel @sport = 'Football', @level = 'Junior Varsity';
EXECUTE usp_AddSportLevel @sport = 'Basketball-Men', @level = 'Junior Varsity';
EXECUTE usp_AddSportLevel @sport = 'Basketball-Women', @level = 'Junior Varsity';
--EXECUTE usp_AddSportLevel @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddSportLevel @sport = 'Baseball', @level = 'Junior Varsity';
EXECUTE usp_AddSportLevel @sport = 'Softball', @level = 'Junior Varsity';
EXECUTE usp_AddSportLevel @sport = 'Soccer-Men', @level = 'Junior Varsity';
EXECUTE usp_AddSportLevel @sport = 'Soccer-Women', @level = 'Junior Varsity';

--EXECUTE usp_AddSportLevel @sport = 'Football', @level = 'Sophmore';
EXECUTE usp_AddSportLevel @sport = 'Basketball-Men', @level = 'Sophmore';
EXECUTE usp_AddSportLevel @sport = 'Basketball-Women', @level = 'Sophmore';
--EXECUTE usp_AddSportLevel @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddSportLevel @sport = 'Baseball', @level = 'Sophmore';
EXECUTE usp_AddSportLevel @sport = 'Softball', @level = 'Sophmore';
EXECUTE usp_AddSportLevel @sport = 'Soccer-Men', @level = 'Sophmore';
EXECUTE usp_AddSportLevel @sport = 'Soccer-Women', @level = 'Sophmore';

EXECUTE usp_AddSportLevel @sport = 'Football', @level = 'Freshman';
EXECUTE usp_AddSportLevel @sport = 'Basketball-Men', @level = 'Freshman';
EXECUTE usp_AddSportLevel @sport = 'Basketball-Women', @level = 'Freshman';
--EXECUTE usp_AddSportLevel @sport = 'Volleyball', @level = 'Freshman';
EXECUTE usp_AddSportLevel @sport = 'Baseball', @level = 'Freshman';
EXECUTE usp_AddSportLevel @sport = 'Softball', @level = 'Freshman';
EXECUTE usp_AddSportLevel @sport = 'Soccer-Men', @level = 'Freshman';
EXECUTE usp_AddSportLevel @sport = 'Soccer-Women', @level = 'Freshman';

EXECUTE usp_AddOfficiatingPosition @positionName = 'Referee';
EXECUTE usp_AddOfficiatingPosition @positionName = 'Umpire';
EXECUTE usp_AddOfficiatingPosition @positionName = 'Head Linesman';
EXECUTE usp_AddOfficiatingPosition @positionName = 'Line Judge';
EXECUTE usp_AddOfficiatingPosition @positionName = 'Back Judge';

EXECUTE usp_AddOfficiatingPosition @positionName = 'Assistant Referee Left';
EXECUTE usp_AddOfficiatingPosition @positionName = 'Assistant Referee Right';
EXECUTE usp_AddOfficiatingPosition @positionName = 'Plate Umpire';
EXECUTE usp_AddOfficiatingPosition @positionName = 'Base Umpire';
EXECUTE usp_AddOfficiatingPosition @positionName = 'Linesman 1';
EXECUTE usp_AddOfficiatingPosition @positionName = 'Linesman 2';


EXECUTE usp_AddSecurityQuestion @question = 'What is your oldest siblings middle name?';
EXECUTE usp_AddSecurityQuestion @question = 'What school did you attend for sixth grade?';
EXECUTE usp_AddSecurityQuestion @question = 'What was your childhood phone number including area code? (e.g., 000-000-0000)';
EXECUTE usp_AddSecurityQuestion @question = 'What is your oldest cousins first and last name?';
EXECUTE usp_AddSecurityQuestion @question = 'What was the name of your first stuffed animal?';
EXECUTE usp_AddSecurityQuestion @question = 'In what city or town did your mother and father meet?';
EXECUTE usp_AddSecurityQuestion @question = 'Where were you when you had your first kiss?';
EXECUTE usp_AddSecurityQuestion @question = 'What is the first name of the boy or girl that you first kissed?';
EXECUTE usp_AddSecurityQuestion @question = 'What was the last name of your third grade teacher?';
EXECUTE usp_AddSecurityQuestion @question = 'In what city does your nearest sibling live?';

EXECUTE usp_AddSite @siteName = 'Ben Lomond High School',	@phoneNumber = '8017377965', @streetAdress = '251 E 4800 S', @city = 'Ogden', @state = 'UT', @zip = '844045199';
EXECUTE usp_AddSite @siteName = 'Bonneville High School',	@phoneNumber = '801-452-4050', @streetAdress = '800 Scots Ln ', @city = 'Ogden', @state = 'UT', @zip = '84405-6199';
EXECUTE usp_AddSite @siteName = 'Bountiful High School',	@phoneNumber = '801-402-3900', @streetAdress = '695 Orchard Dr ', @city = 'Bountiful', @state = 'UT', @zip = '84010';
EXECUTE usp_AddSite @siteName = 'Box Elder High School',	@phoneNumber = '435-734-4840', @streetAdress = '380 S 600 W ', @city = 'Brigham City', @state = 'UT', @zip = '84302-2442';
EXECUTE usp_AddSite @siteName = 'Davis High School',	@phoneNumber = '801-402-8800', @streetAdress = '325 S Main St ', @city = 'Kaysville', @state = 'UT', @zip = '84037-2598';
EXECUTE usp_AddSite @siteName = 'Green Canyon High School',	@phoneNumber = '435-792-9300', @streetAdress = '2960 N Wolfpack Way', @city = 'North Logan', @state = 'UT', @zip = '84341';
EXECUTE usp_AddSite @siteName = 'Logan High School',	@phoneNumber = '435-755-2380', @streetAdress = '162 W 100 S', @city = 'Logan', @state = 'UT', @zip = '84321-5298';
EXECUTE usp_AddSite @siteName = 'Ogden High School',	@phoneNumber = '801-737-8700', @streetAdress = '2828 Harrison Blvd', @city = 'Ogden', @state = 'UT', @zip = '84403-0398';
EXECUTE usp_AddSite @siteName = 'Ridgeline High School',	@phoneNumber = '435 792 7780', @streetAdress = '180 North 300 West', @city = 'Millville', @state = 'UT', @zip = '84326-0398';
EXECUTE usp_AddSite @siteName = 'Syracuse High School',	@phoneNumber = '801-402-7900', @streetAdress = '665 S 2000 W ', @city = 'Syracuse', @state = 'UT', @zip = '84075';
EXECUTE usp_AddSite @siteName = 'Viewmont High School',	@phoneNumber = '801-402-4200', @streetAdress = '120 W 1000 N ', @city = 'Bountiful', @state = 'UT', @zip = '84010';
EXECUTE usp_AddSite @siteName = 'Weber High School',	@phoneNumber = '801-746-3700', @streetAdress = '3650 N 500 W', @city = 'Ogden', @state = 'UT', @zip = '84414-1455';
EXECUTE usp_AddSite @siteName = 'Woods Cross High School',	@phoneNumber = '801 402 4500', @streetAdress = '600 W 2200 S', @city = 'Woods Cross', @state = 'UT', @zip = '84087';
EXECUTE usp_AddSite @siteName = 'USU',	@phoneNumber = '435 797 0453', @streetAdress = 'Maverik Stadium 1000 North 800 East', @city = 'Logan', @state = 'UT', @zip = '84341';
EXECUTE usp_AddSite @siteName = 'Stewart Stadium',	@phoneNumber = ' 801 626 8500', @streetAdress = '3848 Harrison Blvd', @city = 'Ogden', @state = 'UT', @zip = '84408';


EXECUTE usp_AddSchool @schoolName = 'Ben Lomond High School',	@phoneNumber = '801-737-7965', @streetAdress = '800 Scots Ln', @city = 'Ogden', @state = 'UT', @zip = '84404-5199';
EXECUTE usp_AddSchool @schoolName = 'Bonneville High School',	@phoneNumber = '801-452-4050', @streetAdress = '251 E 4800 S', @city = 'Ogden', @state = 'UT', @zip = '84405-6199';
EXECUTE usp_AddSchool @schoolName = 'Green Canyon High School',	@phoneNumber = '435-792-9300', @streetAdress = '2960 N Wolfpack Way', @city = 'North Logan', @state = 'UT', @zip = '84341';
EXECUTE usp_AddSchool @schoolName = 'Ogden High School',	@phoneNumber = '801-737-8700', @streetAdress = '2828 Harrison Blvd', @city = 'Ogden', @state = 'UT', @zip = '84403-0398';
EXECUTE usp_AddSchool @schoolName = 'Viewmont High School',	@phoneNumber = '801-402-4200', @streetAdress = '120 W 1000 N', @city = 'Bountiful', @state = 'UT', @zip = '84010';
EXECUTE usp_AddSchool @schoolName = 'USU',	@phoneNumber = '435 797 0453', @streetAdress = 'Maverik Stadium 1000 North 800 East', @city = 'Logan', @state = 'UT', @zip = '84341';
EXECUTE usp_AddSchool @schoolName = 'Stewart Stadium',	@phoneNumber = ' 801 626 8500', @streetAdress = '3848 Harrison Blvd', @city = 'Ogden', @state = 'UT', @zip = '84408';


---------------------
--Coaches
---------------------
EXECUTE usp_AddUser @emailAddress = 'mknight@dsdmail.net' , @firstName = 'Michael', @lastName = 'Knight', @streetAddress = '665 S 2000 W ', @city = 'Syracuse', @state = 'UT', @zip = '84075', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-402-7900';
EXECUTE usp_AddUser @emailAddress = 'fkotoa@dsdmail.net' , @firstName = 'Fotu', @lastName = 'Kotoa', @streetAddress = '440 Wasatch Dr', @city = 'Layton', @state = 'UT', @zip = '84041-3272', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-402-4800';
EXECUTE usp_AddUser @emailAddress = 'adyson@dsdmail.net' , @firstName = 'Andre', @lastName = 'Dyson', @streetAddress = ' 931  S Falcon Drive', @city = 'Clearfield', @state = 'UT', @zip = '84015', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-402-8200';
EXECUTE usp_AddUser @emailAddress = 'fkotoa@dsdmail.net' , @firstName = 'Fred', @lastName = 'Fernandes', @streetAddress = '2150 W 4800 S', @city = 'Roy', @state = 'UT', @zip = '84067-1899', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-774-4922';
EXECUTE usp_AddUser @emailAddress = 'rarnold@wsd.net' , @firstName = 'Ross', @lastName = 'Arnold', @streetAddress = '1900 N 4700 W', @city = 'Ogden', @state = 'UT', @zip = '  UT 84404', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-452-4000';
EXECUTE usp_AddUser @emailAddress = 'thompsone@ogdensd.org' , @firstName = 'Erik', @lastName = 'Thompson', @streetAddress = '2828 Harrison Blvd', @city = 'Ogden', @state = 'UT', @zip = '84403-0398', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-737-8700';
EXECUTE usp_AddUser @emailAddress = 'eglover@wsd.net' , @firstName = 'Erin', @lastName = 'Glover', @streetAddress = '251 E 4800 S', @city = 'Ogden', @state = 'UT', @zip = '84405-6199', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-452-4050';
EXECUTE usp_AddUser @emailAddress = 'smithkel@ogdensd.org' , @firstName = 'Kelsey', @lastName = 'Smith', @streetAddress = '800 Scots Ln', @city = 'Ogden', @state = 'UT', @zip = '84404-5199', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-737-7965';
EXECUTE usp_AddUser @emailAddress = 'kharding@besd.org' , @firstName = 'Kris', @lastName = 'Harding', @streetAddress = '800 Scots Ln', @city = 'Ogden', @state = 'UT', @zip = '84404-5199', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-737-7965';
EXECUTE usp_AddUser @emailAddress = 'abowles@wsd.net' , @firstName = 'Alise', @lastName = 'Bowles', @streetAddress = '1900 N 4700 W', @city = 'Ogden', @state = 'UT', @zip = '84404', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-452-4000';
EXECUTE usp_AddUser @emailAddress = 'cwise@besd.org' , @firstName = 'Chris', @lastName = 'Wise', @streetAddress = '1450 S Main St', @city = 'Garland', @state = 'UT', @zip = '84312-9797', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '435-257-2500';

----------------------
--ADs
----------------------
EXECUTE usp_AddUser @emailAddress = 'jbatchelor@dsdmail.net' , @firstName = 'Jim', @lastName = 'Bachelor',@streetAddress = '800 Scots Ln', @city = 'Ogden', @state = 'UT', @zip = '84404-5199', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-402-4800';
EXECUTE usp_AddUser @emailAddress = 'jemery@dsdmail.net' , @firstName = 'Jeff', @lastName = 'Emery',@streetAddress = '120 W 1000 N', @city = 'Bountiful', @state = 'UT', @zip = '84010', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-402-4200';
EXECUTE usp_AddUser @emailAddress = 'kiltsj@ogdensd.org' , @firstName = 'Jeff', @lastName = 'Kilts',@streetAddress = '120 W 1000 N', @city = 'Bountiful', @state = 'UT', @zip = '84010', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '8017377965';
EXECUTE usp_AddUser @emailAddress = 'macqueens@ogdensd.org' , @firstName = 'Shawn', @lastName = 'MaQueen', @streetAddress = '2828 Harrison Blvd', @city = 'Ogden', @state = 'UT', @zip = '84403-0398', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-737-8700';
EXECUTE usp_AddUser @emailAddress = 'cmelaney@wsd.net' , @firstName = 'Corey', @lastName = 'Melaney', @streetAddress = '1900 N 4700 W', @city = 'Ogden', @state = 'UT', @zip = '84404', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-452-4000';
EXECUTE usp_AddUser @emailAddress = ' tmikesell@morgansd.org' , @firstName = 'Tyrel', @lastName = 'Mikesell', @streetAddress = '55 Trojan Blvd', @city = 'Morgan', @state = 'UT', @zip = '84050-0917', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-829-3418';
EXECUTE usp_AddUser @emailAddress = ' dlmimnaugh@wsd.net' , @firstName = 'Lance', @lastName = 'Mimnaugh', @streetAddress = '800 Scots Ln ', @city = 'Ogden', @state = 'UT', @zip = '84405-6199', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '801-452-4050';
EXECUTE usp_AddUser @emailAddress = ' van.park@besd.net' , @firstName = 'Van', @lastName = 'Park', @streetAddress = '1450 S Main St ', @city = 'Garland', @state = 'UT', @zip = '84312-9797', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '435-257-2500';
EXECUTE usp_AddUser @emailAddress = ' kim.peterson@besd.net' , @firstName = 'Kim', @lastName = 'Peterson', @streetAddress = '380 S 600 W ', @city = 'Brigham City', @state = 'UT', @zip = '84302-2442', @cellPhoneNumber = null, @homePhoneNumber = null, @workPhoneNumber = '435-734-4840';

--------------------------
--Users
--------------------------

EXECUTE usp_AddUser @emailAddress = 'ack.devin@gmail.com',				@lastName = 'Ackerman',	@firstName = 'Devin',			@streetAddress = '3215 S 2500 W #2',			@city = 'Roy',					@state = 'UT', @zip = '84067',		@cellPhoneNumber = '801-252-0239', @homePhoneNumber = NULL,				@workPhoneNumber = null;   
EXECUTE usp_AddUser @emailAddress = 'refchrisadams@gmail.com',			@firstName = 'Chris',	@lastName = 'Adams'	,			@streetAddress = '358 West 200 North',			@city = 'Kaysville',			@state = 'UT', @zip = '84037',		@cellPhoneNumber = '801-699-4403', @homePhoneNumber = NULL,				@workPhoneNumber = '801-777-4911';	
EXECUTE usp_AddUser @emailAddress = 'bga78@msn.com',					@firstName = 'Bryce',	@lastName = 'Allen'	,			@streetAddress = '470 E 180 N',					@city = 'Smithfield',			@state = 'UT', @zip = '84335',		@cellPhoneNumber = '435-760-0623', @homePhoneNumber = '435-562-3710' ,	@workPhoneNumber = null;	
EXECUTE usp_AddUser @emailAddress = 'grukmuk@msn.com',					@firstName = 'Randy',	@lastName = 'Allen'	,			@streetAddress = '3592 South 400 East',			@city = 'Logan',				@state = 'UT', @zip = '84321',		@cellPhoneNumber = '435-232-1449', @homePhoneNumber = '435-755-7148' ,	@workPhoneNumber = '435-752-9456';	
EXECUTE usp_AddUser @emailAddress = 'brandon@petro.com',				@firstName = 'BRAYDON',	@lastName = 'ATKINSON',			@streetAddress = '2233 S. 1500 W.' ,			@city = 'Woods Cross',			@state = 'UT', @zip = '84087',		@cellPhoneNumber = '801-509-3487', @homePhoneNumber = '801-294-2798' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'tybar14@hotmail.com',				@firstName = 'Tyson',	@lastName = 'Barfuss',			@streetAddress = '2212 North 750 West',			@city = 'Ogden',				@state = 'UT', @zip = '84414',		@cellPhoneNumber = '801-526-3903', @homePhoneNumber = null,				@workPhoneNumber = NULL		;
EXECUTE usp_AddUser @emailAddress = 'karlbeckstrom@msn.com',			@firstName = 'KARL',	@lastName = 'BECKSTROM',		@streetAddress = '2889 West 1125' ,				@city = 'North Layton',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-678-7948', @homePhoneNumber = '801-839-5679' ,	@workPhoneNumber = '801-204-4546';	
EXECUTE usp_AddUser @emailAddress = 'mikeb@aspen.com',					@firstName = 'Mike',	@lastName = 'Benson'	,		@streetAddress = '65 W. 1800 S.' ,				@city = 'BONTIFUL',				@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-721-8613', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'paul.bernier@gmail.com',			@firstName = 'Paul',	@lastName = 'Bernier',			@streetAddress = '1145 N. 1120 W.',				@city = 'Clinton',				@state = 'UT', @zip = '84015',		@cellPhoneNumber = '801-726-9342', @homePhoneNumber = '801-776-7584	' , @workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'ldjbon@gmail.com',					@firstName = 'Larry',	@lastName = 'Bonnett',			@streetAddress = '2434 Gramercy Avenue',		@city = 'Ogden',				@state = 'UT', @zip = '84401',		@cellPhoneNumber = '330-258-3674', @homePhoneNumber = '385-206-8476	' , @workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'jeffbraun8@gmail.com',				@firstName = 'Jeff',	@lastName = 'Braun'	,			@streetAddress = '3834 N 400 E',				@city = 'Ogden',				@state = 'UT', @zip = '84414',		@cellPhoneNumber = '801-391-3437', @homePhoneNumber = '801-737-3482	' , @workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'ronbrenk@q.com',					@firstName = 'Ron',		@lastName = 'Brenkmann'	,		@streetAddress = '1550 N. 1750 W.',				@city = 'Plain City',			@state = 'UT', @zip = '84404',		@cellPhoneNumber = '801-648-5447', @homePhoneNumber = '801-732-9136	' , @workPhoneNumber = '801-536-7561';	
EXECUTE usp_AddUser @emailAddress = 'brownfgary@yahoo.com',				@firstName = 'Gary',	@lastName = 'Brown'	,			@streetAddress = '623 West 3050',				@city = 'South Syracuse',		@state = 'UT', @zip = '84075',		@cellPhoneNumber = '801-660-4529', @homePhoneNumber = Null,				@workPhoneNumber = NULL;	
EXECUTE usp_AddUser @emailAddress = 'davidbueller@yahoo.com',			@firstName = 'David',	@lastName = 'Bueller'	,		@streetAddress = '1050 E 1700 N',				@city = 'Layton',				@state = 'UT', @zip = '84040',		@cellPhoneNumber = '801-725-3457', @homePhoneNumber = '801-510-7830' ,	@workPhoneNumber = '801-775-6878';
EXECUTE usp_AddUser @emailAddress = 'burnettdan@hotmail.com',			@firstName = 'Daniel',	@lastName = 'Burnett'	,		@streetAddress = 'P.O. Box 145' ,				@city = 'Riverside',			@state = 'UT', @zip = '84334',		@cellPhoneNumber = '435-279-4156', @homePhoneNumber = '435-458-3232' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'bryanburningham@hotmail.com',		@firstName = 'Bryan',	@lastName = 'Burningham',		@streetAddress = '532 E 1250 N',				@city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-690-0329', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'kamburny@mstar.net',				@firstName = 'Kamaron',	@lastName = 'Burningham',		@streetAddress = '454 West 1850 South',			@city = 'Woods Cross',			@state = 'UT', @zip = '84087-2112', @cellPhoneNumber = '801-510-4833', @homePhoneNumber = '801-292-9489' ,	@workPhoneNumber = '801-298-6036';
EXECUTE usp_AddUser @emailAddress = 'cartercarl_358@hotmail.com',		@firstName = 'Carl',	@lastName = 'Carter'	,		@streetAddress = '135 E 500 N',					@city = 'Kaysville',			@state = 'UT', @zip = '84037',		@cellPhoneNumber = '801-682-0896', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'bobcarre@live.com',				@firstName = 'Bob',		@lastName = 'Christensen',		@streetAddress = '5343 S 1500 E',				@city = 'South Weber',			@state = 'UT', @zip = '84405',		@cellPhoneNumber = '801-262-8735', @homePhoneNumber = NULL,				@workPhoneNumber = '801-699-9279';
EXECUTE usp_AddUser @emailAddress = 'dfc99@yahoo.com',					@firstName = 'Devin',	@lastName = 'Christensen',		@streetAddress = '1776 NORTH 1325 WEST',		@city = 'Clinton',				@state = 'UT', @zip = '84015',		@cellPhoneNumber = '801-388-2399', @homePhoneNumber = NULL,				@workPhoneNumber = '801-594-9600';
EXECUTE usp_AddUser @emailAddress = 'jon34131.jc@gmail.om',				@firstName = 'Jonathan',@lastName = 'christensen',		@streetAddress = '524w. 1980s.' ,				@city = 'nibley',				@state = 'UT', @zip = '84321',		@cellPhoneNumber = '435-454-1654', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'nickcole@gmail.com',				@firstName = 'Nick',	@lastName = 'Cole'	,			@streetAddress = '1775 N. 400 E. # 9' ,			@city = 'Logan',				@state = 'UT', @zip = '84341',		@cellPhoneNumber = '435-760-1256', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'wcole@gmail.com',					@firstName = 'William',	@lastName = 'Cole'	,			@streetAddress = '1642 n. 1125 e.' ,			@city = 'NORTH OGDEN',			@state = 'UT', @zip = '84414',		@cellPhoneNumber = '801-410-9738', @homePhoneNumber = '801-510-4727' ,	@workPhoneNumber = '801-409-2114';
EXECUTE usp_AddUser @emailAddress = 'trevorcondie@comcast.net',			@firstName = 'Trevor',	@lastName = 'Condie'	,		@streetAddress = '3478 Lakeview Drive' ,		@city = 'North Ogden',			@state = 'Ut', @zip = '84414',		@cellPhoneNumber = '801-203-3645', @homePhoneNumber = '801-782-3879' ,	@workPhoneNumber = '435-863-9450';
EXECUTE usp_AddUser @emailAddress = 'kconnersUtah@comcast.net',			@firstName = 'Kevin',	@lastName = 'Conners'	,		@streetAddress = '1862 N 290 W' ,				@city = 'Layton',				@state = 'UT', @zip = '84041',		@cellPhoneNumber = '801-609-3386', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'randall.crowell@autoliv.net',		@firstName = 'Randall',	@lastName = 'Crowell'	,		@streetAddress = '2458 N. 400 E.' ,				@city = 'North Ogden',			@state = 'UT', @zip = '84414',		@cellPhoneNumber = '801-743-8813', @homePhoneNumber = NULL,				@workPhoneNumber = '801-625-2477';
EXECUTE usp_AddUser @emailAddress = 'kevinc987@yahoo.com'		,		@firstName = 'Kevin	',	@lastName = 'Cullimore'	,		@streetAddress = '335 South Kays Drive' ,		@city = 'Kaysville',			@state = 'Ut', @zip = '84037',		@cellPhoneNumber = '801-656-9890', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'kraigculli@hotmail.com'	,		@firstName = 'Kraig	',	@lastName = 'Cullimore'	,		@streetAddress = '498 N 2375 W	' ,				@city = 'West Point',			@state = 'UT', @zip = '84015',		@cellPhoneNumber = '801-809-3103', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'konnorcullimore@live.com'	,		@firstName = 'Konnor',	@lastName = 'Cullimore'	,		@streetAddress = '1676 w 1400n' ,				@city = 'Farr West',			@state = 'ut', @zip = '84404',		@cellPhoneNumber = '801-605-9846', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'cactuscutler89@yahoo.com',			@firstName = 'Mark',	@lastName = 'Cutler'	,		@streetAddress = '466 South 400 West' ,			@city = 'Garland',				@state = 'Ut', @zip = '84312',		@cellPhoneNumber = '435-452-3380', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'braddavies50@hotmail.com',			@firstName = 'Bradley',	@lastName = 'Davies'	,		@streetAddress = '1458 West 1260 North' ,		@city = 'Clinton',				@state = 'UT', @zip = '84015',		@cellPhoneNumber = '801-460-3662', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'evandavis@gmail.com'	,			@firstName = 'Evan',	@lastName = 'Davis'	,			@streetAddress = '68 South 1450 West' ,			@city = 'Clearfield',			@state = 'UT', @zip = '84015',		@cellPhoneNumber = '801-549-8977', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'mdavis345@gmail.com'	,			@firstName = 'Mark',	@lastName = 'Davis'	,			@streetAddress = '3590 van buren #42' ,			@city = 'Ogden',				@state = 'Ut', @zip = '84403',		@cellPhoneNumber = '801-608-3618', @homePhoneNumber = '801-422-2947' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'tomdeelstra@utah.gov'	,			@firstName = 'Tom',		@lastName = 'Deelstra'	,		@streetAddress = '2757 W 1825 S	' ,				@city = 'West Haven',			@state = 'UT', @zip = '84401',		@cellPhoneNumber = '801-488-8496', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'freddenucci@comcast.net'	,		@firstName = 'Fredrick',@lastName = 'Denucci'	,		@streetAddress = '3460 S. Elaine' ,				@city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-690-0113', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'david.dickson@gmail.com',			@firstName = 'David',	@lastName = 'Dickson'	,		@streetAddress = '234 Eagle Way	' ,				@city = 'Fruit Heights',		@state = 'UT', @zip = '84037',		@cellPhoneNumber = '801-829-6606', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'devindom@msn.com'	,				@firstName = 'Devin',	@lastName = 'Dominguez'	,		@streetAddress = '3021 w 2450 s	' ,				@city = 'West Haven',			@state = 'UT', @zip = '84401',		@cellPhoneNumber = '801-806-5015', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'jeffdowns@gmail.com',				@firstName = 'Jeff',	@lastName = 'Downs'	,			@streetAddress = '257 W. 675 S.	' ,				@city = 'Kaysville',			@state = 'UT', @zip = '84037',		@cellPhoneNumber = '801-602-4270', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'brettdyer@live.com	',				@firstName = 'Brett',	@lastName = 'Dyer'	,			@streetAddress = '3612 w 300 s	' ,				@city = 'Ogden',				@state = 'Ut', @zip = '84404',		@cellPhoneNumber = '801-680-6321', @homePhoneNumber = '801-293-4136' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'brevindyer29@live.com',			@firstName = 'Brevin',	@lastName = 'Dyer'	,			@streetAddress = '3612 w 300 s	' ,				@city = 'Ogden',				@state = 'UT', @zip = '84404',		@cellPhoneNumber = '801-308-2820', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'kevindyer36@digis.net',			@firstName = 'Kevin',	@lastName = 'Dyer'	,			@streetAddress = '1788 W 675 S	' ,				@city = 'OGDEN',				@state = 'UT', @zip = '84404',		@cellPhoneNumber = '801-940-3915', @homePhoneNumber = '801-393-2936' ,	@workPhoneNumber = '801-374-2800';
EXECUTE usp_AddUser @emailAddress = 'portsref20@yahoo.com',				@firstName = 'Ronald',	@lastName = 'Eames'	,			@streetAddress = '5249 W 12825 N' ,				@city = 'GARLAND',				@state = 'UT', @zip = '84312',		@cellPhoneNumber = '435-279-4880', @homePhoneNumber = '435-257-9625' ,	@workPhoneNumber = NULL;	
EXECUTE usp_AddUser @emailAddress = 'matt_elkins@msn.com',				@firstName = 'Matt',	@lastName = 'Elkins',			@streetAddress = '1415 N. 2225 W' ,				@city = 'Layton',				@state = 'UT', @zip = '84041',		@cellPhoneNumber = '801-589-9826', @homePhoneNumber = NULL,				@workPhoneNumber = '801-775-9850';
EXECUTE usp_AddUser @emailAddress = 'brfootball67@gmail.com',			@firstName = 'Charles',	@lastName = 'Ellis'	,			@streetAddress = '1850 W 875 N Apt A8' ,		@city = 'Layton',				@state = 'Ut', @zip = '84041',		@cellPhoneNumber = '435-230-3951', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'michaelengledow@comcast.net',		@firstName = 'Michael',	@lastName = 'Engledow',			@streetAddress = 'P.O. Box 399' ,				@city = 'Layton',				@state = 'UT', @zip = '84041',		@cellPhoneNumber = '801-619-1287', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'thoma.evans49@gmail.com',			@firstName = 'Thomas',	@lastName = 'Evans'	,			@streetAddress = '3052B Minuteman Way' ,		@city = 'Hill AFB',				@state = 'UT', @zip = '84056',		@cellPhoneNumber = '808-271-2491', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'georgeeverett@hotmail.com',		@firstName = 'GEORGE',	@lastName = 'EVERETT',			@streetAddress = '1372 NORTH 3450 EAST' ,		@city = 'Layton',				@state = 'UT', @zip = '84040',		@cellPhoneNumber = '801-721-5872', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'steven.farnsworth@gmail.com',		@firstName = 'Steven',	@lastName = 'Farnsworth',		@streetAddress = '534 West 800 South' ,			@city = 'Layton',				@state = 'UT', @zip = '84041',		@cellPhoneNumber = '435-502-2320', @homePhoneNumber = NULL,				@workPhoneNumber = '801-566-3428';
EXECUTE usp_AddUser @emailAddress = 'marcus.federer@yahoo.com',			@firstName = 'Marcus',	@lastName = 'Federer',			@streetAddress = '3255 N. 4575 W.' ,			@city = 'Plain City',			@state = 'UT', @zip = '84404',		@cellPhoneNumber = '805-508-3384', @homePhoneNumber = NULL,				@workPhoneNumber = '801-546-9889';
EXECUTE usp_AddUser @emailAddress = 'mariofurm@comcast.net',			@firstName = 'Mario	',	@lastName = 'Fuhriman'	,		@streetAddress = '236 North 300 East' ,			@city = 'Providence',			@state = 'UT', @zip = '84332',		@cellPhoneNumber = '435-765-4477', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'galbraith98@comcast.net',			@firstName = 'Reggie',	@lastName = 'Galbraith'	,		@streetAddress = '1323 29TH STREET' ,			@city = 'Ogden',				@state = 'UT', @zip = '84403',		@cellPhoneNumber = '801-696-5346', @homePhoneNumber = '801-601-2850' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'gangwerroger@aol.com',				@firstName = 'roger',	@lastName = 'gangwer',			@streetAddress = '1390 W 1800 N' ,				@city = 'Farr West',			@state = 'UT', @zip = '84404',		@cellPhoneNumber = '801-460-5963', @homePhoneNumber = '801-742-4842' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'cgermany@comcast.net',				@firstName = 'Chris',	@lastName = 'Germany',			@streetAddress = '350 N. Sherwood Dr' ,			@city = 'Providence',			@state = 'UT', @zip = '84332',		@cellPhoneNumber = '801-247-9674', @homePhoneNumber = '435-756-4282' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'graycurtis39@aol.com',				@firstName = 'Curtis',	@lastName = 'Gray'	,			@streetAddress = '1740 North Dennis Dr.' ,		@city = 'North Ogden',			@state = 'UT', @zip = '84414',		@cellPhoneNumber = '801-929-1386', @homePhoneNumber = NULL,				@workPhoneNumber = '801-409-0780';
EXECUTE usp_AddUser @emailAddress = 'tomgriff@gmail.com',				@firstName = 'Thomas',	@lastName = 'Griffin',			@streetAddress = '850 N 4000 W' ,				@city = 'Mendon',				@state = 'UT', @zip = '84325',		@cellPhoneNumber = '435-760-9366', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'shadley@juno.com',					@firstName = 'Steven',	@lastName = 'Hadley',			@streetAddress = '372 N Brahma Rd.' ,			@city = 'Farmington',			@state = 'UT', @zip = '84025',		@cellPhoneNumber = '801-804-0579', @homePhoneNumber = '801-451-3320' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'keith.hales@yahoo.com',			@firstName = 'Keith',	@lastName = 'Hales'	,			@streetAddress = '366 W Center St' ,			@city = 'Kaysville',			@state = 'Ut', @zip = '84037',		@cellPhoneNumber = '801-510-2365', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'johnhancock@yahoo.com',			@firstName = 'John',	@lastName = 'Hancock',			@streetAddress = '442 S. 4200 W.' ,				@city = 'Ogden',				@state = 'UT', @zip = '84404',		@cellPhoneNumber = '801-309-4440', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'markhaney@hotmail.com',			@firstName = 'Mark',	@lastName = 'Haney'	,			@streetAddress = '3317 S. Bluff Ridge Dr' ,		@city = 'Syracuse',				@state = 'UT', @zip = '84075',		@cellPhoneNumber = '801-637-7959', @homePhoneNumber = NULL,				@workPhoneNumber = '801-454-6098';	
EXECUTE usp_AddUser @emailAddress = 'dannyghansen@gmail.com',			@firstName = 'Daniel',	@lastName = 'Hansen',			@streetAddress = '1226 West 4550' ,				@city = 'North Amalga',			@state = 'UT', @zip = '84335',		@cellPhoneNumber = '435-740-0141', @homePhoneNumber = '435-545-9052' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'anthonyharris@gmail.com',			@firstName = 'Anthony',	@lastName = 'Harris',			@streetAddress = '2763 s Allison Way' ,			@city = 'Syracuse',				@state = 'UT', @zip = '84075',		@cellPhoneNumber = '801-256-8055', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'carsonharry@gmail.com',			@firstName = 'Carson',	@lastName = 'Harry'	,			@streetAddress = '1620 Orchard Dr Unit A' ,		@city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-669-8701', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'barronhatfield@yahoo.com',			@firstName = 'Barron',	@lastName = 'Hatfield'	,		@streetAddress = '588 N Quincy Ave' ,			@city = 'Ogden',				@state = 'UT', @zip = '84404',		@cellPhoneNumber = '801-690-4750', @homePhoneNumber = '801-675-5118' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'thomashellstrom@wsd.net',			@firstName = 'Thomas',	@lastName = 'Hellstrom'	,		@streetAddress = '2248 N 700 E' ,				@city = 'North Ogden',			@state = 'UT', @zip = '84414',		@cellPhoneNumber = '801-568-7499', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'hill_dennis@outlook.com',			@firstName = 'Dennis',	@lastName = 'Hill'	,			@streetAddress = '1342 West 2700 North' ,		@city = 'Clinton',				@state = 'Ut', @zip = '84015',		@cellPhoneNumber = '801-608-7507', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'larryhill@gmail.com',				@firstName = 'Larry',	@lastName = 'Hill'	,			@streetAddress = '372 Whisperwood Cove' ,		@city = 'Kaysville',			@state = 'UT', @zip = '84037',		@cellPhoneNumber = '801-649-6922', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'connor.hoopes@aggiemail.usu.ed',	@firstName = 'Cannor',	@lastName = 'Hoopes',			@streetAddress = '454 Sharon St.' ,				@city = 'Morgan',				@state = 'UT', @zip = '84050',		@cellPhoneNumber = '801-828-6178', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'garrett.horsley@gmail.com',		@firstName = 'Garrett',	@lastName = 'Horsley',			@streetAddress = '2451 West 700 North' ,		@city = 'Layton',				@state = 'UT', @zip = '84041',		@cellPhoneNumber = '801-608-2581', @homePhoneNumber = '801-544-2233' ,	@workPhoneNumber = '801-222-6728		';
EXECUTE usp_AddUser @emailAddress = 'jeffrey.hoskins@hotmail.com',		@firstName = 'Jeffrey',	@lastName = 'Hoskins',			@streetAddress = '4285 S 2900 W Unit C' ,		@city = 'Roy',					@state = 'UT', @zip = '84067',		@cellPhoneNumber = '801-628-6861', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'heyvern@gmail.com',				@firstName = 'Vern',	@lastName = 'Hunnel',			@streetAddress = '648 S. Douglas Dr.' ,			@city = 'Brigham City',			@state = 'UT', @zip = '84302',		@cellPhoneNumber = '435-730-8764', @homePhoneNumber = '435-723-6760' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'alan.hunsaker@hsc.utah.edu',		@firstName = 'Alan',	@lastName = 'Hunsaker',			@streetAddress = '1589 W Gentile Street' ,		@city = 'Layton',				@state = 'UT', @zip = '84041',		@cellPhoneNumber = '801-603-3402', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'kfh@comcast.net',					@firstName = 'Kevin',	@lastName = 'Hunter',			@streetAddress = '3318 Adams Avenue	' ,			@city = 'Ogden',				@state = 'Ut', @zip = '84401',		@cellPhoneNumber = '801-804-3275', @homePhoneNumber = NULL,				@workPhoneNumber = '801-701-7393';
EXECUTE usp_AddUser @emailAddress = 'caseyjack@gmail.coM',				@firstName = 'Casey',	@lastName = 'Jackson',			@streetAddress = '2758 North 465 West We' ,		@city = 'Bountiful',			@state = 'Ut', @zip = '84087',		@cellPhoneNumber = '801-564-3875', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'bwj9999@hotmail.com',				@firstName = 'Bryce',	@lastName = 'Jeffs'	,			@streetAddress = '1785 E. SHERWOOD DRIVE' ,		@city = 'Kaysville',			@state = 'UT', @zip = '84037',		@cellPhoneNumber = '801-725-9017', @homePhoneNumber = '801-544-5692 ' , @workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'larryjensen@syracuseut.com',		@firstName = 'Larry 1',	@lastName = 'Jensen',			@streetAddress = '945 s 1285 w' ,				@city = 'Syracuse',				@state = 'UT', @zip = '84075',		@cellPhoneNumber = '801-807-3535', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'terryjensen209@hotmail.com',		@firstName = 'Terry',	@lastName = 'Jensen',			@streetAddress = '3475 North 450 East' ,		@city = 'North Ogden',			@state = 'UT', @zip = '84414',		@cellPhoneNumber = '801-375-8774', @homePhoneNumber = '801-782-9870' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'scottjohnson0909@hotmail.com',		@firstName = 'Scott',	@lastName = 'JOHNSON',			@streetAddress = '555 NORTH 3500 WEST' ,		@city = 'Clearfield',			@state = 'UT', @zip = '84015',		@cellPhoneNumber = '801-608-1129', @homePhoneNumber = '801-773-4420' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'mattjones@gpi.com',				@firstName = 'Matthew',	@lastName = 'Jones'	,			@streetAddress = '4012 W 4900 S' ,				@city = 'Roy',					@state = 'UT', @zip = '84067',		@cellPhoneNumber = '801-690-2020', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'ronaldkennedy1@yahoo.com',			@firstName = 'Ronald',	@lastName = 'Kennedy',			@streetAddress = '1203 w 3475 n' ,				@city = 'Clinton',				@state = 'UT', @zip = '84015',		@cellPhoneNumber = '801-804-4338', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'stevenkibler@gmail.com',			@firstName = 'Steven',	@lastName = 'Kibler',			@streetAddress = '507 North 1620 West' ,		@city = 'Clinton',				@state = 'UT', @zip = '84015',		@cellPhoneNumber = '801-407-3667', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'blainkilburn@yahoo.com',			@firstName = 'Blaine',	@lastName = 'Kilburn',			@streetAddress = '1538 S 1050 W	' ,				@city = 'Clearfield',			@state = 'Ut', @zip = '84015',		@cellPhoneNumber = '801-804-4209', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'jonathankilburn@aol.com',			@firstName = 'JONATHAN',@lastName = 'KILBURN',			@streetAddress = '1280 EAST CANYON DR.' ,		@city = 'South Weber',			@state = 'UT', @zip = '84405',		@cellPhoneNumber = '801-920-5980', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'calvinking@gmail.com',				@firstName = 'Calvin',	@lastName = 'King'	,			@streetAddress = '108 Bamberger Way	' ,			@city = 'Centerville',			@state = 'UT', @zip = '84014',		@cellPhoneNumber = '801-409-0863', @homePhoneNumber = NULL,				@workPhoneNumber = '801-305-6989';
EXECUTE usp_AddUser @emailAddress = 'sking@munnsmfg.com',				@firstName = 'Scott	',	@lastName = 'King'	,			@streetAddress = '10235 North 4400 West' ,		@city = 'Garland',				@state = 'UT', @zip = '84312',		@cellPhoneNumber = '435-402-4768', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'trevorking@gmail.com',				@firstName = 'Trevor',	@lastName = 'King'	,			@streetAddress = '1942 S 350 E' ,				@city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-405-1319', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'craig.larsen@usu.edu',				@firstName = 'Craig',	@lastName = 'Larsen',			@streetAddress = '658 South 1000 East' ,		@city = 'Logan',				@state = 'UT', @zip = '84321',		@cellPhoneNumber = '435-760-4268', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'clifflaw99@yahoo.com',				@firstName = 'Cliff',	@lastName = 'Law'	,			@streetAddress = '126 north 500 west' ,			@city = 'Smithfield',			@state = 'UT', @zip = '84335',		@cellPhoneNumber = '435-904-1970', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'coreylayton98@hotmail.com',		@firstName = 'Corey',	@lastName = 'LAYTON',			@streetAddress = '459 N. Country Way' ,			@city = 'Fruit Heights',		@state = 'UT', @zip = '84037',		@cellPhoneNumber = '801-897-8632', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'randy_leetham@keybank.com',		@firstName = 'Randy',	@lastName = 'Leetham',			@streetAddress = 'PO Box 104' ,					@city = 'Hyrum',				@state = 'UT', @zip = '84319',		@cellPhoneNumber = '435-720-9071', @homePhoneNumber = '435-255-5627' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'paulleonard234@yahoo.com',			@firstName = 'Paul',	@lastName = 'Leonard',			@streetAddress = '537 Leonard Lane' ,			@city = 'Farmington',			@state = 'UT', @zip = '84025',		@cellPhoneNumber = '801-209-2366', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'adammarietti@hotmail.com',			@firstName = 'Adam',	@lastName = 'Marietti',			@streetAddress = '2082 w 3495 n' ,				@city = 'Clinton',				@state = 'UT', @zip = '84015',		@cellPhoneNumber = '801-605-6874', @homePhoneNumber = '801-209-3822' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'ddmartin2020@msn.com',				@firstName = 'Dennis',	@lastName = 'Martin',			@streetAddress = '278 W 2330 N' ,				@city = 'Logan',				@state = 'UT', @zip = '84341',		@cellPhoneNumber = '435-707-4359', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'marcusmaxey@gmail.com',			@firstName = 'Marcus',	@lastName = 'Maxey'	,			@streetAddress = '340 Canyon Cove' ,			@city = 'Logan',				@state = 'UT', @zip = '84321',		@cellPhoneNumber = '801-312-9889', @homePhoneNumber = NULL,				@workPhoneNumber = NULL
EXECUTE usp_AddUser @emailAddress = 'msmcd9853@gmail.com',				@firstName = 'Matt',	@lastName = 'McDonald',			@streetAddress = '1290 South 250 West' ,		@city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-407-5542', @homePhoneNumber = '801-298-3020' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'meffmckenney12@yahoo.com',			@firstName = 'Jeff',	@lastName = 'McKenney',			@streetAddress = '2456 South 1850 West' ,		@city = 'Nibley',				@state = 'UT', @zip = '84321',		@cellPhoneNumber = '435-360-7701', @homePhoneNumber = '435-767-4209' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'mark.mills94@gmail.com',			@firstName = 'Mark',	@lastName = 'Mills'	,			@streetAddress = '331 E 1850 S' ,				@city = 'Kaysville',			@state = 'UT', @zip = '84037',		@cellPhoneNumber = '801-694-0304', @homePhoneNumber = NULL,				@workPhoneNumber = NULL
EXECUTE usp_AddUser @emailAddress = 'KyleMitchell1990@gmail.com',		@firstName = 'KYLE',	@lastName = 'MITCHELL',			@streetAddress = '349 EAST 900 NORTH' ,			@city = 'Logan',				@state = 'UT', @zip = '84321',		@cellPhoneNumber = '435-753-5466', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'johnqnelson@dsdmail.net',			@firstName = 'John',	@lastName = 'Nelson',			@streetAddress = '533 s 1500 e' ,				@city = 'Kaysville',			@state = 'UT', @zip = '84037',		@cellPhoneNumber = '801-540-2233', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'boomer3685@yahoo.com',				@firstName = 'Charles',	@lastName = 'Neuteboom'	,		@streetAddress = '787 E 500 N' ,				@city = 'Kaysville',			@state = 'UT', @zip = '84037-2005', @cellPhoneNumber = '801-603-2353', @homePhoneNumber = NULL,				@workPhoneNumber = NULL
EXECUTE usp_AddUser @emailAddress = 'thomascnoker@hotmail.com',			@firstName = 'THOMAS',	@lastName = 'NOKER'	,			@streetAddress = '985 Miller Way' ,				@city = 'Farmington	',			@state = 'UT', @zip = '84025',		@cellPhoneNumber = '801-509-3230', @homePhoneNumber = NULL,				@workPhoneNumber = '801-509-2861';	
EXECUTE usp_AddUser @emailAddress = 'kevin.norman@aggiemail.usu.edu',	@firstName = 'Kevin',	@lastName = 'Norman',			@streetAddress = '4578 W 4950 S	' ,				@city = 'West Haven',			@state = 'UT', @zip = '84401',		@cellPhoneNumber = '801-690-0214', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'kirk.osborne.ko@gmail.com',		@firstName = 'kirk',	@lastName = 'osborne',			@streetAddress = '781 w 200 n' ,				@city = 'clearfield',			@state = 'Ut', @zip = '84015',		@cellPhoneNumber = '801-508-0676', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'ottleybradley@msn.com',			@firstName = 'Bradley',	@lastName = 'Ottley',			@streetAddress = '301 E 730 N' ,				@city = 'Smithfield',			@state = 'UT', @zip = '84335',		@cellPhoneNumber = '435-801-7449', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'jeremywoverton1@gmail.com',		@firstName = 'Jeremy',	@lastName = 'Overton',			@streetAddress = '5278S 2375W' ,				@city = 'Roy',					@state = 'UT', @zip = '84067',		@cellPhoneNumber = '801-648-3448', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'pagejerod1976@gmail.com',			@firstName = 'Jerod',	@lastName = 'Page'	,			@streetAddress = '1437 BLACK LN' ,				@city = 'FARMINGTON',			@state = 'UT', @zip = '84025',		@cellPhoneNumber = '801-974-3488', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'johnmpage@gmail.com',				@firstName = 'John',	@lastName = 'Page'	,			@streetAddress = '1437 Black Ln.' ,				@city = 'Farmington',			@state = 'Ut', @zip = '84025',		@cellPhoneNumber = '801-956-0278', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'refwalter@yahoo.com',				@firstName = 'Walter',	@lastName = 'Pead'	,			@streetAddress = '678 South 300 East' ,			@city = 'Layton',				@state = 'UT', @zip = '84041',		@cellPhoneNumber = '801-608-9655', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'sampeisley@comcast.net',			@firstName = 'SAMUEL',	@lastName = 'PEISLEY',			@streetAddress = '1544 SOUTH MAIN ST' ,			@city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-451-5913', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'lesterpetersen1@gmail.com',		@firstName = 'Lester',	@lastName = 'Petersen',			@streetAddress = '539 West 1300 South' ,		@city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-405-8518', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'peterson98657@comcast.net',		@firstName = 'Dennis',	@lastName = 'Peterson',			@streetAddress = '1533 East Canyon Drive' ,		@city = 'South Weber',			@state = 'UT', @zip = '84405',		@cellPhoneNumber = '801-418-2217', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'joshuapeterson@live.com',			@firstName = 'Joshua',	@lastName = 'Peterson',			@streetAddress = '997 North 4200 West' ,		@city = 'West Point',			@state = 'UT', @zip = '84015',		@cellPhoneNumber = '435-550-3184', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'pilewicz6@hotmail.com',			@firstName = 'Marvin',	@lastName = 'Pilewicz',			@streetAddress = '2406 W. 3275 So' ,			@city = 'West Haven',			@state = 'UT', @zip = '84401',		@cellPhoneNumber = '801-452-2329', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'normanplaizier@gmail.com',			@firstName = 'Norman',	@lastName = 'Plaizier',			@streetAddress = '110 w 1800 s' ,				@city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-540-4331', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'bradpoll@wsd.net',					@firstName = 'Brad',	@lastName = 'Poll'	,			@streetAddress = '1275 S. 2200 W.' ,			@city = 'Syracuse',				@state = 'UT', @zip = '84075',		@cellPhoneNumber = '801-709-4790', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'thadporter@yahoo.com',				@firstName = 'Thad',	@lastName = 'Porter',			@streetAddress = '446 E 1375 N' ,				@city = 'North Ogden',			@state = 'Ut', @zip = '84414',		@cellPhoneNumber = '801-604-4138', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'jonathanquist@aerotechmfg.com',	@firstName = 'Jonathan',@lastName = 'Quist'	,			@streetAddress = '797 West 1325 South' ,		@city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-533-4988', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'tylerrasmussen@msn.com',			@firstName = 'Tyler',	@lastName = 'Rasmussen'	,		@streetAddress = '1902 w 4750 s	' ,				@city = 'Riverdale',			@state = 'UT', @zip = '84405',		@cellPhoneNumber = '801-526-0347', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'reidcarlos23@gmail.com',			@firstName = 'Carlos',	@lastName = 'Reid'	,			@streetAddress = '2709 NORTH 1330 WEST' ,		@city = 'Clinton',				@state = 'UT', @zip = '84015',		@cellPhoneNumber = '801-398-6255', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'myaddress@comcast.net',			@firstName = 'Mitch',	@lastName = 'Reimer',			@streetAddress = '4194 S 2175 W	' ,				@city = 'Roy',					@state = 'UT', @zip = '84067',		@cellPhoneNumber = '801-393-9801', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'richjeff@gmail.com',				@firstName = 'Jeff',	@lastName = 'Rich',				@streetAddress = '66 north Tierra Vista cou' ,	@city = 'Bountiful',			@state = 'Ut', @zip = '84010',		@cellPhoneNumber = '801-503-5625', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'chad.richins@gmail.com',			@firstName = 'Chad',	@lastName = 'Richins',			@streetAddress = '1089 South 450 East' ,		@city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-488-5554', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'scott.riley88@gmail.com',			@firstName = 'Scott',	@lastName = 'Riley'	,			@streetAddress = '2727 West 200 South' ,		@city = 'Syracuse',				@state = 'Ut', @zip = '84075',		@cellPhoneNumber = '801-638-4526', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'Robinson.David@gmail.com',			@firstName = 'David',	@lastName = 'Robinson'	,		@streetAddress = '561 W 300 N' ,				@city = 'Brigham',				@state = 'UT', @zip = '84302',		@cellPhoneNumber = '435-720-4001', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'karl.robinson56@yahoo.com',		@firstName = 'Karl',	@lastName = 'Robinson'	,		@streetAddress = '350 West 650 North' ,			@city = 'Logan',				@state = 'Ut', @zip = '84321',		@cellPhoneNumber = '435-724-4884', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'bjross33@netzero.com',				@firstName = 'Bruce',	@lastName = 'Ross',				@streetAddress = '453 South Morgan Valley Dr' , @city = 'Morgan',				@state = 'UT', @zip = '84050',		@cellPhoneNumber = '801-455-2388', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'football98@gmail.com',				@firstName = 'Tyson',	@lastName = 'Rowland'	,		@streetAddress = '782 West 400 South' ,			@city = 'Woods Crossd',			@state = 'UT', @zip = '84087',		@cellPhoneNumber = '801-618-7543', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'danielrudolph@hotmail.com',		@firstName = 'Daniel',	@lastName = 'Rudolph'	,		@streetAddress = '1833 Carston Court' ,			@city = 'Farmington',			@state = 'Ut', @zip = '84025',		@cellPhoneNumber = '801-715-3612', @homePhoneNumber = NULL,				@workPhoneNumber = '801-322-3412';
EXECUTE usp_AddUser @emailAddress = 'sadlerterrance@msn.com',			@firstName = 'Terrance',@lastName = 'Sadler',			@streetAddress = '1724 East Sunset Hollow Dr' , @city = 'Bountiful',			@state = 'UT', @zip = '84010',		@cellPhoneNumber = '801-788-3425', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'markschofield34@gmail.com',		@firstName = 'Mark',	@lastName = 'Schofield'	,		@streetAddress = '1295 South 2600 West' ,		@city = 'Syracuse',				@state = 'UT', @zip = '84075',		@cellPhoneNumber = '801-802-2959', @homePhoneNumber = '801-774-6888' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'schryversteve@live.com',			@firstName = 'Steve',	@lastName = 'Schryver'	,		@streetAddress = '171 East 450 South' ,			@city = 'Kaysville',			@state = 'Ut', @zip = '84037',		@cellPhoneNumber = '801-706-5664', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'randy.shapiro@gmail.com',			@firstName = 'Randy',	@lastName = 'Shapiro'	,		@streetAddress = '383 S 950 E' ,				@city = 'Kaysville',			@state = 'UT', @zip = '84037',		@cellPhoneNumber = '801-706-3867', @homePhoneNumber = '801-546-6921' ,	@workPhoneNumber = NULL;
EXECUTE usp_AddUser @emailAddress = 'vshurtliff909@gmail.com',			@firstName = 'Vaughn',	@lastName = 'Shurtliff'	,		@streetAddress = '410 North 300 west' ,			@city = 'Centerville',			@state = 'UT', @zip = '84014',		@cellPhoneNumber = '801-414-2912', @homePhoneNumber = NULL,				@workPhoneNumber = NULL;



EXECUTE usp_AddAD @emailAddress = 'jbatchelor@dsdmail.net', @schoolName = 'Layton High School';
EXECUTE usp_AddAD @emailAddress = 'jemery@dsdmail.net',		@schoolName = 'Viewmont High School';
EXECUTE usp_AddAD @emailAddress = 'kiltsj@ogdensd.org',		@schoolName = 'Ben Lomond High School';
EXECUTE usp_AddAD @emailAddress = 'macqueens@ogdensd.org', @schoolName = 'Ogden High School';
EXECUTE usp_AddAD @emailAddress = 'cmelaney@wsd.net',		@schoolName = 'Fremont High School';
EXECUTE usp_AddAD @emailAddress = 'tmikesell@morgansd.org', @schoolName = 'Morgan High School';
EXECUTE usp_AddAD @emailAddress = 'dlmimnaugh@wsd.net',		@schoolName = 'Bonneville High School';
EXECUTE usp_AddAD @emailAddress = 'van.park@besd.net',		@schoolName = 'Bear River High School';
EXECUTE usp_AddAD @emailAddress = 'kim.peterson@besd.net', @schoolName = 'Box Elder High School';

EXECUTE usp_AddCoach @emailAddress = 'mknight@dsdmail.net', @schoolName = 'Syracuse High School', @sport = 'Football';
EXECUTE usp_AddCoach @emailAddress = 'fkotoa@dsdmail.net',	@schoolName = 'Layton High School', @sport = 'Football';
EXECUTE usp_AddCoach @emailAddress = 'adyson@dsdmail.net',	@schoolName = 'Clearfield High School', @sport = 'Football';
EXECUTE usp_AddCoach @emailAddress = 'fkotoa@dsdmail.net',	@schoolName = 'Roy High School', @sport = 'Football';
EXECUTE usp_AddCoach @emailAddress = 'rarnold@wsd.net',		@schoolName = 'Fremont High School', @sport = 'Football';
EXECUTE usp_AddCoach @emailAddress = 'thompsone@ogdensd.org', @schoolName = 'Ogden High School', @sport = 'Football';
EXECUTE usp_AddCoach @emailAddress = 'eglover@wsd.net',		@schoolName = 'Bonneville High School', @sport = 'Volleyball';
EXECUTE usp_AddCoach @emailAddress = 'smithkel@ogdensd.org', @schoolName = 'Ben Lomond High School', @sport = 'Volleyball';
EXECUTE usp_AddCoach @emailAddress = 'kharding@besd.org',	 @schoolName = 'Box Elder High School', @sport = 'Volleyball';
EXECUTE usp_AddCoach @emailAddress = 'abowles@wsd.net',		 @schoolName = 'Fremont High School', @sport = 'Volleyball';
EXECUTE usp_AddCoach @emailAddress = 'cwise@besd.org',			@schoolName = 'Bear River High School', @sport = 'Football';

EXECUTE usp_AddAnswer @emailAddress = 'ack.devin@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'Flor';
EXECUTE usp_AddAnswer @emailAddress = 'refchrisadams@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'Diego';
EXECUTE usp_AddAnswer @emailAddress = 'bga78@msn.com',					@question = 'What is your oldest siblings middle name?', @answer = 'Susie';
EXECUTE usp_AddAnswer @emailAddress = 'grukmuk@msn.com',				@question = 'What is your oldest siblings middle name?', @answer = 'reynalda';
EXECUTE usp_AddAnswer @emailAddress = 'brandon@petro.com',				@question = 'What is your oldest siblings middle name?', @answer = 'shaquita';
EXECUTE usp_AddAnswer @emailAddress = 'tybar14@hotmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'james';
EXECUTE usp_AddAnswer @emailAddress = 'karlbeckstrom@msn.com',			@question = 'What is your oldest siblings middle name?', @answer = 'john';
EXECUTE usp_AddAnswer @emailAddress = 'mikeb@aspen.com',				@question = 'What is your oldest siblings middle name?', @answer = 'robert';
EXECUTE usp_AddAnswer @emailAddress = 'paul.bernier@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'michael';
EXECUTE usp_AddAnswer @emailAddress = 'ldjbon@gmail.com',				@question = 'What is your oldest siblings middle name?', @answer = 'william';
EXECUTE usp_AddAnswer @emailAddress = 'jeffbraun8@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'david';
EXECUTE usp_AddAnswer @emailAddress = 'ronbrenk@q.com',					@question = 'What is your oldest siblings middle name?', @answer = 'richard';
EXECUTE usp_AddAnswer @emailAddress = 'brownfgary@yahoo.com',			@question = 'What is your oldest siblings middle name?', @answer = 'joseph';
EXECUTE usp_AddAnswer @emailAddress = 'davidbueller@yahoo.com',			@question = 'What is your oldest siblings middle name?', @answer = 'thomas';
EXECUTE usp_AddAnswer @emailAddress = 'burnettdan@hotmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'charles';
EXECUTE usp_AddAnswer @emailAddress = 'bryanburningham@hotmail.com',	@question = 'What is your oldest siblings middle name?', @answer = 'chirs';
EXECUTE usp_AddAnswer @emailAddress = 'kamburny@mstar.net',				@question = 'What is your oldest siblings middle name?', @answer = 'christopher';
EXECUTE usp_AddAnswer @emailAddress = 'cartercarl_358@hotmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'daniel';
EXECUTE usp_AddAnswer @emailAddress = 'bobcarre@live.com',				@question = 'What is your oldest siblings middle name?', @answer = 'matt';
EXECUTE usp_AddAnswer @emailAddress = 'dfc99@yahoo.com',				@question = 'What is your oldest siblings middle name?', @answer = 'matthew';
EXECUTE usp_AddAnswer @emailAddress = 'jon34131.jc@gmail.om',			@question = 'What is your oldest siblings middle name?', @answer = 'anthony';
EXECUTE usp_AddAnswer @emailAddress = 'nickcole@gmail.com',				@question = 'What is your oldest siblings middle name?', @answer = 'donald';
EXECUTE usp_AddAnswer @emailAddress = 'wcole@gmail.com',				@question = 'What is your oldest siblings middle name?', @answer = 'mark';
EXECUTE usp_AddAnswer @emailAddress = 'trevorcondie@comcast.net',		@question = 'What is your oldest siblings middle name?', @answer = 'paul';
EXECUTE usp_AddAnswer @emailAddress = 'kconnersUtah@comcast.net',		@question = 'What is your oldest siblings middle name?', @answer = 'steven';
EXECUTE usp_AddAnswer @emailAddress = 'randall.crowell@autoliv.net',	@question = 'What is your oldest siblings middle name?', @answer = 'steve';
EXECUTE usp_AddAnswer @emailAddress = 'kevinc987@yahoo.com'		,		@question = 'What is your oldest siblings middle name?', @answer = 'steff';
EXECUTE usp_AddAnswer @emailAddress = 'kraigculli@hotmail.com'	,		@question = 'What is your oldest siblings middle name?', @answer = 'andrew';
EXECUTE usp_AddAnswer @emailAddress = 'konnorcullimore@live.com'	,	@question = 'What is your oldest siblings middle name?', @answer = 'drew';
EXECUTE usp_AddAnswer @emailAddress = 'cactuscutler89@yahoo.com',		@question = 'What is your oldest siblings middle name?', @answer = 'ken';
EXECUTE usp_AddAnswer @emailAddress = 'braddavies50@hotmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'kenneth';
EXECUTE usp_AddAnswer @emailAddress = 'evandavis@gmail.com'	,			@question = 'What is your oldest siblings middle name?', @answer = 'kenny';
EXECUTE usp_AddAnswer @emailAddress = 'mdavis345@gmail.com'	,			@question = 'What is your oldest siblings middle name?', @answer = 'josh';
EXECUTE usp_AddAnswer @emailAddress = 'tomdeelstra@utah.gov'	,		@question = 'What is your oldest siblings middle name?', @answer = 'joshua';
EXECUTE usp_AddAnswer @emailAddress = 'freddenucci@comcast.net'	,		@question = 'What is your oldest siblings middle name?', @answer = 'joe';
EXECUTE usp_AddAnswer @emailAddress = 'david.dickson@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'joseph';
EXECUTE usp_AddAnswer @emailAddress = 'devindom@msn.com'	,			@question = 'What is your oldest siblings middle name?', @answer = 'kevin';
EXECUTE usp_AddAnswer @emailAddress = 'jeffdowns@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'brian';
EXECUTE usp_AddAnswer @emailAddress = 'brettdyer@live.com	',			@question = 'What is your oldest siblings middle name?', @answer = 'george';
EXECUTE usp_AddAnswer @emailAddress = 'brevindyer29@live.com',			@question = 'What is your oldest siblings middle name?', @answer = 'edward';
EXECUTE usp_AddAnswer @emailAddress = 'kevindyer36@digis.net',			@question = 'What is your oldest siblings middle name?', @answer = 'ron';
EXECUTE usp_AddAnswer @emailAddress = 'portsref20@yahoo.com',			@question = 'What is your oldest siblings middle name?', @answer = 'ronald';
EXECUTE usp_AddAnswer @emailAddress = 'matt_elkins@msn.com',			@question = 'What is your oldest siblings middle name?', @answer = 'tim';
EXECUTE usp_AddAnswer @emailAddress = 'brfootball67@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'timothy';
EXECUTE usp_AddAnswer @emailAddress = 'michaelengledow@comcast.net',	@question = 'What is your oldest siblings middle name?', @answer = 'jase';
EXECUTE usp_AddAnswer @emailAddress = 'thoma.evans49@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'jason';
EXECUTE usp_AddAnswer @emailAddress = 'georgeeverett@hotmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'jeff';
EXECUTE usp_AddAnswer @emailAddress = 'steven.farnsworth@gmail.com',	@question = 'What is your oldest siblings middle name?', @answer = 'jefferey';
EXECUTE usp_AddAnswer @emailAddress = 'marcus.federer@yahoo.com',		@question = 'What is your oldest siblings middle name?', @answer = 'ryan';
EXECUTE usp_AddAnswer @emailAddress = 'mariofurm@comcast.net',			@question = 'What is your oldest siblings middle name?', @answer = 'jay';
EXECUTE usp_AddAnswer @emailAddress = 'galbraith98@comcast.net',		@question = 'What is your oldest siblings middle name?', @answer = 'gary';
EXECUTE usp_AddAnswer @emailAddress = 'gangwerroger@aol.com',			@question = 'What is your oldest siblings middle name?', @answer = 'jake';
EXECUTE usp_AddAnswer @emailAddress = 'cgermany@comcast.net',			@question = 'What is your oldest siblings middle name?', @answer = 'jacob';
EXECUTE usp_AddAnswer @emailAddress = 'graycurtis39@aol.com',			@question = 'What is your oldest siblings middle name?', @answer = 'gary';
EXECUTE usp_AddAnswer @emailAddress = 'tomgriff@gmail.com',				@question = 'What is your oldest siblings middle name?', @answer = 'nick';
EXECUTE usp_AddAnswer @emailAddress = 'shadley@juno.com',				@question = 'What is your oldest siblings middle name?', @answer = 'zach';
EXECUTE usp_AddAnswer @emailAddress = 'keith.hales@yahoo.com',			@question = 'What is your oldest siblings middle name?', @answer = 'zack';
EXECUTE usp_AddAnswer @emailAddress = 'johnhancock@yahoo.com',			@question = 'What is your oldest siblings middle name?', @answer = 'zachary';
EXECUTE usp_AddAnswer @emailAddress = 'markhaney@hotmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'eric';
EXECUTE usp_AddAnswer @emailAddress = 'dannyghansen@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'jon';
EXECUTE usp_AddAnswer @emailAddress = 'anthonyharris@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'jonathan';
EXECUTE usp_AddAnswer @emailAddress = 'carsonharry@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'sephen';
EXECUTE usp_AddAnswer @emailAddress = 'barronhatfield@yahoo.com',		@question = 'What is your oldest siblings middle name?', @answer = 'larry';
EXECUTE usp_AddAnswer @emailAddress = 'thomashellstrom@wsd.net',		@question = 'What is your oldest siblings middle name?', @answer = 'justin';
EXECUTE usp_AddAnswer @emailAddress = 'hill_dennis@outlook.com',		@question = 'What is your oldest siblings middle name?', @answer = 'scott';
EXECUTE usp_AddAnswer @emailAddress = 'larryhill@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'brandon';
EXECUTE usp_AddAnswer @emailAddress = 'connor.hoopes@aggiemail.usu.ed',	@question = 'What is your oldest siblings middle name?', @answer = 'ben';
EXECUTE usp_AddAnswer @emailAddress = 'garrett.horsley@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'benjamin';
EXECUTE usp_AddAnswer @emailAddress = 'jeffrey.hoskins@hotmail.com',	@question = 'What is your oldest siblings middle name?', @answer = 'sam';
EXECUTE usp_AddAnswer @emailAddress = 'heyvern@gmail.com',				@question = 'What is your oldest siblings middle name?', @answer = 'samuel';
EXECUTE usp_AddAnswer @emailAddress = 'alan.hunsaker@hsc.utah.edu',		@question = 'What is your oldest siblings middle name?', @answer = 'frank';
EXECUTE usp_AddAnswer @emailAddress = 'kfh@comcast.net',				@question = 'What is your oldest siblings middle name?', @answer = 'greg';
EXECUTE usp_AddAnswer @emailAddress = 'caseyjack@gmail.coM',			@question = 'What is your oldest siblings middle name?', @answer = 'gregory';
EXECUTE usp_AddAnswer @emailAddress = 'bwj9999@hotmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'raymond';
EXECUTE usp_AddAnswer @emailAddress = 'larryjensen@syracuseut.com',		@question = 'What is your oldest siblings middle name?', @answer = 'ray';
EXECUTE usp_AddAnswer @emailAddress = 'terryjensen209@hotmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'alex';
EXECUTE usp_AddAnswer @emailAddress = 'scottjohnson0909@hotmail.com',	@question = 'What is your oldest siblings middle name?', @answer = 'alexander';
EXECUTE usp_AddAnswer @emailAddress = 'mattjones@gpi.com',				@question = 'What is your oldest siblings middle name?', @answer = 'pat';
EXECUTE usp_AddAnswer @emailAddress = 'ronaldkennedy1@yahoo.com',		@question = 'What is your oldest siblings middle name?', @answer = 'patrick';
EXECUTE usp_AddAnswer @emailAddress = 'stevenkibler@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'jack';
EXECUTE usp_AddAnswer @emailAddress = 'blainkilburn@yahoo.com',			@question = 'What is your oldest siblings middle name?', @answer = 'jackson';
EXECUTE usp_AddAnswer @emailAddress = 'jonathankilburn@aol.com',		@question = 'What is your oldest siblings middle name?', @answer = 'dennis';
EXECUTE usp_AddAnswer @emailAddress = 'calvinking@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'jerry';
EXECUTE usp_AddAnswer @emailAddress = 'sking@munnsmfg.com',				@question = 'What is your oldest siblings middle name?', @answer = 'tyler';
EXECUTE usp_AddAnswer @emailAddress = 'trevorking@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'aaron';
EXECUTE usp_AddAnswer @emailAddress = 'craig.larsen@usu.edu',			@question = 'What is your oldest siblings middle name?', @answer = 'erin';
EXECUTE usp_AddAnswer @emailAddress = 'clifflaw99@yahoo.com',			@question = 'What is your oldest siblings middle name?', @answer = 'jose';
EXECUTE usp_AddAnswer @emailAddress = 'coreylayton98@hotmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'henry';
EXECUTE usp_AddAnswer @emailAddress = 'randy_leetham@keybank.com',		@question = 'What is your oldest siblings middle name?', @answer = 'faun';
EXECUTE usp_AddAnswer @emailAddress = 'paulleonard234@yahoo.com',		@question = 'What is your oldest siblings middle name?', @answer = 'adam';
EXECUTE usp_AddAnswer @emailAddress = 'adammarietti@hotmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'douglas';
EXECUTE usp_AddAnswer @emailAddress = 'ddmartin2020@msn.com',			@question = 'What is your oldest siblings middle name?', @answer = 'nate';
EXECUTE usp_AddAnswer @emailAddress = 'marcusmaxey@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'nathan';
EXECUTE usp_AddAnswer @emailAddress = 'msmcd9853@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'peter';
EXECUTE usp_AddAnswer @emailAddress = 'meffmckenney12@yahoo.com',		@question = 'What is your oldest siblings middle name?', @answer = 'kyle';
EXECUTE usp_AddAnswer @emailAddress = 'mark.mills94@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'walter';
EXECUTE usp_AddAnswer @emailAddress = 'KyleMitchell1990@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'harold';
EXECUTE usp_AddAnswer @emailAddress = 'johnqnelson@dsdmail.net',		@question = 'What is your oldest siblings middle name?', @answer = 'jeremy';
EXECUTE usp_AddAnswer @emailAddress = 'boomer3685@yahoo.com',			@question = 'What is your oldest siblings middle name?', @answer = 'ethan';
EXECUTE usp_AddAnswer @emailAddress = 'thomascnoker@hotmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'carl';
EXECUTE usp_AddAnswer @emailAddress = 'kevin.norman@aggiemail.usu.edu',	@question = 'What is your oldest siblings middle name?', @answer = 'keith';
EXECUTE usp_AddAnswer @emailAddress = 'kirk.osborne.ko@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'roger';
EXECUTE usp_AddAnswer @emailAddress = 'ottleybradley@msn.com',			@question = 'What is your oldest siblings middle name?', @answer = 'gerald';
EXECUTE usp_AddAnswer @emailAddress = 'jeremywoverton1@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'christian';
EXECUTE usp_AddAnswer @emailAddress = 'pagejerod1976@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'terry';
EXECUTE usp_AddAnswer @emailAddress = 'johnmpage@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'sean';
EXECUTE usp_AddAnswer @emailAddress = 'refwalter@yahoo.com',			@question = 'What is your oldest siblings middle name?', @answer = 'arthur';
EXECUTE usp_AddAnswer @emailAddress = 'sampeisley@comcast.net',			@question = 'What is your oldest siblings middle name?', @answer = 'austin';
EXECUTE usp_AddAnswer @emailAddress = 'lesterpetersen1@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'noah';
EXECUTE usp_AddAnswer @emailAddress = 'peterson98657@comcast.net',		@question = 'What is your oldest siblings middle name?', @answer = 'lawrence';
EXECUTE usp_AddAnswer @emailAddress = 'joshuapeterson@live.com',		@question = 'What is your oldest siblings middle name?', @answer = 'jesse';
EXECUTE usp_AddAnswer @emailAddress = 'pilewicz6@hotmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'joe';
EXECUTE usp_AddAnswer @emailAddress = 'normanplaizier@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'bryan';
EXECUTE usp_AddAnswer @emailAddress = 'bradpoll@wsd.net',				@question = 'What is your oldest siblings middle name?', @answer = 'billy';
EXECUTE usp_AddAnswer @emailAddress = 'thadporter@yahoo.com',			@question = 'What is your oldest siblings middle name?', @answer = 'jordan';
EXECUTE usp_AddAnswer @emailAddress = 'jonathanquist@aerotechmfg.com',	@question = 'What is your oldest siblings middle name?', @answer = 'albert';
EXECUTE usp_AddAnswer @emailAddress = 'tylerrasmussen@msn.com',			@question = 'What is your oldest siblings middle name?', @answer = 'dylan';
EXECUTE usp_AddAnswer @emailAddress = 'reidcarlos23@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'bruce';
EXECUTE usp_AddAnswer @emailAddress = 'myaddress@comcast.net',			@question = 'What is your oldest siblings middle name?', @answer = 'willie';
EXECUTE usp_AddAnswer @emailAddress = 'richjeff@gmail.com',				@question = 'What is your oldest siblings middle name?', @answer = 'gabe';
EXECUTE usp_AddAnswer @emailAddress = 'chad.richins@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'gabriel';
EXECUTE usp_AddAnswer @emailAddress = 'scott.riley88@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'alan';
EXECUTE usp_AddAnswer @emailAddress = 'Robinson.David@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'allan';
EXECUTE usp_AddAnswer @emailAddress = 'karl.robinson56@yahoo.com',		@question = 'What is your oldest siblings middle name?', @answer = 'juan';
EXECUTE usp_AddAnswer @emailAddress = 'bjross33@netzero.com',			@question = 'What is your oldest siblings middle name?', @answer = 'logan';
EXECUTE usp_AddAnswer @emailAddress = 'football98@gmail.com',			@question = 'What is your oldest siblings middle name?', @answer = 'wayne';
EXECUTE usp_AddAnswer @emailAddress = 'danielrudolph@hotmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'ralph';
EXECUTE usp_AddAnswer @emailAddress = 'sadlerterrance@msn.com',			@question = 'What is your oldest siblings middle name?', @answer = 'roy';
EXECUTE usp_AddAnswer @emailAddress = 'markschofield34@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'randy';
EXECUTE usp_AddAnswer @emailAddress = 'schryversteve@live.com',			@question = 'What is your oldest siblings middle name?', @answer = 'vincent';
EXECUTE usp_AddAnswer @emailAddress = 'randy.shapiro@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'louis';
EXECUTE usp_AddAnswer @emailAddress = 'vshurtliff909@gmail.com',		@question = 'What is your oldest siblings middle name?', @answer = 'russel';
EXECUTE usp_AddAnswer @emailAddress = 'jbatchelor@dsdmail.net', 		@question = 'What is your oldest siblings middle name?', @answer = 'phil';
EXECUTE usp_AddAnswer @emailAddress = 'jemery@dsdmail.net',				@question = 'What is your oldest siblings middle name?', @answer = 'phillip';
EXECUTE usp_AddAnswer @emailAddress = 'kiltsj@ogdensd.org',				@question = 'What is your oldest siblings middle name?', @answer = 'bobby';
EXECUTE usp_AddAnswer @emailAddress = 'macqueens@ogdensd.org',  		@question = 'What is your oldest siblings middle name?', @answer = 'jenae';
EXECUTE usp_AddAnswer @emailAddress = 'cmelaney@wsd.net',				@question = 'What is your oldest siblings middle name?', @answer = 'diana';
EXECUTE usp_AddAnswer @emailAddress = 'tmikesell@morgansd.org', 		@question = 'What is your oldest siblings middle name?', @answer = 'brittany';
EXECUTE usp_AddAnswer @emailAddress = 'dlmimnaugh@wsd.net',				@question = 'What is your oldest siblings middle name?', @answer = 'natalie';
EXECUTE usp_AddAnswer @emailAddress = 'van.park@besd.net',				@question = 'What is your oldest siblings middle name?', @answer = 'rose';
EXECUTE usp_AddAnswer @emailAddress = 'kim.peterson@besd.net',  		@question = 'What is your oldest siblings middle name?', @answer = 'sophia';
EXECUTE usp_AddAnswer @emailAddress = 'mknight@dsdmail.net', 			@question = 'What is your oldest siblings middle name?', @answer = 'isabella';
EXECUTE usp_AddAnswer @emailAddress = 'fkotoa@dsdmail.net',				@question = 'What is your oldest siblings middle name?', @answer = 'alexis';
EXECUTE usp_AddAnswer @emailAddress = 'adyson@dsdmail.net',				@question = 'What is your oldest siblings middle name?', @answer = 'kayla';
EXECUTE usp_AddAnswer @emailAddress = 'fkotoa@dsdmail.net',				@question = 'What is your oldest siblings middle name?', @answer = 'charlotte';
EXECUTE usp_AddAnswer @emailAddress = 'rarnold@wsd.net',				@question = 'What is your oldest siblings middle name?', @answer = 'bradley';
EXECUTE usp_AddAnswer @emailAddress = 'thompsone@ogdensd.org',			@question = 'What is your oldest siblings middle name?', @answer = 'johnny';
EXECUTE usp_AddAnswer @emailAddress = 'eglover@wsd.net',				@question = 'What is your oldest siblings middle name?', @answer = 'isabella';
EXECUTE usp_AddAnswer @emailAddress = 'smithkel@ogdensd.org',			@question = 'What is your oldest siblings middle name?', @answer = 'charlotte';
EXECUTE usp_AddAnswer @emailAddress = 'kharding@besd.org',				@question = 'What is your oldest siblings middle name?', @answer = 'rylee';
EXECUTE usp_AddAnswer @emailAddress = 'abowles@wsd.net',				@question = 'What is your oldest siblings middle name?', @answer = 'amber';
EXECUTE usp_AddAnswer  @emailAddress = 'cwise@besd.org',					@question = 'What is your oldest siblings middle name?', @answer = 'brad';


-----Football Games
EXECUTE usp_AddGame @gameDateTime = '2020-09-04 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-04 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Fremont High School', @homeTeam = 'Fremont High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-04 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Roy High School',		@homeTeam = 'Roy High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-04 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Syracuse High School',		@homeTeam = 'Syracuse High School', @visitingTeam = 'Weber High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-04 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'BoxElder High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-04 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Mountain Crest High School', @homeTeam = 'Mountain Crest High School', @visitingTeam = 'Bonneville High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-04 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Green Canyon High School', @homeTeam = 'Green Canyon High School', @visitingTeam = 'Morgan High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-04 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Ridgeline High School', @homeTeam = 'Ridgeline High School', @visitingTeam = 'Woods Cross High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-04 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Bonneville High School', @homeTeam = 'Bonneville High School', @visitingTeam = 'Mountain Crest High School';

EXECUTE usp_AddGame @gameDateTime = '2020-09-11 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Viewmont High School', @homeTeam = 'Viewmont High School', @visitingTeam = 'Bonneville High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-11 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Farminton High School', @homeTeam = 'Farmington High School', @visitingTeam = 'Box Elder High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-11 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-11 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-11 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Syracuse School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Roy High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-11 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-11 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Ridgeline High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-11 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Green Canyon High School', @homeTeam = 'Green Canyon High School', @visitingTeam = 'Sky View High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-11 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Bountiful High School', @homeTeam = 'Bountiful High School', @visitingTeam = 'Woods Cross High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-11 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Logan High School', @homeTeam = 'Logan High School', @visitingTeam = 'Mountain Crest High School';

EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Clearfield High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Fremont High School', @homeTeam = 'Fremont High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Weber High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Roy High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Bonneville High School', @homeTeam = 'Bonneville High School', @visitingTeam = 'Bountiful High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Box Elder High School', @homeTeam = 'Box Elder High School', @visitingTeam = 'Viewmont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Farmington High School', @homeTeam = 'Farmington High School', @visitingTeam = 'Woods Cross High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Mountain Crest High School', @homeTeam = 'Mountain Crest High School', @visitingTeam = 'Green Canyon High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Logan High School', @homeTeam = 'Logan High School', @visitingTeam = 'Bear River High School';

EXECUTE usp_AddGame @gameDateTime = '2020-09-25 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Bonneville High School', @homeTeam = 'Bonneville High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Bountiful High School', @homeTeam = 'Bountiful High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Ridgeline High School', @homeTeam = 'Ridgeline High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Skyview Crest High School', @homeTeam = 'Skyview High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-18 19:00', @sport = 'Football', @level = 'Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Davis High School';

---------Volleyball games
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Sky View High School', @homeTeam = 'Sky View High School', @visitingTeam = 'Box Elder High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Davis High School';

EXECUTE usp_AddGame @gameDateTime = '2020-09-01 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Sky View High School', @homeTeam = 'Sky View High School', @visitingTeam = 'Box Elder High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Davis High School';

EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Sky View High School', @homeTeam = 'Sky View High School', @visitingTeam = 'Box Elder High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Davis High School';
-------
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Green Canyon High School', @homeTeam = 'Green Canyon High School', @visitingTeam = 'Farmington High School';
											 
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Green Canyon High School', @homeTeam = 'Green Canyon High School', @visitingTeam = 'Farmington High School';
											 
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Green Canyon High School', @homeTeam = 'Green Canyon High School', @visitingTeam = 'Farmington High School';
--
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Box Elder High School';
											 
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Box Elder High School';
											 
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-10 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Box Elder High School';
------
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Mountain Crest High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Logan High School', @homeTeam = 'Logan High School', @visitingTeam = 'Sky View High School';
											 
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Mountain Crest High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Logan High School', @homeTeam = 'Logan High School', @visitingTeam = 'Sky View High School';
											 
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Mountain Crest High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-15 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Logan High School', @homeTeam = 'Logan High School', @visitingTeam = 'Sky View High School';
------------
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Bonneville High School', @homeTeam = 'Bonneville High School', @visitingTeam = 'Farmington High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Ridgeline High School', @homeTeam = 'Ridgeline High School', @visitingTeam = 'Bear River High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Mountain Crest High School', @homeTeam = 'Mountain Crest High School', @visitingTeam = 'Sky View High School';
										 	 
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Bonneville High School', @homeTeam = 'Bonneville High School', @visitingTeam = 'Farmington High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 16:45', @sport = 'Volleyball', @level = 'Varsity',		  @siteName = 'Ridgeline High School', @homeTeam = 'Ridgeline High School', @visitingTeam = 'Bear River High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 16:45', @sport = 'Volleyball', @level = 'Varsity',		  @siteName = 'Mountain Crest High School', @homeTeam = 'Mountain Crest High School', @visitingTeam = 'Sky View High School';
											 
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Bonneville High School', @homeTeam = 'Bonneville High School', @visitingTeam = 'Farmington High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 15:30', @sport = 'Volleyball', @level = 'Varsity',  @siteName = 'Ridgeline High School', @homeTeam = 'Ridgeline High School', @visitingTeam = 'Bear River High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-17 15:30', @sport = 'Volleyball', @level = 'Varsity',  @siteName = 'Mountain Crest High School', @homeTeam = 'Mountain Crest High School', @visitingTeam = 'Sky View High School';

------------
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Weber High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Roy High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Green Canyon River High School', @homeTeam = 'Green Canyon High School', @visitingTeam = 'Mountain Crest High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Sky View High School';
											 
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Weber High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Roy High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Green Canyon River High School', @homeTeam = 'Green Canyon High School', @visitingTeam = 'Mountain Crest High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Sky View High School';
											 
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Weber High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Fremont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Roy High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Green Canyon River High School', @homeTeam = 'Green Canyon High School', @visitingTeam = 'Mountain Crest High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-22 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Sky View High School';
------------
------------
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Box Elder High School', @homeTeam = 'Box Elder High School', @visitingTeam = 'Woods Cross High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Mountain Crest River High School', @homeTeam = 'Mountain Crest High School', @visitingTeam = 'Logan High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 18:00', @sport = 'Volleyball', @level = 'Varsity', @siteName = 'Sky View High School', @homeTeam = 'Sky View High School', @visitingTeam = 'Ridgeline High School';
											 
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Box Elder High School', @homeTeam = 'Box Elder High School', @visitingTeam = 'Woods Cross High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Mountain Crest River High School', @homeTeam = 'Mountain Crest High School', @visitingTeam = 'Logan High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 16:45', @sport = 'Volleyball', @level = 'Junior Varsity', @siteName = 'Sky View High School', @homeTeam = 'Sky View High School', @visitingTeam = 'Ridgeline High School';
											  
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Davis High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Box Elder High School', @homeTeam = 'Box Elder High School', @visitingTeam = 'Woods Cross High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Mountain Crest River High School', @homeTeam = 'Mountain Crest High School', @visitingTeam = 'Logan High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-24 15:30', @sport = 'Volleyball', @level = 'Sophmore', @siteName = 'Sky View High School', @homeTeam = 'Sky View High School', @visitingTeam = 'Ridgeline High School';
------------
EXECUTE usp_AddGame @gameDateTime = '2020-09-25 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-25 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Davis High School', @homeTeam = 'Davis High School', @visitingTeam = 'Roy High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-25 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Farmington High School', @homeTeam = 'Farmington High School', @visitingTeam = 'Viewmont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-25 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Fremont High School', @homeTeam = 'Fremont High School', @visitingTeam = 'Weber High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-25 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Woods Cross High School', @homeTeam = 'Wood Cross High School', @visitingTeam = 'Bonneville High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-25 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-25 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Boutniful High School', @homeTeam = 'Bountiful High School', @visitingTeam = 'Box Elder High School';
------------
EXECUTE usp_AddGame @gameDateTime = '2020-09-27 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Box Elder High School', @homeTeam = 'Box Elder High School', @visitingTeam = 'Woods Cross High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-27 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Fremont High School', @homeTeam = 'Fremont High School', @visitingTeam = 'Clearfield High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-27 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Weber High School', @homeTeam = 'Weber High School', @visitingTeam = 'Northridge High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-27 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Syracuse High School', @homeTeam = 'Syracuse High School', @visitingTeam = 'Roy High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-27 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Bountiful High School', @homeTeam = 'Bountiful High School', @visitingTeam = 'Viewmont High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-27 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Bonneville High School', @homeTeam = 'Bonneville High School', @visitingTeam = 'Farmington High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-27 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Layton High School', @homeTeam = 'Layton High School', @visitingTeam = 'Davis High School';
------------
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Viewmont High School', @homeTeam = 'Viewmont High School', @visitingTeam = 'Box Elder High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Clearfield High School', @homeTeam = 'Clearfield High School', @visitingTeam = 'Layton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Woods Cross High School', @homeTeam = 'Woods Cross High School', @visitingTeam = 'Farminton High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Roy High School', @homeTeam = 'Roy High School', @visitingTeam = 'Weber High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Northridge High School', @homeTeam = 'Northridge High School', @visitingTeam = 'Bonneville High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Bear River High School', @homeTeam = 'Bear River High School', @visitingTeam = 'Syracuse High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Sky View High School', @homeTeam = 'Sky View High School', @visitingTeam = 'Green Canyon High School';
EXECUTE usp_AddGame @gameDateTime = '2020-09-01 15:00', @sport = 'Soccer-Women', @level = 'Varsity', @siteName = 'Mountain Crest High School', @homeTeam = 'Mountain Crest High School', @visitingTeam = 'Moutnain Crest High School';

-------------------------------
EXECUTE usp_AddOfficial @emailAddress = 'ack.devin@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'refchrisadams@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'bga78@msn.com',					@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'grukmuk@msn.com',					@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'brandon@petro.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'tybar14@hotmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'karlbeckstrom@msn.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'mikeb@aspen.com',					@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'paul.bernier@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'ldjbon@gmail.com',					@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'jeffbraun8@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'ronbrenk@q.com',					@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'brownfgary@yahoo.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'davidbueller@yahoo.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'burnettdan@hotmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'bryanburningham@hotmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'kamburny@mstar.net',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'cartercarl_358@hotmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'bobcarre@live.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'dfc99@yahoo.com',					@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'jon34131.jc@gmail.om',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'nickcole@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'wcole@gmail.com',					@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'trevorcondie@comcast.net',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'kconnersUtah@comcast.net',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'randall.crowell@autoliv.net',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'kevinc987@yahoo.com'		,		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'kraigculli@hotmail.com'	,		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'konnorcullimore@live.com'	,		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'cactuscutler89@yahoo.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'braddavies50@hotmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'evandavis@gmail.com'	,			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'mdavis345@gmail.com'	,			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'tomdeelstra@utah.gov'	,			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'freddenucci@comcast.net'	,		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'david.dickson@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'devindom@msn.com'	,				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'jeffdowns@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'brettdyer@live.com	',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'brevindyer29@live.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'kevindyer36@digis.net',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'portsref20@yahoo.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'matt_elkins@msn.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'brfootball67@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'michaelengledow@comcast.net',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'thoma.evans49@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'georgeeverett@hotmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'steven.farnsworth@gmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'marcus.federer@yahoo.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'mariofurm@comcast.net',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'galbraith98@comcast.net',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'gangwerroger@aol.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'cgermany@comcast.net',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'graycurtis39@aol.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'tomgriff@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'shadley@juno.com',					@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'keith.hales@yahoo.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'johnhancock@yahoo.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'markhaney@hotmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'dannyghansen@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'anthonyharris@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'carsonharry@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'barronhatfield@yahoo.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'thomashellstrom@wsd.net',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'hill_dennis@outlook.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'larryhill@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'connor.hoopes@aggiemail.usu.ed',	@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'garrett.horsley@gmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'jeffrey.hoskins@hotmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'heyvern@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'alan.hunsaker@hsc.utah.edu',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'kfh@comcast.net',					@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'caseyjack@gmail.coM',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'bwj9999@hotmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'larryjensen@syracuseut.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'terryjensen209@hotmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'scottjohnson0909@hotmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'mattjones@gpi.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'ronaldkennedy1@yahoo.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'stevenkibler@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'blainkilburn@yahoo.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'jonathankilburn@aol.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'calvinking@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'sking@munnsmfg.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'trevorking@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'craig.larsen@usu.edu',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'clifflaw99@yahoo.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'coreylayton98@hotmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'randy_leetham@keybank.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'paulleonard234@yahoo.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'adammarietti@hotmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'ddmartin2020@msn.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'marcusmaxey@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'msmcd9853@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'meffmckenney12@yahoo.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'mark.mills94@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'KyleMitchell1990@gmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'johnqnelson@dsdmail.net',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'boomer3685@yahoo.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'thomascnoker@hotmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'kevin.norman@aggiemail.usu.edu',	@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'kirk.osborne.ko@gmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'ottleybradley@msn.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'jeremywoverton1@gmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'pagejerod1976@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'johnmpage@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'refwalter@yahoo.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'sampeisley@comcast.net',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'lesterpetersen1@gmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'peterson98657@comcast.net',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'joshuapeterson@live.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'pilewicz6@hotmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'normanplaizier@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'bradpoll@wsd.net',					@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'thadporter@yahoo.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'jonathanquist@aerotechmfg.com',	@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'tylerrasmussen@msn.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'reidcarlos23@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'myaddress@comcast.net',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'richjeff@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'chad.richins@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'scott.riley88@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'Robinson.David@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'karl.robinson56@yahoo.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'bjross33@netzero.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'football98@gmail.com',				@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'danielrudolph@hotmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'sadlerterrance@msn.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'markschofield34@gmail.com',		@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'schryversteve@live.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'randy.shapiro@gmail.com',			@feesAccumulated = NULL;
EXECUTE usp_AddOfficial @emailAddress = 'vshurtliff909@gmail.com',			@feesAccumulated = NULL;



EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Fremont High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com', @siteName = 'Fremont High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Fremont High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Fremont High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com', @siteName = 'Fremont High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'jeffbraun8@gmail.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ronbrenk@q.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brownfgary@yahoo.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'davidbueller@yahoo.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'burnettdan@hotmail.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'bryanburningham@hotmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = ' kamburny@mstar.net', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'cartercarl_358@hotmail.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bobcarre@live.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'dfc99@yahoo.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'jon34131.jc@gmail.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'nickcole@gmail.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'wcole@gmail.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'trevorcondie@comcast.net', @siteName = 'Bear River High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'kconnersUtah@comcast.net', @siteName = 'Bear River High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'randall.crowell@autoliv.net',	   @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'kevinc987@yahoo.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'kraigculli@hotmail.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'konnorcullimore@live.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'cactuscutler89@yahoo.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'braddavies50@hotmail.com',	   @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'evandavis@gmail.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mdavis345@gmail.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tomdeelstra@utah.gov', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'freddenucci@comcast.net', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'david.dickson@gmail.com',	   @siteName = 'Ridgeline High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'devindom@msn.com', @siteName = 'Ridgeline High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'jeffdowns@gmail.com', @siteName = 'Ridgeline High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brettdyer@live.com', @siteName = 'Ridgeline High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brevindyer29@live.com', @siteName = 'Ridgeline High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'sportsref20@yahoo.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'matt_elkins@msn.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brfootball67@gmail.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'michaelengledow@comcast.net', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'thoma.evans49@gmail.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-04 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'georgeeverett@hotmail.com',	   @siteName = 'Viewmont High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'steven.farnsworth@gmail.com', @siteName = 'Viewmont High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'marcus.federer@yahoo.com', @siteName = 'Viewmont High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mariofurm@comcast.net', @siteName = 'Viewmont High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'galbraith98@comcast.net', @siteName = 'Viewmont High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'gangwerroger@aol.com',	   @siteName = 'Farmington High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'cgermany@comcast.net', @siteName = 'Farmington High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'graycurtis39@aol.com', @siteName = 'Farmington High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tomgriff@gmail.com', @siteName = 'Farmington High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'shadley@juno.com', @siteName = 'Farmington High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'keith.hales@yahoo.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'johnhancock@yahoo.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'markhaney@hotmail.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'dannyghansen@gmail.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'anthonyharris@gmail.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'carsonharry@gmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'barronhatfield@yahoo.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'thomashellstrom@wsd.net', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'hill_dennis@outlook.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'larryhill@gmail.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'connor.hoopes@aggiemail.usu.edu',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'garrett.horsley@gmail.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'jeffrey.hoskins@hotmail.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'heyvern@gmail.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'alan.hunsaker@hsc.utah.edu', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'kfh@comcast.net',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'caseyjack@gmail.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bwj9999@hotmail.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'larryjensen@syracuseut.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'terryjensen209@hotmail.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'scottjohnson0909@hotmail.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mattjones@gpi.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ronaldkennedy1@yahoo.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'stevenkibler@gmail.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'blainkilburn@yahoo.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'jonathankilburn@aol.com',	   @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'calvinking@gmail.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'sking@munnsmfg.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'trevorking@gmail.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'craig.larsen@usu.edu', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'clifflaw99@yahoo.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'coreylayton98@hotmail.com', @siteName = 'Bountiful High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'randy_leetham@keybank.com', @siteName = 'Bountiful High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paulleonard234@yahoo.com', @siteName = 'Bountiful High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'adammarietti@hotmail.com', @siteName = 'Bountiful High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'ddmartin2020@msn.com',	   @siteName = 'Logan High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'marcusmaxey@gmail.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'msmcd9853@gmail.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'meffmckenney12@yahoo.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mark.mills94@gmail.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-11 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';





EXECUTE usp_AddGameOfficial @emailAddress = 'ddmartin2020@msn.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'marcusmaxey@gmail.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'msmcd9853@gmail.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'meffmckenney12@yahoo.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mark.mills94@gmail.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'KyleMitchell1990@gmail.com',	   @siteName = 'Fremont High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'johnqnelson@dsdmail.net', @siteName = 'Fremont High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'boomer3685@yahoo.com', @siteName = 'Fremont High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'thomascnoker@hotmail.com', @siteName = 'Fremont High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'kevin.norman@aggiemail.usu.edu', @siteName = 'Fremont High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'kirk.osborne.ko@gmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ottleybradley@msn.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'jeremywoverton1@gmail.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'pagejerod1976@gmail.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'johnmpage@gmail.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'refwalter@yahoo.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'sampeisley@comcast.net', @siteName = 'Davis High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'lesterpetersen1@gmail.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'peterson98657@comcast.net', @siteName = 'Davis High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'joshuapeterson@live.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'pilewicz6@hotmail.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'normanplaizier@gmail.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bradpoll@wsd.net', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'thadporter@yahoo.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'jonathanquist@aerotechmfg.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'tylerrasmussen@msn.com',	   @siteName = 'Box Elder High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'reidcarlos23@gmail.com', @siteName = 'Box Elder High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'myaddress@comcast.net', @siteName = 'Box Elder High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'richjeff@gmail.com', @siteName = 'Box Elder High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'chad.richins@gmail.com', @siteName = 'Box Elder High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'scott.riley88@gmail.com',	   @siteName = 'Farmington High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'Robinson.David@gmail.com', @siteName = 'Farmington High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karl.robinson56@yahoo.com', @siteName = 'Farmington High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bjross33@netzero.com', @siteName = 'Farmington High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'football98@gmail.com', @siteName = 'Farmington High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'danielrudolph@hotmail.com',	   @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'sadlerterrance@msn.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'markschofield34@gmail.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'schryversteve@live.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'randy.shapiro@gmail.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'vshurtliff909@gmail.com',	   @siteName = 'Logan High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-18 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';








EXECUTE usp_AddGameOfficial @emailAddress = 'ddmartin2020@msn.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'marcusmaxey@gmail.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'msmcd9853@gmail.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'meffmckenney12@yahoo.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mark.mills94@gmail.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'KyleMitchell1990@gmail.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'johnqnelson@dsdmail.net', @siteName = 'Roy High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'boomer3685@yahoo.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'thomascnoker@hotmail.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'kevin.norman@aggiemail.usu.edu', @siteName = 'Roy High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'kirk.osborne.ko@gmail.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ottleybradley@msn.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'jeremywoverton1@gmail.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'pagejerod1976@gmail.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'johnmpage@gmail.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'refwalter@yahoo.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'sampeisley@comcast.net', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'lesterpetersen1@gmail.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'peterson98657@comcast.net', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'joshuapeterson@live.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'pilewicz6@hotmail.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'normanplaizier@gmail.com', @siteName = 'Bountiful High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bradpoll@wsd.net', @siteName = 'Bountiful High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'thadporter@yahoo.com', @siteName = 'Bountiful High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'jonathanquist@aerotechmfg.com', @siteName = 'Bountiful High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'tylerrasmussen@msn.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'reidcarlos23@gmail.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'myaddress@comcast.net', @siteName = 'Bear River High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'richjeff@gmail.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'chad.richins@gmail.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'scott.riley88@gmail.com',	   @siteName = 'Ridgeline High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'Robinson.David@gmail.com', @siteName = 'Ridgeline High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karl.robinson56@yahoo.com', @siteName = 'Ridgeline High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bjross33@netzero.com', @siteName = 'Ridgeline High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'football98@gmail.com', @siteName = 'Ridgeline High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'danielrudolph@hotmail.com',	   @siteName = 'Sky View High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'sadlerterrance@msn.com', @siteName = 'Sky View High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'markschofield34@gmail.com', @siteName = 'Sky View High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'schryversteve@live.com', @siteName = 'Sky View High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'randy.shapiro@gmail.com', @siteName = 'Sky View High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'vshurtliff909@gmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Referee', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Umpire', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Head Linesman', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Line Judge', @sport = 'Football', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-25 19:00', @positionName = 'Back Judge', @sport = 'Football', @level = 'Varsity';


EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Sky View High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Sky View High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Sky View High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Sky View High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Sky View High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Sky View High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';






EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-03 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-03 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-03 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-03 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-03 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-03 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-03 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-03 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-03 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-03 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-03 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-03 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-09-03 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-03 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-09-03 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-03 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-09-03 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-03 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-03 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-03 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-03 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-03 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-03 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-03 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';





EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-09-10 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-10 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-09-10 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-10 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-09-10 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-10 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-10 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-10 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-10 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-10 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-10 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-10 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-10 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-10 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-10 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-10 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-10 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-10 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-01 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-01 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-01 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';





EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-15 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-15 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-15 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-15 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-15 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-15 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-15 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-15 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-15 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-15 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-15 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-15 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-15 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-15 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-15 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-15 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-15 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-15 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-15 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-15 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-15 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-15 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-15 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-15 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Logan High School', @gameDateTime = '2020-09-15 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-15 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Logan High School', @gameDateTime = '2020-09-15 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-15 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Logan High School', @gameDateTime = '2020-09-15 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Logan High School', @gameDateTime = '2020-09-15 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';






EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Clearfield High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Roy High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Roy High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'vshurtliff909@gmail.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'randy.shapiro@gmail.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'vshurtliff909@gmail.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'randy.shapiro@gmail.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'vshurtliff909@gmail.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'randy.shapiro@gmail.com', @siteName = 'Weber High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'schryversteve@live.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'markschofield34@gmail.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'schryversteve@live.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'markschofield34@gmail.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'schryversteve@live.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'markschofield34@gmail.com', @siteName = 'Bonneville High School', @gameDateTime = '2020-09-17 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';



EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-22 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-22 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-22 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-22 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-09-22 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Davis High School', @gameDateTime = '2020-09-22 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-09-22 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-22 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-09-22 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-22 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-09-22 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Layton High School', @gameDateTime = '2020-09-22 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-22 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-22 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-22 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-22 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-22 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-22 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-22 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-22 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-22 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-22 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Bear River High School', @gameDateTime = '2020-09-22 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Bear River High School', @gameDateTime = '2020-09-22 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-22 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-22 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-22 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-22 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-22 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Green Canyon High School', @gameDateTime = '2020-09-22 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';






EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-09-24 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-24 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-09-24 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-24 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-09-24 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com', @siteName = 'Northridge High School', @gameDateTime = '2020-09-24 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-24 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-24 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-24 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-24 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-09-24 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com', @siteName = 'Syracuse High School', @gameDateTime = '2020-09-24 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Box Elder High School', @gameDateTime = '2020-09-24 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Box Elder High School', @gameDateTime = '2020-09-24 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Box Elder High School', @gameDateTime = '2020-09-24 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Box Elder High School', @gameDateTime = '2020-09-24 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Box Elder High School', @gameDateTime = '2020-09-24 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com', @siteName = 'Box Elder High School', @gameDateTime = '2020-09-24 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-24 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-24 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-24 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-24 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-24 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com', @siteName = 'Mountain Crest High School', @gameDateTime = '2020-09-24 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Sky View High School', @gameDateTime = '2020-09-24 18:00', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Sky View High School', @gameDateTime = '2020-09-24 18:00', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Sky View High School', @gameDateTime = '2020-09-24 16:45', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Sky View High School', @gameDateTime = '2020-09-24 16:45', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'ldjbon@gmail.com',	   @siteName = 'Sky View High School', @gameDateTime = '2020-09-24 15:30', @positionName = 'Referee', @sport = 'Volleyball', @level = 'Sophmore';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com', @siteName = 'Sky View High School', @gameDateTime = '2020-09-24 15:30', @positionName = 'Umpire', @sport = 'Volleyball', @level = 'Sophmore';





EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Northridge High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com',	   @siteName = 'Davis High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Farmington High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com',	   @siteName = 'Farmington High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Farmington High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'vshurtliff909@gmail.com',	   @siteName = 'Fremont High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'randy.shapiro@gmail.com',	   @siteName = 'Fremont High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'schryversteve@live.com',	   @siteName = 'Fremont High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'markschofield34@gmail.com',	   @siteName = 'Woods Cross High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'sadlerterrance@msn.com',	   @siteName = 'Woods Cross High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'danielrudolph@hotmail.com',	   @siteName = 'Woods Cross High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'bjross33@netzero.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karl.robinson56@yahoo.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'Robinson.David@gmail.com',	   @siteName = 'Clearfield High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'scott.riley88@gmail.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'chad.richins@gmail.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'richjeff@gmail.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-25 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';





EXECUTE usp_AddGameOfficial @emailAddress = 'ack.devin@gmail.com',	   @siteName = 'Box Elder High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refchrisadams@gmail.com',	   @siteName = 'Box Elder High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bga78@msn.com',	   @siteName = 'Box Elder High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'grukmuk@msn.com',	   @siteName = 'Fremont High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'paul.bernier@gmail.com',	   @siteName = 'Fremont High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mikeb@aspen.com',	   @siteName = 'Fremont High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'karlbeckstrom@msn.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'brandon@petro.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tybar14@hotmail.com',	   @siteName = 'Weber High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'vshurtliff909@gmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'randy.shapiro@gmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'schryversteve@live.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'markschofield34@gmail.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'sadlerterrance@msn.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'danielrudolph@hotmail.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'bjross33@netzero.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karl.robinson56@yahoo.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'Robinson.David@gmail.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'scott.riley88@gmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'chad.richins@gmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'richjeff@gmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';





EXECUTE usp_AddGameOfficial @emailAddress = 'vshurtliff909@gmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'randy.shapiro@gmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'schryversteve@live.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'markschofield34@gmail.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'sadlerterrance@msn.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'danielrudolph@hotmail.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'bjross33@netzero.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'karl.robinson56@yahoo.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'Robinson.David@gmail.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'scott.riley88@gmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'chad.richins@gmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'richjeff@gmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'myaddress@comcast.net',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'tylerrasmussen@msn.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'jonathanquist@aerotechmfg.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'thadporter@yahoo.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'bradpoll@wsd.net',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'normanplaizier@gmail.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'pilewicz6@hotmail.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'joshuapeterson@live.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'peterson98657@comcast.net',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'lesterpetersen1@gmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'sampeisley@comcast.net',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'refwalter@yahoo.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'johnmpage@gmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'pagejerod1976@gmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'jeremywoverton1@gmail.com',	   @siteName = 'Syracuse High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'ottleybradley@msn.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'kirk.osborne.ko@gmail.com',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'kevin.norman@aggiemail.usu.edu',	   @siteName = 'Bountiful High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'thomascnoker@hotmail.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'boomer3685@yahoo.com',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'johnqnelson@dsdmail.net',	   @siteName = 'Bonneville High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';

EXECUTE usp_AddGameOfficial @emailAddress = 'KyleMitchell1990@gmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Referee', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'mark.mills94@gmail.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 1', @sport = 'Women-Soccer', @level = 'Varsity';
EXECUTE usp_AddGameOfficial @emailAddress = 'meffmckenney12@yahoo.com',	   @siteName = 'Layton High School', @gameDateTime = '2020-08-27 15:00', @positionName = 'Linesman 2', @sport = 'Women-Soccer', @level = 'Varsity';





EXECUTE usp_AddArbiter @emailAddress = 'sheldonb@hotmail.com', @sport = 'Volleyball', @level = 'Varsity';
EXECUTE usp_AddArbiter @emailAddress = 'sheldonb@hotmail.com', @sport = 'Volleyball', @level = 'Junior Varsity';
EXECUTE usp_AddArbiter @emailAddress = 'sheldonb@hotmail.com', @sport = 'Volleyball', @level = 'Sophmore';

EXECUTE usp_AddArbiter @emailAddress = 'jeffbraun8@gmail.com', @sport = 'Football', @level = 'Varsity';

EXECUTE usp_AddArbiter @emailAddress = 'jonathankilburn@aol.com', @sport = 'Football', @level = 'Junior Varsity';

EXECUTE usp_AddArbiter @emailAddress = 'calvinking@gmail.com', @sport = 'Softball', @level = 'Varsity';
EXECUTE usp_AddArbiter @emailAddress = 'calvinking@gmail.com', @sport = 'Softball', @level = 'Junior Varsity';
EXECUTE usp_AddArbiter @emailAddress = 'calvinking@gmail.com', @sport = 'Softball', @level = 'Sophmore';

EXECUTE usp_AddArbiter @emailAddress = 'paulleonard234@yahoo.com', @sport = 'Baseball', @level = 'Varsity';
EXECUTE usp_AddArbiter @emailAddress = 'paulleonard234@yahoo.com', @sport = 'Baseball', @level = 'Junior Varsity';
EXECUTE usp_AddArbiter @emailAddress = 'paulleonard234@yahoo.com', @sport = 'Baseball', @level = 'Sophmore';


SELECT emailAddress FROM gosUser WHERE firstName = 'Sheldon' AND lastName = 'Bennett'
SELECT emailAddress FROM gosUser WHERE firstName = 'Jeff' AND lastName = 'Braun'
SELECT emailAddress FROM gosUser WHERE firstName = 'Jonathan' AND lastName = 'Kilburn'
SELECT emailAddress FROM gosUser WHERE firstName = 'Calvin' AND lastName = 'King'
SELECT emailAddress FROM gosUser WHERE firstName = 'Paul' AND lastName = 'Leonard'






SELECT * FROM gosSportLevel;
SELECT * FROM gosOfficiatingPosition;
SELECT * FROM gosSecurityQuestion;
SELECT * FROM gosSecurityAnswer;
SELECT * FROM gosSite;
SELECT * FROM gosSchool;
SELECT * FROM gosUser;
SELECT * FROM gosGame;
SELECT * FROM gosAthleticDirector;
SELECT * FROM gosGame;
SELECT * FROM gosOfficial;
SELECT * FROM gosGameOfficial;
SELECT * FROM gosCoach;


SELECT * FROM dbo.udv_GameTeams;
SELECT * FROM dbo.udv_GameOfficialPaymentHistory;
SELECT * FROM dbo.udv_OfficialGameView;


SELECT * FROM gosOfficial;
SELECT * FROM gosGameOfficialPaymentHistory;