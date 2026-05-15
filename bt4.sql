CREATE DATABASE ClinicDB;
USE ClinicDB;

-- =========================
-- TẠO BẢNG
-- =========================

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100) NOT NULL
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100),
    doctor_id INT,
    appointment_date DATETIME,
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',

    FOREIGN KEY (doctor_id)
    REFERENCES Doctors(doctor_id)
);

-- =========================
-- DỮ LIỆU MẪU
-- =========================

INSERT INTO Doctors(doctor_name)
VALUES
('Nguyen Van A'),
('Tran Thi B');

-- =========================
-- TRIGGER CHỐNG TRÙNG INSERT
-- =========================

DELIMITER $$

CREATE TRIGGER trg_prevent_double_booking_insert
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN

    DECLARE booking_count INT;

    SELECT COUNT(*)
    INTO booking_count
    FROM Appointments
    WHERE doctor_id = NEW.doctor_id
        AND appointment_date = NEW.appointment_date
        AND status <> 'Cancelled';

    IF booking_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi: Bac si da co lich hen vao khung gio nay';
    END IF;

END $$

DELIMITER ;

-- =========================
-- TRIGGER CHỐNG TRÙNG UPDATE
-- =========================

DELIMITER $$

CREATE TRIGGER trg_prevent_double_booking_update
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN

    DECLARE booking_count INT;

    SELECT COUNT(*)
    INTO booking_count
    FROM Appointments
    WHERE doctor_id = NEW.doctor_id
        AND appointment_date = NEW.appointment_date
        AND status <> 'Cancelled'
        AND appointment_id <> NEW.appointment_id;

    IF booking_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi: Bac si da co lich hen vao khung gio nay';
    END IF;

END $$

DELIMITER ;