-- =============================================================
-- GradeBook Database: seed.sql
-- Task 2: INSERT values / Task 3: SELECT * to show table contents
-- Updated from final_commands.txt with 200 students, 20 courses
-- =============================================================

USE GradeBookDB;

-- NOTE: This file contains a subset of seed data for demonstration.
-- For the FULL dataset with 200 students and all enrollments,
-- refer to final_commands.txt in the root directory.

-- ===========================
-- INSERT SAMPLE DATA (subset)
-- ===========================

-- Insert 20 Courses
INSERT INTO Course (professor_id, department, course_number, semester, year, course_name) VALUES
(1,  'Mathematics',      'MATH201', 'Fall',   2025, 'Calculus I'),
(2,  'Mathematics',      'MATH202', 'Spring', 2025, 'Linear Algebra'),
(3,  'Biology',          'BIO110',  'Fall',   2025, 'General Biology I'),
(4,  'Chemistry',        'CHEM101', 'Fall',   2025, 'General Chemistry I'),
(5,  'Computer Science', 'CS101',   'Fall',   2025, 'Introduction to Programming');
-- (15 more courses in final_commands.txt)

-- Insert 20 Professors 
INSERT INTO Professor (first_name, last_name, email, phone_number) VALUES
('Alma',  'Bennett',  'alma.bennett@college.edu',  '301-555-2001'),
('Bruce', 'Carson',   'bruce.carson@college.edu',  '301-555-2002'),
('Cynthia', 'Donovan', 'cynthia.donovan@college.edu', '301-555-2003');
-- (17 more professors in final_commands.txt)

-- Insert 200 Students
INSERT INTO Student (first_name, last_name, email, phone_number) VALUES
('Aaron',   'Allen',  'aaron.allen1@studentmail.edu',  '202-555-1001'),
('Aaliyah', 'Baker',  'aaliyah.baker2@studentmail.edu','202-555-1002'),
('Adrian',  'Brooks', 'adrian.brooks3@studentmail.edu','202-555-1003');
-- (197 more students in final_commands.txt)

-- Insert 200 Enrollments (10 students per course)
-- Using recursive CTE for batch inserts
INSERT INTO Enrollment (student_id, course_id)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 200
)
SELECT
    n AS student_id,
    CEILING(n / 10) AS course_id
FROM seq;

-- Insert GradeCategories (4 categories per course, 80 total)
INSERT INTO GradeCategory (course_id, name, weight)
SELECT c.course_id, cat.name, cat.weight
FROM Course c
CROSS JOIN (
    SELECT 'Participation' AS name, 10.00 AS weight
    UNION ALL SELECT 'Homework',     25.00
    UNION ALL SELECT 'Midterm Exam', 30.00
    UNION ALL SELECT 'Final Project', 35.00
) AS cat
ORDER BY c.course_id;

-- Insert Assignments (4 per course, 80 total)
INSERT INTO Assignment (course_id, category_id, title, description)
SELECT
    gc.course_id,
    gc.category_id,
    CASE gc.name
        WHEN 'Participation' THEN 'Class Participation'
        WHEN 'Homework'      THEN 'Homework Set 1'
        WHEN 'Midterm Exam'  THEN 'Midterm Exam'
        WHEN 'Final Project' THEN 'Final Project'
    END AS title,
    CASE gc.name
        WHEN 'Participation' THEN 'Participation grade based on attendance and engagement.'
        WHEN 'Homework'      THEN 'Homework covering core concepts.'
        WHEN 'Midterm Exam'  THEN 'Midterm assessment covering first half of course.'
        WHEN 'Final Project' THEN 'Final project requiring research and presentation.'
    END AS description
FROM GradeCategory gc
ORDER BY gc.course_id, gc.category_id;

-- Insert Grades (800 total: 200 students × 4 assignments)
INSERT INTO Grade (student_id, assignment_id, score, comments)
SELECT
    e.student_id,
    a.assignment_id,
    ROUND(
        CASE gc.name
            WHEN 'Participation' THEN 80 + MOD(e.student_id + a.assignment_id, 16)
            WHEN 'Homework'      THEN 75 + MOD(e.student_id + a.assignment_id, 18)
            WHEN 'Midterm Exam'  THEN 70 + MOD(e.student_id + a.assignment_id, 21)
            WHEN 'Final Project' THEN 78 + MOD(e.student_id + a.assignment_id, 17)
        END, 2
    ) AS score,
    CONCAT(gc.name, ' grade recorded.') AS comments
FROM Enrollment e
JOIN Assignment a ON e.course_id = a.course_id
JOIN GradeCategory gc ON a.category_id = gc.category_id
ORDER BY e.student_id, a.assignment_id;

-- ===========================
-- Task 3: SHOW TABLE CONTENTS
-- ===========================

SELECT * FROM Student   LIMIT 10;
SELECT * FROM Professor LIMIT 10;
SELECT * FROM Course    LIMIT 10;
SELECT * FROM Enrollment LIMIT 10;
SELECT * FROM GradeCategory LIMIT 10;
SELECT * FROM Assignment LIMIT 10;
SELECT * FROM Grade LIMIT 10;

-- Verification queries
SELECT COUNT(*) AS total_students        FROM Student;
SELECT COUNT(*) AS total_professors      FROM Professor;
SELECT COUNT(*) AS total_courses         FROM Course;
SELECT COUNT(*) AS total_enrollments     FROM Enrollment;
SELECT COUNT(*) AS total_grade_categories FROM GradeCategory;
SELECT COUNT(*) AS total_assignments     FROM Assignment;
SELECT COUNT(*) AS total_grades          FROM Grade;
