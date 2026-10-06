-- Aufgabe 14
-- USE `AmusementPark`;

-- 01

WITH Salary AS (
SELECT c.City, AVG(Salary) AS Salary 
FROM Employee AS e 
INNER JOIN City AS c ON c.Postal_Code = e.Postal_Code
GROUP BY c.City
) 
SELECT MAX(Salary) AS Max_Salary FROM Salary
;

-- 02
WITH Lisa AS (
SELECT Employee_ID 
FROM Employee
WHERE First_Name = 'Lisa' AND Last_Name = 'Weber'
)
SELECT ea.Attraction_ID, a.Name
FROM Employee_Attraction AS ea
INNER JOIN Attraction AS a on a.Attraction_ID = ea.Attraction_ID
INNER JOIN Lisa AS l on l.Employee_ID = ea.Employee_ID
;

-- 03
WITH Visits AS (
SELECT Visitor_ID, COUNT(*) AS Visits 
FROM Visitor_Attraction 
GROUP BY Visitor_ID
)
SELECT *
FROM Visitor AS v
INNER JOIN Visits AS vi ON v.Visitor_ID = vi.Visitor_ID
WHERE vi.Visits > 1
; 

-- 04
WITH Berlin AS (
SELECT Postal_Code 
FROM City 
WHERE City = 'Berlin'
)
SELECT *
FROM Employee AS e
INNER JOIN Berlin AS b ON e.Postal_Code = b.Postal_Code
;

-- 05
WITH No_Entry AS ( 
SELECT e.Category
FROM Entry_Fee AS e
LEFT OUTER JOIN Visitor AS v ON v.Category = e.Category
WHERE v.Category IS NULL
)
SELECT e.Category, e.Description, e.Fee, e.Max_Age
FROM Entry_Fee AS e
INNER JOIN No_Entry AS noe ON noe.Category = e.Category
; 