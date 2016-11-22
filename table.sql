CREATE TABLE IF NOT EXISTS `Gangs` (

	`GangID`		INT(11)			AUTO_INCREMENT,
	`GangName`		VARCHAR(32)		NOT NULL,
	`GangColor`		INT(11)			NOT NULL,
	`GangTag`		VARCHAR(4)		NOT NULL,
	`GangScore`		INT(11)			NOT NULL 			DEFAULT '0',

	PRIMARY KEY(`GangID`),
	UNIQUE KEY `GangName` (`GangName`),
	KEY `GangScore` (`GangScore`)
);

CREATE TABLE IF NOT EXISTS `Zones` (

	`ID`			INT(11)			AUTO_INCREMENT,
	`Name`			VARCHAR(32)		NOT NULL,
	`MinX`			FLOAT(15)		NOT NULL,
	`MinY`			FLOAT(15)		NOT NULL,
	`MaxX`			FLOAT(15)		NOT NULL,
	`MaxY`			FLOAT(15)		NOT NULL,
	`Owner`			INT(11)		NOT NULL,
	`Color`			INT(11)			NOT NULL,

	PRIMARY KEY(`ID`),
	KEY `Name` (`Name`)
);

CREATE TABLE IF NOT EXISTS `Members` (

	`UserID`		INT(11)			AUTO_INCREMENT,
	`UserName`		VARCHAR(24)		NOT NULL,
	`GangMember`	TINYINT(1)		NOT NULL			DEFAULT '0',
	`GangLeader`	TINYINT(1)		NOT NULL			DEFAULT '0',
	`GangID`		INT(11)		NOT NULL,

	PRIMARY KEY(`UserID`),
	UNIQUE KEY `UserName` (`UserName`)
);
