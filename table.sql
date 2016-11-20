CREATE TABLE IF NOT EXISTS `Gangs` (

	`GangID`		INT(24)			AUTO_INCREMENT,
	`GangName`		VARCHAR(24)		NOT NULL,
	`GangColor`		INT(24)			NOT NULL,
	`GangTag`		VARCHAR(4)		NOT NULL,
	`GangScore`		INT(24)			NOT NULL 			DEFAULT '0',

	PRIMARY KEY(`GangID`),
	UNIQUE KEY `GangName` (`GangName`)
);

CREATE TABLE IF NOT EXISTS `Zones` (

	`ID`			INT(24)			AUTO_INCREMENT,
	`Name`			VARCHAR(32)		NOT NULL,
	`MinX`			FLOAT(24)		NOT NULL,
	`MinY`			FLOAT(24)		NOT NULL,
	`MaxX`			FLOAT(24)		NOT NULL,
	`MaxY`			FLOAT(24)		NOT NULL,
	`Owner`			VARCHAR(32)		NOT NULL,
	`Color`			INT(24)			NOT NULL,

	PRIMARY KEY(`ID`),
	KEY `Name_index` (`Name`)
);

CREATE TABLE IF NOT EXISTS `Members` (

	`UserID`		INT(24)			AUTO_INCREMENT,
	`UserName`		VARCHAR(24)		NOT NULL,
	`GangMember`	TINYINT(1)		NOT NULL			DEFAULT '0',
	`GangLeader`	TINYINT(1)		NOT NULL			DEFAULT '0',
	`GangName`		VARCHAR(24)		NOT NULL,

	PRIMARY KEY(`UserID`),
	UNIQUE KEY `UserName` (`UserName`)
);
