-- Step 1: Import tables from Excel

CREATE TYPE gender_enum AS ENUM ('M', 'F')

CREATE TABLE employees (emp_no int PRIMARY KEY,
			birth_date date,
			first_name varchar (14),
			last_name varchar (16),
			gender gender_enum,
			hire_date date)
			
drop table employees

select * from employees

CREATE TABLE dept_manager (dept_no CHAR(4),
			emp_no int,
			from_date date,
			to_date date,
			PRIMARY KEY (dept_no, emp_no),
			FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
			FOREIGN KEY (dept_no) REFERENCES departments(dept_no))

select * from dept_manager

CREATE TABLE departments (dept_no CHAR(4) PRIMARY KEY,
			dept_name varchar(40))

select * from departments

CREATE TABLE dept_emp (emp_no int,
			dept_no CHAR(4),
			from_date date,
			to_date date,
			PRIMARY KEY (emp_no, dept_no),
			FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
			FOREIGN KEY (dept_no) REFERENCES departments(dept_no))

select* from dept_emp

CREATE TABLE salaries (emp_no int,
			salary int,
			from_date date,
			to_date date,
			PRIMARY KEY (emp_no, from_date),
			FOREIGN KEY (emp_no) REFERENCES employees(emp_no))

select * from salaries

CREATE TABLE titles(emp_no int,
			title varchar(50),
			from_date date,
			to_date date,
			PRIMARY KEY (emp_no, title, from_date),
			FOREIGN KEY (emp_no) REFERENCES employees(emp_no))

select * from titles
			
			
DROP TABLE dept_manager
select * from dept_manager

-- Step 2: Join the rest of the tables with 'employees' table
-- First, let's create a new Employees table

CREATE TABLE employees_1 AS (select * from employees)

SELECT * FROM employees_1
LEFT JOIN dept_manager ON employees_1.emp_no = dept_manager.emp_no
LEFT JOIN departments ON 


-- Analysis Questions:
-- 1. Retrieve the first name and last name of all employees
SELECT first_name, last_name from employees

-- 2. Find the department numbers and names
SELECT * FROM departments

-- 3. Get the total number of employees
SELECT count(*) AS total_employees FROM employees

-- 4. Find the average salary of employees
SELECT AVG(salary) AS Average_Salary FROM salaries

-- 5. Retrieve the birthdate and hiredate of the employee with emp_no 10003
SELECT emp_no, first_name, last_name, birth_date, hire_date FROM employees
WHERE emp_no = 10003

-- 6. Find the titles of all employees
SELECT first_name, last_name, title FROM titles
LEFT JOIN employees ON titles.emp_no = employees.emp_no

-- 7 Get the total number of departments
SELECT Count (*) AS Dept_total FROM departments

-- 8 Retrieve the department number and name where the employee with emp_no 10004 works
SELECT departments.dept_no, emp_no, dept_name FROM dept_manager
LEFT JOIN departments ON dept_manager.dept_no = departments.dept_no
WHERE emp_no = 10004

-- 9 Find the gender of the employee with emp_no 10007
SELECT first_name, last_name, emp_no, gender FROM employees
WHERE emp_no = 10007

-- 10 Get the highest salary among all employees
SELECT Max(salary) AS higest_salary FROM employees
LEFT JOIN salaries ON employees.emp_no = salaries.emp_no

-- 11 Retrieve the names of all managers along with their department names

CREATE TABLE departments_1 AS (select departments.dept_no, 
									departments.dept_name,
									dept_manager.emp_no from departments
			INNER JOIN dept_manager ON departments.dept_no = dept_manager.dept_no)
			
SELECT first_name, last_name, dept_name, title FROM titles
LEFT JOIN employees ON titles.emp_no = employees.emp_no
LEFT JOIN departments_1 ON titles.emp_no = departments_1.emp_no
WHERE title = 'Manager'

-- 12 Find the department with the highest number of employees
SELECT departments_1.dept_name, Count(dept_manager.emp_no) AS num_employees FROM dept_manager
LEFT JOIN departments_1 ON dept_manager.dept_no = departments_1.dept_no
GROUP BY departments_1.dept_name
ORDER BY num_employees Desc

-- 13 Retrieve the employee number, first name, last name, and salary of employees earning more than $60,000
SELECT employees.emp_no, first_name, last_name, salary FROM employees
LEFT JOIN salaries on employees.emp_no = salaries.emp_no
WHERE salary > 60000

-- 14 Get the average salary for each department
SELECT dept_name, AVG(salary) As Average_Salary FROM departments_1
LEFT JOIN salaries on departments_1.emp_no = salaries.emp_no
GROUP BY dept_name

--15 Retrieve the employee number, first name, last name and title of all employees who are currently managers
SELECT employees.emp_no, first_name, last_name, title FROM employees
LEFT JOIN titles ON employees.emp_no = titles.emp_no
WHERE title = 'Manager'

-- 16 Find the total number of employees in each department
SELECT dept_name, Count(emp_no) AS Total_emp_count FROM departments_1
GROUP BY dept_name

-- 17 Retrieve the department number and name where the most recently hired employee works
-- departments_1 table was already created to answer Q.11

