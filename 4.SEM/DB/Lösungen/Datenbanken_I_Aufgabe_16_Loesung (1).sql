-- Aufgabe 16

-- Procedure
DROP PROCEDURE IF EXISTS new_employee;

DELIMITER $$

CREATE PROCEDURE new_employee (
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_birthdare DATE,
    OUT p_salary DECIMAL(10,2)
)
BEGIN
    DECLARE employee_id INT;
    DECLARE min_salary DECIMAL(10,2);
    DECLARE random_bonus INT;
    DECLARE number_attractions INT;
    DECLARE max_attraction_id INT;
    DECLARE attraction_counter INT DEFAULT 0;
    DECLARE random_attraction_id INT;

    SELECT MIN(Salary) AS Salary INTO min_salary FROM Employee;
    SET random_bonus = 100 + FLOOR(RAND() * 101);
    SET p_salary = min_salary + random_bonus;

	INSERT INTO Employee (First_Name, Last_Name, Birthdate, Salary, Postal_Code, House_Number, Street, Phone_Number) 
        VALUES (p_first_name, p_last_name, p_birthdare, p_salary, '10115', 999, 'Hauptstraße', 123456789)
	;

    SET employee_id = LAST_INSERT_ID();
    -- not perfect as there may be a multiple assignment of the same attraction which leads to an insert issue
    SELECT MAX(Attraction_ID) INTO max_attraction_id FROM Attraction;
    SET number_attractions = FLOOR(1 + RAND() * 3);

    WHILE attraction_counter < number_attractions DO
        SET random_attraction_id = FLOOR(1 + RAND() * max_attraction_id);
        INSERT INTO Employee_Attraction(Attraction_ID, Employee_ID)
            VALUES (random_attraction_id, employee_id);
        SET attraction_counter = attraction_counter + 1;
    END WHILE;
END$$

DELIMITER ;

-- CALL und SELECT
SET @salary = 0;
CALL new_employee('Vorname Procedure', 'Nachname Procedure', '2000-12-31', @salary);

SELECT CONCAT('Salary: ', @salary) AS Salary
;
SELECT * FROM Employee ORDER BY Employee_ID DESC LIMIT 1
;