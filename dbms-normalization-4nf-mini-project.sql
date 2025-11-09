CREATE TABLE Student_UNF (
    StudentID INT,
    StudentName VARCHAR(50),
    Subjects VARCHAR(100),
    Marks VARCHAR(50),
    Hobbies VARCHAR(100)
);

INSERT INTO Student_UNF VALUES
(101, 'Aman', 'DBMS, Java, OS', '85,78,90', 'Reading, Cricket'),
(102, 'Simran', 'DBMS, Python', '88,95', 'Music, Painting'),
(103, 'Rohit', 'OS, DBMS', '75,82', 'Cricket, Coding');

SELECT * FROM Student_UNF;


-- -------------------------------------------------------
-- 1NF (First Normal Form)
-- -------------------------------------------------------
-- Rule: Remove repeating groups; each field should hold atomic values

CREATE TABLE Student_1NF (
    StudentID INT,
    StudentName VARCHAR(50),
    Subject VARCHAR(50),
    Marks INT,
    Hobby VARCHAR(50)
);


INSERT INTO Student_1NF VALUES
(101, 'Aman', 'DBMS', 85, 'Reading'),
(101, 'Aman', 'Java', 78, 'Cricket'),
(101, 'Aman', 'OS', 90, 'Cricket'),
(102, 'Simran', 'DBMS', 88, 'Music'),
(102, 'Simran', 'Python', 95, 'Painting'),
(103, 'Rohit', 'OS', 75, 'Cricket'),
(103, 'Rohit', 'DBMS', 82, 'Coding');

SELECT * FROM Student_1NF;

-- -------------------------------------------------------
-- 2NF (Second Normal Form)
-- -------------------------------------------------------
-- Rule: Remove partial dependencies (data depending on part of a composite key)

-- StudentName depends only on StudentID → separate Student table

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50)
);

INSERT INTO Student VALUES
(101, 'Aman'),
(102, 'Simran'),
(103, 'Rohit');

-- Keep only dependent attributes
CREATE TABLE Marks_2NF (
    StudentID INT,
    Subject VARCHAR(50),
    Marks INT,
    PRIMARY KEY (StudentID, Subject),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

INSERT INTO Marks_2NF VALUES
(101, 'DBMS', 85),
(101, 'Java', 78),
(101, 'OS', 90),
(102, 'DBMS', 88),
(102, 'Python', 95),
(103, 'OS', 75),
(103, 'DBMS', 82);

SELECT * FROM Student;
SELECT * FROM Marks_2NF;

-- -------------------------------------------------------
-- 3NF (Third Normal Form)
-- -------------------------------------------------------
-- Rule: Remove transitive dependencies (non-key attributes depending on another non-key)

-- Suppose Subject → Instructor (each subject has a fixed instructor)
CREATE TABLE Subject (
    Subject VARCHAR(50) PRIMARY KEY,
    Instructor VARCHAR(50)
);

INSERT INTO Subject VALUES
('DBMS', 'Dr. Mehta'),
('Java', 'Mr. Raj'),
('OS', 'Mrs. Kaur'),
('Python', 'Dr. Sharma');

-- Updated Marks table with foreign key
CREATE TABLE Marks_3NF (
    StudentID INT,
    Subject VARCHAR(50),
    Marks INT,
    PRIMARY KEY (StudentID, Subject),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (Subject) REFERENCES Subject(Subject)
);

INSERT INTO Marks_3NF SELECT * FROM Marks_2NF;

SELECT * FROM Student;
SELECT * FROM Subject;
SELECT * FROM Marks_3NF;


-- -------------------------------------------------------
-- BCNF (Boyce-Codd Normal Form)
-- -------------------------------------------------------
-- Rule: Every determinant must be a candidate key.

-- Suppose Instructor teaches multiple subjects, Instructor → Subject creates dependency
-- Separate Instructor table and Instructor_Subject relation

CREATE TABLE Instructor (
    Instructor VARCHAR(50) PRIMARY KEY,
    Department VARCHAR(50)
);

INSERT INTO Instructor VALUES
('Dr. Mehta', 'Computer Science'),
('Mr. Raj', 'Computer Science'),
('Mrs. Kaur', 'Information Technology'),
('Dr. Sharma', 'Computer Applications');

CREATE TABLE Instructor_Subject (
    Instructor VARCHAR(50),
    Subject VARCHAR(50),
    PRIMARY KEY (Instructor, Subject),
    FOREIGN KEY (Instructor) REFERENCES Instructor(Instructor),
    FOREIGN KEY (Subject) REFERENCES Subject(Subject)
);

INSERT INTO Instructor_Subject SELECT Instructor, Subject FROM Subject;

SELECT * FROM Instructor;
SELECT * FROM Instructor_Subject;


-- -------------------------------------------------------
-- 4NF (Fourth Normal Form)
-- -------------------------------------------------------
-- Rule: Remove multi-valued dependencies
-- Example: A student can have multiple hobbies independent of subjects

-- Create a separate Hobbies table to eliminate multi-valued dependency

CREATE TABLE Hobbies_4NF (
    StudentID INT,
    Hobby VARCHAR(50),
    PRIMARY KEY (StudentID, Hobby),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

INSERT INTO Hobbies_4NF VALUES
(101, 'Reading'),
(101, 'Cricket'),
(102, 'Music'),
(102, 'Painting'),
(103, 'Cricket'),
(103, 'Coding');

SELECT * FROM Hobbies_4NF;

-- -------------------------------------------------------
-- ✅ Normalization Completed
-- -------------------------------------------------------
-- UNF → 1NF → 2NF → 3NF → BCNF → 4NF
-- Redundancy removed, transitive and multi-valued dependencies eliminated
-- Database is now fully normalized and optimized