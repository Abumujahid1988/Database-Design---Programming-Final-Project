#### README-Student Records Database Schema

================================



Overview

--------

This project provides a MySQL relational database schema for managing student records.

It includes entities such as Departments, Students, Instructors, Courses, Enrollments, 

Grades, Attendance, and Library Records.



The schema enforces data integrity using:

\- Primary Keys

\- Foreign Keys

\- Unique Constraints

\- Check Constraints

\- Indexes



Files

-----

\- student\_records\_schema.sql → Contains all SQL statements to create the database, 

&nbsp; tables, constraints, relationships, and sample seed data.



Schema Entities

---------------

1\. Departments → Academic departments

2\. Students → Student personal \& academic info

3\. Instructors → Faculty members belonging to departments

4\. Courses → Courses offered under departments

5\. Course Instructors → Many-to-Many mapping between courses \& instructors

6\. Enrollments → Student registrations for courses (per semester/year)

7\. Grades → Linked to enrollments (One-to-One)

8\. Attendance → Daily tracking per student per course

9\. Library Records (Optional) → Tracks student book borrowings



Relationships

-------------

\- Departments → Students / Instructors / Courses (1:N)

\- Students ↔ Courses (M:N via Enrollments)

\- Courses ↔ Instructors (M:N via Course Instructors)

\- Enrollments → Grades (1:1)

\- Enrollments → Attendance (1:N)

\- Students → Library Records (1:N)



How to Run the Schema

---------------------

Option 1: MySQL Command Line

&nbsp; mysql -u root -p < student\_records\_schema.sql



Or login first, then:

&nbsp; SOURCE /path/to/student\_records\_schema.sql;



Option 2: MySQL Workbench

1\. Open MySQL Workbench

2\. Connect to your server

3\. Open student\_records\_schema.sql

4\. Run the script (⚡ button)



Verification

------------

After execution:

&nbsp; SHOW DATABASES;

&nbsp; USE student\_records;

&nbsp; SHOW TABLES;



Example Seed Data

-----------------

The schema includes departments by default:

\- Computer Science

\- Mathematics

\- Physics

