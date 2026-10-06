-- Aufgabe 02

-- 01

CREATE TABLE Employee(
	Employee_ID 	INTEGER NOT NULL, 
	First_Name 		VARCHAR(100) NOT NULL, 
	Last_Name 		VARCHAR(100) NOT NULL, 
	Birthdate 		DATE NOT NULL, 
    Salary 			INTEGER NOT NULL, 
	Postal_Code 	VARCHAR(10) NOT NULL, 
    House_Number 	VARCHAR(10) NOT NULL,
    Street 			VARCHAR(200) NOT NULL,
    Phone_Number 	VARCHAR(20) NOT NULL,
    
    PRIMARY KEY(Employee_ID, Birthdate)
	)
	PARTITION BY RANGE (YEAR(Birthdate)) (
	  PARTITION p1990 VALUES LESS THAN (YEAR('2000-01-01')),
	  PARTITION p2000 VALUES LESS THAN (YEAR('2010-01-01')),
	  PARTITION pmax  VALUES LESS THAN MAXVALUE
	)
;

-- 02

CREATE TABLE Visitor(
	Visitor_ID 		INTEGER NOT NULL, 
	First_Name 		VARCHAR(100) NOT NULL,
	Last_Name 		VARCHAR(100) NOT NULL,
	Birthdate 		DATE NOT NULL, 
	Budget 			FLOAT NOT NULL,
    Category		INTEGER NOT NULL,

    PRIMARY KEY (Visitor_ID, Category)
    )
    PARTITION BY LIST (Category) (
        PARTITION p_cat_1 VALUES IN (1),
        PARTITION p_cat_2 VALUES IN (2),
        PARTITION p_cat_3 VALUES IN (3),
        PARTITION p_cat_4 VALUES IN (4),
        PARTITION p_cat_5 VALUES IN (5),
        PARTITION p_cat_6 VALUES IN (6),
        PARTITION p_cat_default VALUES IN (DEFAULT)
    )
;


