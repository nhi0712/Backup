-- Aufgabe 13
-- USE `AmusementPark`;

-- 01
SELECT MAX(Salary) AS Max_Salary FROM
(
SELECT c.City, AVG(Salary) AS Salary 
FROM Employee AS e 
INNER JOIN City AS c ON c.Postal_Code = e.Postal_Code
GROUP BY c.City
) AS MaxS
;

-- 02
SELECT ea.Attraction_ID, a.Name
FROM Employee_Attraction AS ea
INNER JOIN Attraction AS a on a.Attraction_ID = ea.Attraction_ID
WHERE ea.Employee_ID = ( SELECT Employee_ID FROM Employee WHERE First_Name = 'Lisa' AND Last_Name = 'Weber' )
;

-- 03
SELECT *
FROM Visitor AS v
WHERE EXISTS( SELECT Visitor_ID FROM Visitor_Attraction AS va WHERE v.Visitor_ID = va.Visitor_ID )
; 

-- 04
SELECT *
FROM Employee AS e
WHERE e.Postal_Code = ANY ( SELECT Postal_Code FROM City WHERE City = 'Berlin' )
;

-- Alternativ
SELECT *
FROM Employee AS e
WHERE e.Postal_Code IN ( SELECT Postal_Code FROM City WHERE City = 'Berlin' )
;

-- 05
SELECT *
FROM Entry_Fee AS e
WHERE NOT EXISTS( SELECT Category FROM Visitor AS v WHERE v.Category = e.Category )
; 