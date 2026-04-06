-- =============================================================
-- GradeBook Database: tasks.sql
-- Task 4: Compute average/highest/lowest score of an assignment
-- Task 5: List all students in a given course
-- Updated from final_commands.txt
-- =============================================================

USE GradeBookDB;

-- =============================================================
-- TASK 4: Compute average, highest, lowest score for an assignment
-- =============================================================

-- Example: Assignment ID = 1
SELECT
    AVG(score) AS average_score,
    MAX(score) AS highest_score,
    MIN(score) AS lowest_score
FROM Grade
WHERE assignment_id = 1;

-- Alternative with more detail (assignment title, course info)
SELECT
    a.assignment_id,
    a.title AS assignment_title,
    c.course_name,
    AVG(g.score) AS average_score,
    MAX(g.score) AS highest_score,
    MIN(g.score) AS lowest_score
FROM Grade g
JOIN Assignment a ON g.assignment_id = a.assignment_id
JOIN Course c     ON a.course_id = c.course_id
WHERE g.assignment_id = 1
GROUP BY a.assignment_id, a.title, c.course_name;


-- =============================================================
-- TASK 5: List all students enrolled in a given course
-- =============================================================

-- Example: Course ID = 1
SELECT DISTINCT
    s.student_id,
    s.first_name,
    s.last_name,
    s.email
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.course_id = 1
ORDER BY s.last_name, s.first_name;

-- Alternative with course info
SELECT DISTINCT
    s.student_id,
    s.first_name,
    s.last_name,
    s.email,
    c.course_name,
    c.semester,
    c.year
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c     ON e.course_id = c.course_id
WHERE e.course_id = 1
ORDER BY s.last_name, s.first_name;
