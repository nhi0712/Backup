-- Aufgabe 08
-- USE `AmusementPark`;

-- 01
SELECT first_name FROM Employee
UNION
SELECT first_name FROM Visitor;

-- 02
SELECT sk.Name 
FROM Show_Kind AS sk
UNION
SELECT rk.Name 
FROM Ride_Kind AS rk
INNER JOIN Ride AS r ON r.Kind = rk.Kind
WHERE r.Note NOT LIKE '%Fahrt%'
;
-- 03
SELECT 'Show' AS Attraction_Kind, s.Duration, 0 AS G_Force, 0 AS Highspeed, 0 AS Min_Age, 0 AS Min_Size, '' AS Note, false AS Pregnant
FROM `Show` AS s
UNION
SELECT 'Ride' AS Attraction_Kind, r.Duration, r.G_Force, r.Highspeed, r.Min_Age, r.Min_Size, r.Note, r.Pregnant
FROM Ride AS r
WHERE Min_Age <= 10
ORDER BY Duration ASC 
LIMIT 15
;

-- 04
SELECT rk.Kind, rk.Name, r.Attraction_ID, r.Duration, r.G_Force, r.Highspeed, r.Min_Age, r.Min_Size, r.Note, r.Pregnant
FROM Ride_Kind AS rk
LEFT OUTER JOIN Ride AS r ON rk.Kind = r.Kind
UNION
SELECT rk.Kind, rk.Name, r.Attraction_ID, r.Duration, r.G_Force, r.Highspeed, r.Min_Age, r.Min_Size, r.Note, r.Pregnant
FROM Ride_Kind AS rk
RIGHT OUTER JOIN Ride AS r ON rk.Kind = r.Kind
;

-- 05
SELECT first_name FROM Visitor
EXCEPT
SELECT first_name FROM Employee;

/* Alle Vornamen von Mitarbeitern, die es nicht bei Besuchern gibt*/
SELECT first_name FROM Employee
EXCEPT
SELECT first_name FROM Visitor;

-- 06
SELECT first_name FROM Visitor
INTERSECT
SELECT first_name FROM Employee;