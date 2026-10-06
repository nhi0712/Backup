-- Aufgabe 11

-- 01
CREATE VIEW Visitor_Pay_Fee AS
SELECT v.First_Name, v.Last_Name, e.Fee AS Payed_Fee
FROM Visitor AS v
LEFT OUTER JOIN Entry_Fee AS e ON v.Category = e.Category
;

SELECT * FROM Visitor_Pay_Fee
;

-- 02
CREATE VIEW Employee_Address AS
SELECT e.First_Name, e.Last_Name, e.Birthdate, e.Salary, e.Postal_Code, c.City, e.Street, e.House_Number
FROM Employee AS e
LEFT OUTER JOIN City AS c ON e.Postal_Code = c.Postal_Code
;

SELECT * FROM Employee_Address
;

-- 03
CREATE VIEW Attraction_All_Info AS
SELECT 
a.Attraction_ID, a.Name, s.Duration AS Show_Duration, r.Duration AS Ride_Duration, r.G_Force, r.Highspeed, 
r.Min_Age, r.Min_Size, r.Note, r.Pregnant, s.Kind AS Show_Kind, sk.Name AS Show_Kind_Name, r.Kind AS Ride_Kind, rk.Name AS Ride_Kind_Name
FROM Attraction AS a
LEFT OUTER JOIN Ride AS r ON a.Attraction_ID = r.Attraction_ID
LEFT OUTER JOIN `Show` AS s ON a.Attraction_ID = s.Attraction_ID
LEFT OUTER JOIN Ride_Kind AS rk ON rk.Kind = r.Kind
LEFT OUTER JOIN Show_Kind AS sk ON sk.Kind = s.Kind
;

SELECT * FROM Attraction_All_Info
;

-- 04
CREATE VIEW Attraction_Employee_Info AS
SELECT 
a.Attraction_ID, a.Name, s.Duration AS Show_Duration, r.Duration AS Ride_Duration, 
r.G_Force, r.Highspeed, r.Min_Age, r.Min_Size, r.Note, r.Pregnant, 
CASE 
WHEN r.Attraction_ID IS NOT NULL THEN 'Ride'
WHEN s.Attraction_ID IS NOT NULL THEN 'Show'
ELSE null
END AS Attraction_Type,
COUNT( ea.Employee_ID ) AS Employee_Count
FROM Employee_Attraction AS ea
LEFT OUTER JOIN Attraction AS a ON a.Attraction_ID = ea.Attraction_ID
LEFT OUTER JOIN Ride AS r ON a.Attraction_ID = r.Attraction_ID
LEFT OUTER JOIN `Show` AS s ON a.Attraction_ID = s.Attraction_ID
GROUP BY 
a.Attraction_ID, a.Name, Show_Duration, Ride_Duration, r.G_Force, r.Highspeed, 
r.Min_Age, r.Min_Size, r.Note, r.Pregnant
HAVING Employee_Count > 1
;

SELECT * FROM Attraction_Employee_Info
;

-- 05
CREATE VIEW Visitor_Attraction_With_Budget AS
SELECT va.Attraction_ID, v.First_Name, v.Last_Name, v.Budget
FROM Visitor_Attraction AS va
LEFT OUTER JOIN Visitor AS v ON va.Visitor_ID = v.Visitor_ID
WHERE v.Budget >= 100
;

SELECT * FROM Visitor_Attraction_With_Budget
;