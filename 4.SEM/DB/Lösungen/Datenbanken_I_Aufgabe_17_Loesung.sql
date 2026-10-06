-- Aufgabe 17
DROP TRIGGER IF EXISTS set_entry_fee_category;

DELIMITER $$

CREATE TRIGGER set_entry_fee_category
BEFORE INSERT ON Visitor
FOR EACH ROW
BEGIN
	SET NEW.Category = calculate_fee_category(NEW.Birthdate);
END$$

DELIMITER ;

-- INSERT
INSERT INTO Visitor(First_name, Last_Name, Birthdate, Budget) 
VALUES ('Vorname Trigger', 'Nachname Trigger', '2000-01-01', 100)
;


