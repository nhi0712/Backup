-- Aufgabe 09
-- USE `AmusementPark`;

-- 01
SELECT CEIL( Fee * 1.1 ) AS New_Fee
FROM Entry_Fee
;

-- 02
SELECT First_Name, Last_Name, ( Salary * 1.03 ) AS New_Salary
FROM Employee
;

-- 03
SELECT First_Name, Last_Name, DAYNAME( Birthdate ) AS Week_Birthdate
FROM Visitor
;

-- 04
SELECT First_Name, Last_Name, Budget, IF( Budget > 100, true, false ) AS Rich
FROM Visitor
;

-- 05
SELECT Postal_Code, UPPER( SUBSTRING( City, 1, 3 ) ) AS Short_City
FROM City
;

-- 06
SELECT TRIM( Description ) AS Description
FROM Entry_Fee
;

-- 07
SELECT Attraction_ID, Note, G_Force, 
CASE 
	WHEN G_Force >= 4 THEN 'sehr hoch'
    WHEN G_Force >= 3 THEN 'hoch'
    WHEN G_Force >= 2 THEN 'angemessen'
	ELSE 'niedrig'
END AS G_Force_Rating
FROM Ride
;

-- 08
SELECT First_Name, Last_Name,  DATEDIFF( CURRENT_DATE(), Birthdate ) / 365.25 AS Age,
CASE 
	WHEN Birthdate < '1965-01-01' THEN 'Baby-Boomer'
    WHEN Birthdate < '1981-01-01' THEN 'Generation X'
    WHEN Birthdate < '1997-01-01' THEN 'Millenials / Generation Y'
	WHEN Birthdate < '2013-01-01' THEN 'Zoomers / Generation Z'
    ELSE 'Generation Alpha'
    END AS G_Force_Rating
FROM Employee
;

-- 09
SELECT CONCAT_WS( ' ', e.First_Name, e.Last_Name ) AS Full_Name, 
	CONCAT_WS( ' ', e.Postal_Code, CONCAT_WS( ' - ', c.City, CONCAT_WS( ' ', e.Street, e.House_NUmber ) ) ) AS Address
FROM Employee AS e
LEFT OUTER JOIN City AS c ON e.Postal_Code = c.Postal_Code
;

-- 10
SELECT a.Name, CHAR_LENGTH( a.Name ) AS Name_Length, REPLACE( r.Note, 'Achterbahn', 'Coaster' ) AS Note, 
	CHAR_LENGTH( REPLACE( r.Note, 'Achterbahn', 'Coaster' ) ) AS Note_Length
FROM Attraction AS a
LEFT OUTER JOIN Ride AS r ON a.Attraction_ID = r.Attraction_ID
;