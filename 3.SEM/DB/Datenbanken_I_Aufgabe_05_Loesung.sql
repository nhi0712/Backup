-- Aufgabe 05
-- USE `AmusementPark`;

-- 01
SELECT *
FROM Attraction
WHERE Closing_Time > '20:00:00'
ORDER BY Closing_Time DESC
;

-- 02
SELECT * 
FROM Ride
WHERE Highspeed > 50
ORDER BY Highspeed DESC
;

-- 03
SELECT * 
FROM `Show`
WHERE Duration > '01:00:00'
ORDER BY Duration ASC
;

-- 04
SELECT *
FROM Visitor
WHERE Birthdate >= '2000-01-01' AND Budget >= 100
;

-- 05
SELECT *
FROM Employee
WHERE Salary BETWEEN 2500 AND 3500
ORDER BY Salary ASC
;

-- 06
SELECT DISTINCT First_Name
FROM Visitor
WHERE First_Name LIKE '_a%'
ORDER BY First_Name DESC
;

-- 07
SELECT *
FROM Visitor
WHERE First_Name LIKE 'S%' AND Last_Name NOT LIKE '%S%' AND Budget >= 50
ORDER BY Budget DESC
LIMIT 2
;

-- 08
SELECT * 
FROM Ride
WHERE	Highspeed >= 100 
	AND Min_Size > 100 
    AND Min_Size < 190 
	AND G_Force BETWEEN 3 AND 5 
    AND Pregnant = true 
    AND ( Note LIKE '%Bahn%' OR  Note LIKE '%Boot%' )
    AND Duration <= '00:04:00'
    OR Min_Age = 0
;

-- 09
SELECT *
FROM Employee 
WHERE Street LIKE '%Straße%' AND ( Postal_Code LIKE '%5' OR Postal_Code LIKE '%7' )
;

-- 10 
SELECT * 
FROM Attraction 
ORDER BY Opening_Time ASC, Closing_Time DESC, Name ASC
;
