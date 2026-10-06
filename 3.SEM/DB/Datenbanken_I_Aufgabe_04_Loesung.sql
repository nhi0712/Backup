CREATE TABLE City(
	Postal_Code 	VARCHAR(10) PRIMARY KEY NOT NULL, 
    City			VARCHAR(200)
);

CREATE TABLE Show_Kind(
	Kind 	INTEGER NOT NULL PRIMARY KEY, 
    Name	VARCHAR(50)
);

CREATE TABLE Ride_Kind(
	Kind 	INTEGER NOT NULL PRIMARY KEY, 
    Name	VARCHAR(50)
);

CREATE TABLE Attraction(
	Attraction_ID	INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL, 
	Name 			VARCHAR(100) NOT NULL, 
	Opening_Time 	TIME NOT NULL, 
	Closing_Time 	TIME NOT NULL
);

CREATE TABLE `Show`(
	Attraction_ID 	INTEGER NOT NULL PRIMARY KEY,
	Duration 		TIME NOT NULL, 
	Kind 			INTEGER NOT NULL,
    
    CONSTRAINT Attraction_Show FOREIGN KEY (Attraction_ID) REFERENCES Attraction(Attraction_ID),
	CONSTRAINT Show_Kind_Show FOREIGN KEY (Kind) REFERENCES Show_Kind(Kind)
);

CREATE TABLE Ride(
	Attraction_ID 	INTEGER NOT NULL PRIMARY KEY, 
	Highspeed 		INTEGER, 
	Duration 		TIME NOT NULL, 
	G_Force 		FLOAT, 
	Min_Size 		INTEGER DEFAULT(0), 
	Min_Age 		INTEGER DEFAULT(0), 
	Note 			TEXT, 
	Pregnant 		BOOLEAN NOT NULL DEFAULT(0), 
	Kind 			INTEGER NOT NULL,
	
    CONSTRAINT Attraction_Ride FOREIGN KEY (Attraction_ID) REFERENCES Attraction(Attraction_ID),
	CONSTRAINT Ride_Kind_Ride FOREIGN KEY (Kind) REFERENCES Ride_Kind(Kind)
);

CREATE TABLE Entry_Fee(
	Category		INTEGER PRIMARY KEY NOT NULL, 
    Description		VARCHAR(100) NOT NULL,
    Fee				FLOAT NOT NULL,
	Max_Age			INT NOT NULL
);

CREATE TABLE Visitor(
	Visitor_ID 		INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL, 
	First_Name 		VARCHAR(250) NOT NULL,
	Last_Name 		VARCHAR(250) NOT NULL,
	Birthdate 		DATE NOT NULL, 
	Budget 			FLOAT NOT NULL,
    Category		INTEGER NOT NULL,
    
    CONSTRAINT Visitor_Fee FOREIGN KEY (Category) REFERENCES Entry_Fee(Category)
);

CREATE TABLE Visitor_Attraction(
	Visitor_ID 		INTEGER NOT NULL, 
	Attraction_ID 	INTEGER NOT NULL, 
	Timestamp 		TIMESTAMP NOT NULL,  
    
	CONSTRAINT Attraction_Visitor FOREIGN KEY (Attraction_ID) REFERENCES Attraction(Attraction_ID),  
	CONSTRAINT Visitor FOREIGN KEY (Visitor_ID) REFERENCES Visitor(Visitor_ID), 
	PRIMARY KEY (Visitor_ID, Attraction_ID, Timestamp) 
);

CREATE TABLE Employee(
	Employee_ID 	INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL, 
	First_Name 		VARCHAR(100) NOT NULL, 
	Last_Name 		VARCHAR(100) NOT NULL, 
	Birthdate 		DATE NOT NULL, 
    Salary 			INTEGER NOT NULL, 
	Postal_Code 	VARCHAR(10) NOT NULL, 
    House_Number 	INTEGER NOT NULL,
    Street 			VARCHAR(200) NOT NULL,
    Phone_Number 	VARCHAR(20) NOT NULL,
    
    CONSTRAINT Postal_Code_Empl FOREIGN KEY (Postal_Code) REFERENCES City(Postal_Code),
	CONSTRAINT Min_Salary CHECK (Salary>=1250)
);

CREATE TABLE Employee_Attraction(
	Employee_ID 	INTEGER NOT NULL, 
    Attraction_ID 	INTEGER NOT NULL, 
    
	CONSTRAINT Employee_Attr_Empl FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
    CONSTRAINT Employee_Attr_Attr FOREIGN KEY (Attraction_ID) REFERENCES Attraction(Attraction_ID),
    PRIMARY KEY (Employee_ID, Attraction_ID) 
);




