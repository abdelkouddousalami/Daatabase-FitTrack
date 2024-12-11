CREATE DATABASE FitnessManagement;
USE FitnessManagement;

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL , 
    last_name VARCHAR(50) NOT NULL ,
    gender ENUM('Male', 'Female', 'Other'),
    date_of_birth DATE,
    phone_number VARCHAR(15),
    email VARCHAR(100) UNIQUE
);
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10),
    room_type ENUM('Cardio', 'Weights', 'Studio'),
    capacity INT
);

CREATE TABLE memberships (
    membership_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    room_id INT,
    start_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);


CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(100)
);

CREATE TABLE trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(50),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE workout_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    trainer_id INT,
    instructions VARCHAR(255),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_date DATE,
    appointment_time TIME,
    trainer_id INT,
    member_id INT,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
 

INSERT INTO FitnessManagement.members (first_name, last_name, gender, date_of_birth, phone_number)
VALUES ('Alex', 'Johnson', 'Male', '1990-07-15', '1234567890');


SELECT * FROM FitnessManagement.departments;


SELECT * FROM FitnessManagement.members
ORDER BY date_of_birth ASC;


SELECT DISTINCT gender FROM FitnessManagement.members;


SELECT * FROM FitnessManagement.trainers
LIMIT 3;


SELECT * FROM FitnessManagement.members
WHERE date_of_birth > '2000-01-01';


SELECT * FROM FitnessManagement.trainers
WHERE department_id IN (
    SELECT department_id FROM FitnessManagement.departments
    WHERE department_name IN ('Musculation', 'Cardio')
);


SELECT * FROM FitnessManagement.memberships
WHERE start_date BETWEEN '2024-12-01' AND '2024-12-07';


SELECT *,
  CASE
    WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 18 THEN 'Junior'
    WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 18 AND 60 THEN 'Adulte'
    ELSE 'Senior'
  END AS age_category
FROM FitnessManagement.members;


SELECT COUNT(*) AS total_appointments FROM FitnessManagement.appointments;


SELECT department_id, COUNT(*) AS num_trainers
FROM FitnessManagement.trainers
GROUP BY department_id;


SELECT AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())) AS avg_age
FROM FitnessManagement.members;


SELECT MAX(appointment_date) AS last_appointment_date,
       MAX(appointment_time) AS last_appointment_time
FROM FitnessManagement.appointments;


SELECT room_id, COUNT(*) AS total_memberships
FROM FitnessManagement.memberships
GROUP BY room_id;


SELECT * FROM FitnessManagement.members
WHERE email IS NULL OR email = '';


SELECT a.appointment_date, a.appointment_time,
       t.first_name AS trainer_name, m.first_name AS member_name
FROM FitnessManagement.appointments a
JOIN FitnessManagement.trainers t ON a.trainer_id = t.trainer_id
JOIN FitnessManagement.members m ON a.member_id = m.member_id;


DELETE FROM FitnessManagement.appointments
WHERE appointment_date < '2024-01-01';

UPDATE FitnessManagement.departments
SET department_name = 'Force et Conditionnement'
WHERE department_name = 'Musculation';


SELECT gender, COUNT(*) AS num_members
FROM FitnessManagement.members
GROUP BY gender
HAVING num_members >= 2;


CREATE VIEW ActiveMemberships AS
SELECT *
FROM FitnessManagement.memberships
WHERE start_date <= CURDATE();