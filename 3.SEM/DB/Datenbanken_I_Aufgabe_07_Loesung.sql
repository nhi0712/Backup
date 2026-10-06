-- Aufgabe 07
-- USE `AmusementPark`;

-- 01
SELECT e.Postal_Code, c.City
FROM Employee AS e
LEFT OUTER JOIN City AS c ON e.Postal_Code = c.Postal_Code
WHERE e.House_Number MOD 2 = 1 AND e.Birthdate < '2000-01-01'
;

-- 02
SELECT v.First_Name, v.Last_Name, v.Budget + e.Fee AS Budget_All
FROM Visitor AS v
LEFT OUTER JOIN Entry_Fee AS e ON v.Category = e.Category
WHERE v.First_Name LIKE '______%' 
ORDER BY Budget_All DESC
LIMIT 20
;

-- 03
SELECT s.Attraction_ID, a.Name, s.Kind, sk.Name
FROM `Show` AS s
LEFT OUTER JOIN Attraction AS a ON s.Attraction_ID = a.Attraction_ID
LEFT OUTER JOIN Show_Kind AS sk ON s.Kind = sk.Kind
;

-- 04
SELECT AVG( e.Fee ) AS Avg_Payed_Fee
FROM Visitor AS v
INNER JOIN Entry_Fee AS e ON v.Category = e.Category
;

-- 05
SELECT sk.Kind, sk.Name
FROM Show_Kind AS sk
LEFT OUTER JOIN `Show` AS s ON sk.Kind = s.Kind
WHERE s.Attraction_ID IS NULL
;

-- 06
SELECT rk.Kind, rk.Name, COUNT( r.Attraction_ID ) AS Ride_Count
FROM Ride_Kind AS rk
LEFT OUTER JOIN Ride AS r ON rk.Kind = r.Kind
GROUP BY rk.Kind, rk.Name
ORDER BY Ride_Count DESC
;

-- 07
SELECT va.Visitor_ID, v.First_Name, v.Last_Name, va.Attraction_ID, a.Name, va.Timestamp
FROM Visitor_Attraction AS va
LEFT OUTER JOIN Visitor AS v ON va.Visitor_ID = v.Visitor_ID
LEFT OUTER JOIN Attraction AS a ON va.Attraction_ID = a.Attraction_ID
;

-- 08
SELECT va.Visitor_ID, v.First_Name, v.Last_Name, va.Attraction_ID, a.Name, COUNT( r.Attraction_ID ) AS Ride_Count
FROM Visitor_Attraction AS va
LEFT OUTER JOIN Visitor AS v ON va.Visitor_ID = v.Visitor_ID
LEFT OUTER JOIN Attraction AS a ON va.Attraction_ID = a.Attraction_ID
INNER JOIN Ride AS r ON va.Attraction_ID = r.Attraction_ID
GROUP BY va.Visitor_ID, v.First_Name, v.Last_Name, va.Attraction_ID, a.Name
HAVING Ride_Count > 1
;

-- 09
SELECT va.Attraction_ID, a.Name, COUNT( va.Visitor_ID ) AS Visitor_Count
FROM Visitor_Attraction AS va
LEFT OUTER JOIN Attraction AS a ON va.Attraction_ID = a.Attraction_ID
GROUP BY va.Attraction_ID, a.Name
HAVING Visitor_Count >= 3
;

-- 10
SELECT ea.Attraction_ID, a.Name, SUM( e.Salary ) AS Cost
FROM Employee_Attraction AS ea
LEFT OUTER JOIN Attraction AS a ON ea.Attraction_ID = a.Attraction_ID
LEFT OUTER JOIN Employee AS e ON ea.Employee_ID = e.Employee_ID
GROUP BY ea.Attraction_ID, a.Name
;

-- 11
SELECT r.Kind, rk.Name, AVG( e.Salary ) AS Cost
FROM Employee_Attraction AS ea
INNER JOIN Ride AS r ON ea.Attraction_ID = r.Attraction_ID
INNER JOIN Ride_Kind AS rk ON r.Kind = rk.Kind
LEFT OUTER JOIN Employee AS e ON ea.Employee_ID = e.Employee_ID
GROUP BY r.Kind, rk.Name
;

-- 12
SELECT v.Visitor_ID, v.First_Name, v.Last_Name, a.Attraction_ID, a.Name
FROM Visitor AS v
CROSS JOIN Attraction AS a
;