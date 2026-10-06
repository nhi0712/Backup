-- Aufgabe 15

DROP FUNCTION IF EXISTS calculate_fee_category;

DELIMITER $$ 
CREATE FUNCTION IF NOT EXISTS calculate_fee_category(Birthdate DATE)
RETURNS INT
NOT DETERMINISTIC
BEGIN
    DECLARE Category INT;
    SET Category = 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, Birthdate, CURDATE()) >= 63 THEN 5
        WHEN TIMESTAMPDIFF(YEAR, Birthdate, CURDATE()) >= 12 THEN 4
        WHEN TIMESTAMPDIFF(YEAR, Birthdate, CURDATE()) BETWEEN 6 AND 11 THEN 3
        WHEN TIMESTAMPDIFF(YEAR, Birthdate, CURDATE()) BETWEEN 2 AND 5 THEN 2
        ELSE 1
    END;
	RETURN Category;
END $$
DELIMITER ;
SELECT calculate_fee_category('2000-01-01') AS Fee_Category;


