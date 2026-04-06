-- =============================================================
-- GradeBook Database: schema.sql
-- Task 2: Commands for creating tables (updated from final_commands.txt)
-- =============================================================

CREATE DATABASE IF NOT EXISTS GradeBookDB;
USE GradeBookDB;

-- Safe reset for reruns (uncomment if needed)
-- SET FOREIGN_KEY_CHECKS = 0;
-- DROP TABLE IF EXISTS Grade;
-- DROP TABLE IF EXISTS Assignment;
-- DROP TABLE IF EXISTS GradeCategory;
-- DROP TABLE IF EXISTS Enrollment;
-- DROP TABLE IF EXISTS Course;
-- DROP TABLE IF EXISTS Professor;
-- DROP TABLE IF EXISTS Student;
-- SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Student (
    student_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20)  NOT NULL UNIQUE
);

CREATE TABLE Professor (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20)  NOT NULL UNIQUE
);

CREATE TABLE Course (
    course_id     INT AUTO_INCREMENT PRIMARY KEY,
    professor_id  INT          NOT NULL,
    department    VARCHAR(50)  NOT NULL,
    course_number VARCHAR(10)  NOT NULL UNIQUE,
    semester      VARCHAR(20)  NOT NULL,
    year          INT          NOT NULL,
    course_name   VARCHAR(100) NOT NULL,
    CONSTRAINT fk_course_professor
        FOREIGN KEY (professor_id) REFERENCES Professor(professor_id)
);

CREATE TABLE Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id    INT NOT NULL,
    course_id     INT NOT NULL,
        enrollment_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id) REFERENCES Course(course_id),
    CONSTRAINT uq_student_course UNIQUE (student_id, course_id)
);

CREATE TABLE GradeCategory (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id   INT          NOT NULL,
    name        VARCHAR(50)  NOT NULL,
    weight      DECIMAL(5,2) NOT NULL,
    CONSTRAINT fk_category_course
        FOREIGN KEY (course_id) REFERENCES Course(course_id),
    CONSTRAINT uq_course_category UNIQUE (course_id, name)
);

CREATE TABLE Assignment (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id     INT          NOT NULL,
    category_id   INT          NOT NULL,
    title         VARCHAR(100) NOT NULL,
    description   TEXT,
        max_score       DECIMAL(5,2) NOT NULL DEFAULT 100.00,
        due_date        DATE,
        assigned_date   DATE,
    CONSTRAINT fk_assignment_course
        FOREIGN KEY (course_id) REFERENCES Course(course_id),
    CONSTRAINT fk_assignment_category
        FOREIGN KEY (category_id) REFERENCES GradeCategory(category_id),
    CONSTRAINT uq_course_assignment UNIQUE (course_id, title)
);

CREATE TABLE Grade (
    grade_id      INT AUTO_INCREMENT PRIMARY KEY,
    student_id    INT          NOT NULL,
    assignment_id INT          NOT NULL,
    score         DECIMAL(5,2) NOT NULL,
    comments      TEXT,
        graded_date     DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_grade_student
        FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_grade_assignment
        FOREIGN KEY (assignment_id) REFERENCES Assignment(assignment_id),
    CONSTRAINT uq_student_assignment UNIQUE (student_id, assignment_id)
);
