DROP TABLE IF EXISTS company.Employee;
DROP TABLE IF EXISTS company.Department;
DROP TABLE IF EXISTS company.Dept_locations;
DROP TABLE IF EXISTS company.Project;
DROP TABLE IF EXISTS company.Works_on;
DROP TABLE IF EXISTS company.Dependent;

DROP SCHEMA IF EXISTS company;

CREATE SCHEMA IF NOT EXISTS company;

CREATE TABLE IF NOT EXISTS company.Employee (
	Fname TEXT,
	Minit TEXT,
	Lname TEXT,
	Ssn VARCHAR(9) PRIMARY KEY,
	Bdate DATE,
	Address VARCHAR(255),
	Sex CHAR(1),
	Salary INT,
	Super_ssn VARCHAR(9),
	Dno INT
	);

CREATE TABLE IF NOT EXISTS company.Department (
	Dname TEXT,
	Dnumber INT PRIMARY KEY,
	Mgr_ssn VARCHAR(9),
	Mgr_start_date DATE
	);
	
CREATE TABLE IF NOT EXISTS company.Dept_locations (
	Dnumber INT,
	Dlocation TEXT,
	PRIMARY KEY (Dnumber, Dlocation)
	);

CREATE TABLE IF NOT EXISTS company.Project (
	Pname TEXT,
	Pnumber INT PRIMARY KEY,
	Plocation TEXT,
	Dnum INT
	);

CREATE TABLE IF NOT EXISTS company.Works_on (
	Essn VARCHAR(9),
	Pno INT ,
	Hours REAL,
	PRIMARY KEY (Essn, Pno)
	);

CREATE TABLE IF NOT EXISTS company.Dependent (
	Essn VARCHAR(9),
	Dependent_name TEXT,
	Sex CHAR(1),
	Bdate DATE,
	Relationship TEXT,
	PRIMARY KEY (Essn, Dependent_name)
	);

INSERT INTO company.Employee (Fname,Minit,Lname,Ssn,Bdate,Address, Sex, Salary, Super_ssn, Dno)
VALUES ('John', 'B', 'Smith', '123456789', '1965-01-09', '731 Fondren, Houston, TX', 'M', 30000, '333445555', 5),
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, '888665555', 5),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321 Castle, Spring, TX', 'F', 25000, '987654321', 4),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291 Berry, Bellaire, TX', 'F', 43000, '888665555', 4),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975 Fire Oak, Humble, TX', 'M', 38000, '333445555', 5),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631 Rice, Houston, TX', 'F', 25000, '333445555', 5),
('Ahmad', 'V', 'Jabbar', '987987987', '1959-03-29', '980 Dallas, Houston, TX', 'M', 25000, '987654321', 4),
('James', 'E', 'Borg', '888665555', '1937-11-10', '450 Stone, Houston, TX', 'M', 55000, NULL, 1);


INSERT INTO company.Department (Dname, Dnumber, Mgr_ssn, Mgr_start_date)
VALUES ('Research', 5, '333445555', '1988-05-22'),
('Administration', 4, '987654321', '1995-01-01'),
('Headquarters', 1, '888665555', '1981-06-19');

INSERT INTO company.Dept_locations (Dnumber,Dlocation)
VALUES (1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

INSERT INTO company.Project (Pname, Pnumber, Plocation, Dnum)
VALUES ('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

INSERT INTO company.Works_on (Essn, Pno, Hours)
VALUES ('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 30, 5.0),
('987987987', 20, 15.0),
('987654321', 20, 20.0),
('987654321', 10, 15.0);

INSERT INTO company.Dependent (Essn, Dependent_name, Sex, Bdate, Relationship)
VALUES ('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
   ('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
   ('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
   ('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
   ('888665555', 'Michael', 'M', '1988-01-04', 'Son'),
   ('888665555', 'Elizabeth', 'F', '1967-05-05', 'Spouse');

--1
SELECT	e.Fname, e.Lname
FROM company.employee e
JOIN company.works_on w 
ON e.Ssn = w.Essn
JOIN company.project p
ON w. Pno = Pnumber
WHERE e.Dno = 5 
AND e.Salary > 3000 
AND p.Pname = 'ProductZ';

--2

SELECT e.Fname, e.Lname
FROM company.employee e
WHERE e.Address
LIKE '%Houston, TX%'
AND e.Super_ssn = '333445555';

--3

SELECT	e.Fname, e.Lname
FROM company.employee e
JOIN company.works_on w 
ON e.Ssn = w.Essn
JOIN company.project p
ON w.Pno = Pnumber
WHERE p.PNAME = 'Computerization';
