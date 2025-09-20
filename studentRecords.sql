-- student_records_schema.sql
-- Complete relational schema for a Student Records Management System (MySQL / InnoDB)
-- Includes CREATE DATABASE, CREATE TABLE, constraints, relationships (1:1, 1:N, M:N)

CREATE DATABASE IF NOT EXISTS `student_records` CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
USE `student_records`;

-- -----------------------------------------------------------------------------
-- Entities: Students, Courses, Departments, Instructors, Enrollments, Grades
-- -----------------------------------------------------------------------------

-- Departments
CREATE TABLE IF NOT EXISTS departments (
  dept_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL UNIQUE,
  office_location VARCHAR(100),
  phone VARCHAR(50),
  PRIMARY KEY (dept_id)
) ENGINE=InnoDB;

-- Instructors
CREATE TABLE IF NOT EXISTS instructors (
  instructor_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  dept_id INT UNSIGNED NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  hire_date DATE NOT NULL,
  PRIMARY KEY (instructor_id),
  INDEX idx_instructors_dept (dept_id),
  CONSTRAINT fk_instructors_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Students
CREATE TABLE IF NOT EXISTS students (
  student_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  dept_id INT UNSIGNED NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(50),
  enrollment_year YEAR NOT NULL,
  PRIMARY KEY (student_id),
  INDEX idx_students_dept (dept_id),
  CONSTRAINT fk_students_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Courses
CREATE TABLE IF NOT EXISTS courses (
  course_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  dept_id INT UNSIGNED NOT NULL,
  course_code VARCHAR(20) NOT NULL UNIQUE,
  title VARCHAR(255) NOT NULL,
  credits TINYINT UNSIGNED NOT NULL CHECK (credits > 0 AND credits <= 10),
  PRIMARY KEY (course_id),
  INDEX idx_courses_dept (dept_id),
  CONSTRAINT fk_courses_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Course Instructors (Many-to-Many: A course may have multiple instructors)
CREATE TABLE IF NOT EXISTS course_instructors (
  course_id INT UNSIGNED NOT NULL,
  instructor_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (course_id, instructor_id),
  CONSTRAINT fk_ci_course FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ci_instructor FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Enrollments (Many-to-Many: Students <-> Courses)
CREATE TABLE IF NOT EXISTS enrollments (
  enrollment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id INT UNSIGNED NOT NULL,
  course_id INT UNSIGNED NOT NULL,
  semester ENUM('Spring','Summer','Fall','Winter') NOT NULL,
  year YEAR NOT NULL,
  enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (enrollment_id),
  UNIQUE KEY ux_student_course (student_id, course_id, semester, year),
  INDEX idx_enrollments_student (student_id),
  INDEX idx_enrollments_course (course_id),
  CONSTRAINT fk_enrollments_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_enrollments_course FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Grades (One per enrollment)
CREATE TABLE IF NOT EXISTS grades (
  grade_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  enrollment_id BIGINT UNSIGNED NOT NULL,
  grade CHAR(2) CHECK (grade IN ('A','B','C','D','F','I','W')),
  graded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (grade_id),
  UNIQUE KEY ux_grades_enrollment (enrollment_id),
  CONSTRAINT fk_grades_enrollment FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Attendance (per student per course)
CREATE TABLE IF NOT EXISTS attendance (
  attendance_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  enrollment_id BIGINT UNSIGNED NOT NULL,
  attendance_date DATE NOT NULL,
  status ENUM('Present','Absent','Late','Excused') NOT NULL DEFAULT 'Present',
  PRIMARY KEY (attendance_id),
  INDEX idx_attendance_enrollment (enrollment_id),
  CONSTRAINT fk_attendance_enrollment FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Library Records (optional, for student borrowings)
CREATE TABLE IF NOT EXISTS library_records (
  record_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id INT UNSIGNED NOT NULL,
  book_title VARCHAR(255) NOT NULL,
  borrow_date DATE NOT NULL,
  return_date DATE DEFAULT NULL,
  PRIMARY KEY (record_id),
  INDEX idx_library_student (student_id),
  CONSTRAINT fk_library_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- Example indexes for performance
-- -----------------------------------------------------------------------------
ALTER TABLE students ADD INDEX idx_students_name (last_name, first_name);
ALTER TABLE courses ADD INDEX idx_courses_title (title(100));
ALTER TABLE enrollments ADD INDEX idx_enrollments_year_sem (year, semester);

-- -----------------------------------------------------------------------------
-- Example seed data for departments
-- -----------------------------------------------------------------------------
INSERT IGNORE INTO departments (dept_id, name, office_location, phone) VALUES
  (1, 'Computer Science', 'Building A, Room 101', '123-456-7890'),
  (2, 'Mathematics', 'Building B, Room 202', '234-567-8901'),
  (3, 'Physics', 'Building C, Room 303', '345-678-9012');

-- End of file
