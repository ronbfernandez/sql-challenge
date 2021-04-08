-------------------------------------------------------------------------------------
--Part 1: DATA MODELING
-------------------------------------------------------------------------------------
--Inspect the CSVs and sketch out an ERD of the tables.

----Please see link to my schema: https://app.quickdatabasediagrams.com/#/d/5apW6U
--(schema diagram PNG file also available in EmployeeSQL Folder)


-------------------------------------------------------------------------------------
--Part 2: DATA ENGINEERING
-------------------------------------------------------------------------------------
--Use the information you have to create a table schema for each of the six CSV files. 
--Remember to specify data types, primary keys, foreign keys, and other constraints.
--Be sure to create tables in the correct order to handle foreign keys.
--Import each CSV file into the corresponding SQL table.


CREATE TABLE titles (
	"title_id" VARCHAR NOT NULL,
    "title" VARCHAR NOT NULL,
	PRIMARY KEY (title_id)
);

SELECT * FROM titles;

CREATE TABLE employees (
	"emp_no" INT NOT NULL,
	"emp_title_id" VARCHAR NOT NULL,
    "birth_date" DATE NOT NULL,
	"first_name" VARCHAR NOT NULL,
	"last_name" VARCHAR NOT NULL,
	"gender" VARCHAR NOT NULL,
	"hire_date" DATE NOT NULL,
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_title_id) REFERENCES titles (title_id)
);

SELECT * FROM employees;

CREATE TABLE salaries (
	"emp_no" INT NOT NULL,
    "salary" INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

SELECT * FROM salaries;

CREATE TABLE departments (
	"dept_no" VARCHAR NOT NULL,
    "dept_name" VARCHAR NOT NULL,
    PRIMARY KEY (dept_no)
);

SELECT * FROM departments;

CREATE TABLE dept_emp (
	"emp_no" INT NOT NULL,
    "dept_no" VARCHAR NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

Select * FROM dept_emp;

CREATE TABLE dept_manager (
	"dept_no" VARCHAR NOT NULL,
    "emp_no" INT NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

SELECT * FROM dept_manager;



------------------------------------------------------------------------------------------
-- Part 3: DATA ANALYSIS
------------------------------------------------------------------------------------------

--1) List the following details of each employee: employee number, last name, first name, sex, and salary.

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.gender, salaries.salary
FROM employees JOIN salaries ON employees.emp_no = salaries.emp_no;

--2) List first name, last name, and hire date for employees who were hired in 1986.

SELECT first_name, last_name, hire_date
FROM employees WHERE hire_date BETWEEN '1986-01-01' AND '1987-01-01';

--3) List the manager of each department with the following information: department number, department name, 
-- the manager's employee number, last name, first name.

SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM departments 
JOIN dept_manager ON departments.dept_no = dept_manager.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no;

--4) List the department of each employee with the following information: employee number, last name, first name, and department name.

SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no;

--5) List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."

SELECT first_name, last_name, gender
FROM employees WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--6) List all employees in the Sales department, including their employee number, last name, first name, and department name.

SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

--7) List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' OR departments.dept_name = 'Development';

--8) In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT last_name,
COUNT(last_name) AS "frequency"
FROM employees GROUP BY last_name 
ORDER BY COUNT(last_name) DESC;


