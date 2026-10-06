-- Aufgabe 06
-- USE `AmusementPark`;

-- 01
SELECT Budget / 5.50 AS Bottles
FROM Visitor
ORDER BY Bottles DESC
LIMIT 5
;

-- 02
SELECT First_Name, Last_Name, Salary AS OLd_Salary, ( Salary + House_Number ) * 1.07 AS New_Salary
FROM Employee
;

-- 03
SELECT COUNT(*) AS Number_Employee
FROM Employee
;

-- 04
SELECT Postal_Code, AVG( Salary ) AS Avg_Salary
FROM Employee
GROUP BY Postal_Code
ORDER BY Avg_Salary ASC
LIMIT 3
;

-- 05
SELECT MIN( Highspeed ) AS Min_Highspeed, MAX( Highspeed ) AS Max_Highspeed
FROM Ride
;

-- 06
SELECT AVG( G_Force ) AS Avg_G_Force
FROM Ride
WHERE Note LIKE '%Achterbahn%'
;

-- 07
SELECT First_Name, Last_Name, COUNT(*) AS Count_Name 
FROM Visitor
GROUP BY First_Name, Last_Name
;

-- 08
SELECT First_Name, COUNT(*) AS First_Name_Count
FROM Visitor
GROUP BY First_Name
HAVING First_Name_Count >= 2
ORDER BY First_Name_Count DESC 
LIMIT 10
;

-- 09
SELECT Postal_Code, MIN( Salary ) AS Min_Salary
FROM Employee
GROUP BY Postal_Code
HAVING Min_Salary >= 2800
;

-- 10
SELECT GROUP_CONCAT( Kind ) AS All_Ride_Kind
FROM Ride
WHERE Note LIKE '%Bahn%' OR Note LIKE '%Fahrt%'
;