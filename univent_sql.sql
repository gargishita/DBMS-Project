CREATE DATABASE Univent;
USE Univent;
-- USER Table
CREATE TABLE User (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    role VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

-- COLLEGE Table
CREATE TABLE College (
    college_id INT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100)
);

-- SUPER_ADMIN Table
CREATE TABLE Super_Admin (
    admin_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    password VARCHAR(100),
    designation VARCHAR(100),
    college_id INT,
    FOREIGN KEY (college_id) REFERENCES College(college_id)
);

-- CLUB_OR_SOCIETY Table
CREATE TABLE Club (
    club_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    Category VARCHAR(100),
    secretary_name VARCHAR(100),
    college_id INT,
    FOREIGN KEY (college_id) REFERENCES College(college_id)
);

-- EVENT Table
CREATE TABLE Event (
    event_id INT PRIMARY KEY,
    name VARCHAR(100),
    type_of_event VARCHAR(100),
    date DATE,
    location VARCHAR(100),
    status VARCHAR(50),
    organised_BY INT,
    max_num_of_participants INT,
    FOREIGN KEY (organised_BY) REFERENCES Club(club_id)
);
-- PAST_EVENT Table 
SET GLOBAL event_scheduler = ON;
DELIMITER $$

CREATE EVENT move_old_events_to_past
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
  INSERT INTO Past_Event (event_id, name, type_of_event, date, location, status)
  SELECT event_id, name, type_of_event, date, location, status
  FROM Event
  WHERE date < CURDATE() - INTERVAL 2 DAY;

  DELETE FROM Event
  WHERE date < CURDATE() - INTERVAL 2 DAY;
END$$

DELIMITER ;


-- COMPETITION Table
CREATE TABLE Competition (
    comp_id INT auto_increment PRIMARY KEY,
    name VARCHAR(100),
    type_of_comp VARCHAR(100),
    date DATE,
    venue VARCHAR(100),
    event_id INT,
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
);

-- TRANSACTION Table
CREATE TABLE Transaction (
    trans_id INT AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(10, 2),
    description TEXT,
    trans_type VARCHAR(50),
    transferred_to INT,
    FOREIGN KEY (transferred_to) REFERENCES Club(club_id)
);

-- REGISTERS Table
CREATE TABLE Registers (
    reg_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    event_id INT,
    UNIQUE (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
);

-- REQUESTS_APPROVAL Table
CREATE TABLE Requests_Approval (
    request_id INT PRIMARY KEY,
    club_id INT,
    source VARCHAR(100),
    status VARCHAR(50),
    approved_by INT,
    rejected_by INT,
    FOREIGN KEY (club_id) REFERENCES Club(club_id),
    FOREIGN KEY (approved_by) REFERENCES Super_Admin(admin_id),
    FOREIGN KEY (rejected_by) REFERENCES Super_Admin(admin_id)
);

-- FEEDBACK Table
CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY,
    event_id INT,
    user_id INT,
    time TIMESTAMP,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    FOREIGN KEY (event_id) REFERENCES Event(event_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);
-- Remove the secretary_name column from the Club table
ALTER TABLE Club
DROP COLUMN secretary_name;
