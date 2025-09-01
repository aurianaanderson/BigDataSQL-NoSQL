DROP TABLE IF EXISTS university.Student CASCADE;
DROP TABLE IF EXISTS university.Course CASCADE;
DROP TABLE IF EXISTS university.Section CASCADE;
DROP TABLE IF EXISTS university.Grade_report CASCADE;


DROP SCHEMA IF EXISTS university CASCADE;

CREATE SCHEMA IF NOT EXISTS university;

CREATE TABLE IF NOT EXISTS university.Student (
	Name TEXT,
	Student_number INT PRIMARY KEY,
	Class INT,
	Major TEXT
	);

CREATE TABLE IF NOT EXISTS university.Course (
	Course_name TEXT,
	Course_number VARCHAR PRIMARY KEY,
	Credit_hours int,
	Department TEXT
	);
	
CREATE TABLE IF NOT EXISTS university.Section (
	Section_identifier INT PRIMARY KEY,
	Course_number VARCHAR,
	Semester TEXT,
	Year INT,
	Instructor TEXT,
	FOREIGN KEY (Course_number) REFERENCES university.Course(Course_number)
	);

CREATE TABLE IF NOT EXISTS university.Grade_report (
	Student_number INT,
	Section_identifier INT,
	Grade TEXT,
	PRIMARY KEY (Student_number, Section_identifier), 
	FOREIGN KEY (Student_number) REFERENCES university.Student(Student_number),
	FOREIGN KEY (Section_identifier) REFERENCES university.Section(Section_identifier)
	);

CREATE TABLE IF NOT EXISTS university.Prerequisite (
	Course_number VARCHAR,
	Prerequisite_number VARCHAR,
	PRIMARY KEY (Course_number, Prerequisite_number),
	FOREIGN KEY (Prerequisite_number) REFERENCES university.Course(Course_number),
	FOREIGN KEY (Course_number) REFERENCES university.Course(Course_number)
	);

INSERT INTO university.Student (Name, Student_number, Class, Major)
VALUES ('Smith', 17, 1, 'CS'),
('Brown', 8, 2, 'CS');


INSERT INTO university.Course (Course_name, Course_number, Credit_hours, Department)
VALUES ('Intro to Computer Science', 'CS1310', 4, 'CS'),
('Data Structures', 'CS3320', 4, 'CS'),
('Discrete Mathematics', 'MATH2410', 3, 'MATH'),
('Database', 'CS3380', 3, 'CS');

INSERT INTO university.Section (Section_identifier, Course_number, Semester, Year, Instructor)
VALUES (85, 'MATH2410', 'Fall', 2007, 'King'),
(92, 'CS1310', 'Fall', 2007, 'Anderson'),
(102, 'CS3320', 'Spring', 2008, 'Knuth'),
(112, 'MATH2410', 'Fall', 2008, 'Chang'),
(119, 'CS1310', 'Fall', 2008, 'Anderson'),
(135, 'CS3380', 'Fall', 2008, 'Stone');

INSERT INTO university.Grade_report (Student_number, Section_identifier, Grade)
VALUES (17, 112, 'B'),
(17, 119, 'C'),
(8, 85, 'A'),
(8, 92, 'A'),
(8, 102, 'B'),
(8, 135, 'A');

INSERT INTO university.Prerequisite (Course_number, Prerequisite_number)
VALUES ('CS3380', 'CS3320'),
('CS3380', 'MATH2410'),
('CS3320', 'CS1310');

--1
SELECT Course_name
FROM university.Course
WHERE Department = 'CS';

--2

SELECT c.Course_name, s.Instructor
FROM university.Course c
JOIN university.Section s
ON c.Course_number = s.Course_number
WHERE s.Semester = 'Fall' AND s.Year = 2008;

--3

SELECT S.Course_number, s.Semester, s.Year, 
	COUNT(g.Student_number) AS number_of_students
FROM university.Section s
JOIN university.Grade_report g
ON s.Section_identifier = g.Section_identifier
WHERE s.Instructor = 'Anderson'
GROUP BY s.Course_number,s.Semester, s.Year;

--4
SELECT stu.Name, s.Semester, s.Year, g.Grade, c.Credit_hours, c.Course_name, c.Course_number
FROM university.Student stu
JOIN university.Grade_report g
ON stu.Student_number = g.Student_number
JOIN university.Section s
ON g.Section_identifier =s.Section_identifier
JOIN university.Course c
ON s.Course_number = c.Course_number
WHERE stu.Class = 1 AND STU.mAJOR = 'MATH';

---6.13--5

INSERT INTO university.Course (Course_name, Course_number, Credit_hours, Department)
VALUES ('Financial Accounting', 'fac4390',5,'BUSINESS');
--6
INSERT INTO university.Section (Section_identifier, Course_number, Semester, Year, Instructor)
VALUES (145, 'fac4390', 'Fall', 17, 'Hanif');
--7
INSERT INTO university.Student (Name, Student_number, Class, Major)
VALUES ('Robin', 34, 2, 'BUSINESS');


--8

UPDATE university.STUDENT
SET  Class = 3
WHERE Student_number = 17;