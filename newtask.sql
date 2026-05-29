create database digital_contact;
use digital_contact;

CREATE TABLE Contacts (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    city VARCHAR(100)
);


DELIMITER $$
CREATE PROCEDURE add_contact(
    IN p_name VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_city VARCHAR(100)
)
BEGIN

    IF p_name = '' OR p_name IS NULL THEN
        SELECT 'Error: Name cannot be empty.' AS message;
    ELSEIF p_phone = '' OR p_phone IS NULL THEN
        SELECT 'Error: Phone cannot be empty.' AS message;
    ELSE
        INSERT INTO Contacts (name, phone, email, city)
        VALUES (p_name, p_phone, p_email, p_city);
        
        SELECT LAST_INSERT_ID() AS new_contact_id,
               'Contact saved successfully!' AS message;
    END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE search_contact(
    IN p_partial_name VARCHAR(100)
)
BEGIN
    SELECT contact_id, name, phone, email, city
    FROM Contacts
    WHERE name LIKE CONCAT('%', p_partial_name, '%');
END$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE update_phone(
    IN p_contact_id INT,
    IN p_new_phone VARCHAR(20)
)
BEGIN
    -- Check if contact exists
    IF NOT EXISTS (SELECT 1 FROM Contacts WHERE contact_id = p_contact_id) THEN
        SELECT 'Error: Contact not found.' AS message;
    ELSE
        UPDATE Contacts
        SET phone = p_new_phone
        WHERE contact_id = p_contact_id;
        
        SELECT 'Phone number updated successfully!' AS message;
    END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE delete_contact(
    IN p_contact_id INT
)
BEGIN
    -- Check if contact exists
    IF NOT EXISTS (SELECT 1 FROM Contacts WHERE contact_id = p_contact_id) THEN
        SELECT 'Error: Contact not found.' AS message;
    ELSE
        DELETE FROM Contacts
        WHERE contact_id = p_contact_id;
        
        SELECT 'Contact permanently removed.' AS message;
    END IF;
END$$
DELIMITER ;



CALL add_contact('Ram Sharma', '9841000001', 'ram@email.com', 'Kathmandu');
CALL add_contact('Ramesh Karki', '9841000002', 'ramesh@email.com', 'Pokhara');
CALL add_contact('Bikram Thapa', '9841000003', 'bikram@email.com', 'Lalitpur');

CALL search_contact('Ram');       -- Returns Ram Sharma, Ramesh Karki, Bikram Thapa
CALL update_phone(1, '9841999999');
CALL delete_contact(2);