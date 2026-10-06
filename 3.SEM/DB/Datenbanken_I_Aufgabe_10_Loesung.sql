-- Aufgabe 10

SET SQL_SAFE_UPDATES=0;
SET FOREIGN_KEY_CHECKS=0;

-- 01
-- Attraction Tabelle
INSERT INTO Attraction (Name, Opening_Time, Closing_Time) VALUES
    ('Fahrgeschäft Neu - 01', '09:00:00', '18:00:00'),
    ('Fahrgeschäft Neu - 02', '09:00:00', '18:00:00'),
    ('Show Neu - 01', '09:00:00', '18:00:00')
;

-- Ride Tabelle
INSERT INTO Ride (Attraction_ID, Highspeed, Duration, G_Force, Min_Size, Min_Age, Note, Pregnant, Kind) VALUES
    (48, 100, '00:01:00', 1.0, 10, 1, 'Eine neue tolle Achterbahn 01.', false, 1),
    (49, 200, '00:02:00', 2.0, 20, 2, 'Eine neue tolle Achterbahn 02', false, 1)
;

-- Show Tabelle
INSERT INTO `Show` (Attraction_ID, Duration, Kind) VALUES
    (50, '01:00:00', 1)
;

-- 02
INSERT INTO Employee (First_Name, Last_Name, Birthdate, Salary, Postal_Code, House_Number, Street, Phone_Number) VALUES
    ('Vorname', 'Nachname', '2000-01-01', 1250, '10115', 999, 'Hauptstraße', 123456789)
;

INSERT INTO Employee_Attraction(Attraction_ID, Employee_ID) VALUES
    ( 48, 36 )
;

-- 03
INSERT INTO Visitor (First_Name, Last_Name, Birthdate, Budget, Category) VALUES
    ('Vorname', 'Nachname', '2000-01-01', 30.00, 4)
;

INSERT INTO Visitor_Attraction(Visitor_ID, Attraction_ID) VALUES
    ( 58, 48 ),
    ( 58, 49 ),
    ( 58, 50 )
;

-- 04
UPDATE Visitor 
SET Last_Name = 'Schmidt Schmitt' 
WHERE First_Name = 'Anna' AND Last_Name = 'Schmidt'
;
UPDATE Visitor 
SET Last_Name = 'Schmitt Schmidt' 
WHERE First_Name = 'Patrick' AND Last_Name = 'Schmitt'
;

-- 05
UPDATE Employee 
SET Salary = Salary * 1.15 
WHERE TIMESTAMPDIFF( YEAR, CURRENT_DATE(), Birthdate ) < 50
;

UPDATE Employee 
SET Salary = Salary * 1.08 
WHERE TIMESTAMPDIFF( YEAR, CURRENT_DATE(), Birthdate ) >= 50
;

/* Komplexere Variante */
UPDATE Employee 
SET Salary = 
CASE 
	WHEN TIMESTAMPDIFF( YEAR, CURRENT_DATE(), Birthdate ) < 50 THEN Salary * 1.15
	ELSE Salary * 1.08
END
;

-- 06
UPDATE Ride
SET Min_Age = 10 
WHERE Note LIKE '%Bahn%'
;

-- 07
DELETE FROM Employee
WHERE First_Name = 'Marc' AND Last_Name = 'Dietrich'
;

-- 08
DELETE FROM `Show`
WHERE Kind = 12
;