SELECT a.dept_no, a.dept_name FROM employees e
LEFT JOIN departments_1 a ON e.emp_no = a.emp_no
ORDER BY e.hire_date DESC
LIMIT 1

-- OR
SELECT a.dept_no, a.dept_name FROM employees e
LEFT JOIN departments_1 a ON e.emp_no = a.emp_no
WHERE e.hire_date = (SELECT MAX(hire_date) FROM employees)


-- 18 Get the department number, name, and average salary for departments with more than 3 employees
SELECT dept_no, dept_name, AVG(salary) AS average_salary FROM departments_1 d
LEFT JOIN salaries s ON d.emp_no = s.emp_no
GROUP BY dept_no, dept_name
HAVING COUNT(d.emp_no) > 3

--19 Retrieve the employee number, first_name, last_name, and title of all employees hired in 2005
SELECT e.emp_no, first_name, last_name, EXTRACT (YEAR FROM hire_date) as Year, title FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
WHERE EXTRACT(YEAR FROM hire_date) = 2005

-- 20 Find the Department with the highest average salary
SELECT dept_name, AVG(salary) AS avg_salary FROM departments_1 d
LEFT JOIN salaries s ON d.emp_no = s.emp_no
GROUP BY dept_name
ORDER BY avg_salary DESC
LIMIT 1

-- 21 Retrieve the employee number, first_name, last_name and salary of employees hired before the year 2005
SELECT e.emp_no, first_name, last_name, salary, EXTRACT(YEAR FROM hire_date) as Hire_year FROM employees e
LEFT JOIN salaries s ON e.emp_no = s.emp_no
WHERE EXTRACT (YEAR FROM hire_date) < 2005

-- OR Using a sub query
SELECT emp_no, first_name, salary, hire_year
FROM (SELECT e.emp_no, first_name, last_name, salary, EXTRACT(YEAR FROM hire_date) AS hire_year FROM employees e
		LEFT JOIN salaries s ON e.emp_no = s.emp_no
		WHERE EXTRACT(YEAR FROM hire_date) < 2005)
AS Employee_info

-- 22 Get the department number, name, and total number of employees for departments with a female manager
SELECT dept_no, dept_name, COUNT (d.emp_no) as total_emp_count FROM departments_1 d
LEFT JOIN employees e ON d.emp_no = e.emp_no
LEFT JOIN titles t ON e.emp_no = t.emp_no
WHERE gender= 'F' AND title = 'Manager'
GROUP BY dept_no, dept_name

-- 23 Retrieve the employee number, first_name, last_name and department name of employees who are currently working in the finance dept
SELECT d.emp_no, first_name, last_name, dept_name FROM departments_1 d
JOIN employees e ON d.emp_no = e.emp_no
WHERE dept_name = 'Finance'

-- 24 Find the employee with the highest salary in each department
SELECT first_name, last_name, d.dept_name, salary FROM employees e
JOIN departments_1 d ON e.emp_no = d.emp_no
JOIN salaries s ON d.emp_no = s.emp_no
JOIN (
SELECT dept_name, MAX(salary) AS highest_salary 
FROM employees e  
JOIN departments_1 d ON e.emp_no = d.emp_no
JOIN salaries s ON d.emp_no = s.emp_no
GROUP BY d.dept_name) AS dept_max_sal 
ON d.dept_name = dept_max_sal.dept_name AND salary = dept_max_sal.highest_salary
ORDER BY salary DESC


-- 25 Retrieve the employee number, first name, last name, and department name of employees who have held a managerial position
SELECT e.emp_no, first_name, last_name, dept_name, title FROM employees e
JOIN departments_1 d on e.emp_no = d.emp_no
JOIN titles t on d.emp_no = t.emp_no
WHERE title = 'Manager'

-- 26 Get the total number of employees who have held the title "Senior Manager"
SELECT count(e.emp_no) AS num_employees FROM employees e
JOIN titles t on e.emp_no = t.emp_no
WHERE title = 'Senior Manager'

-- 27 Retrieve the department number, name, and the number of employees who have worked there for more than 5 years
SELECT dept_no, dept_name, COUNT(e.emp_no) AS num_employees FROM departments_1 d
JOIN employees e ON d.emp_no = e.emp_no
WHERE hire_date <= CURRENT_DATE - INTERVAL '5 years'
GROUP BY dept_no, dept_name

-- 28 Find the employee with the longest tenure in the company
SELECT emp_no, first_name, last_name, CURRENT_DATE - hire_date AS tenure FROM employees
ORDER BY tenure DESC
LIMIT 1

-- 29 Retrieve the employee number, first name, last name, and title of employees whose hire date is between '2005-01-01' and '2006-01-01'
SELECT e.emp_no, first_name, last_name, title, hire_date FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
WHERE hire_date BETWEEN '2005-01-01' AND '2006-01-01'

-- 30 Get the department number, name, and the oldest employee's birth date for each department
SELECT dept_no, dept_name, birth_date FROM employees e
JOIN departments_1 d ON e.emp_no = d.emp_no
ORDER BY birth_date ASC
LIMIT 1