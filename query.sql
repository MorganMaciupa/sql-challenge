-- 1. List the following details of each employee: 
-- employee number, last name, first name, sex, and salary.
COPY
	(SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
	FROM employees AS e
	INNER JOIN salaries AS s ON
	e.emp_no = s.emp_no)
TO '/tmp/question1.csv' WITH csv DELIMITER ',' HEADER

-- 2. List first name, last name, and hire date for employees who were hired in 1986.
COPY
	(SELECT first_name, last_name, hire_date
	FROM employees
	WHERE hire_date LIKE '%/1986')
TO '/tmp/question2.csv' WITH csv DELIMITER ',' HEADER

-- 3. List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, last name, first name.
COPY
	(SELECT
		d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
	FROM	
		departments AS d
		INNER JOIN dept_manager AS dm ON
		d.dept_no = dm.dept_no
		INNER JOIN employees AS e ON
		dm.emp_no = e.emp_no) 
TO '/tmp/question3.csv' WITH csv DELIMITER ',' HEADER

-- 4. List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.
CREATE VIEW employee_department AS
	SELECT
		de.emp_no, e.last_name, e.first_name, d.dept_name
	FROM	
		departments as d
		inner join dept_emp as de on
		d.dept_no = de.dept_no
		inner join employees as e on
		de.emp_no = e.emp_no

COPY (SELECT * FROM employee_department) TO '/tmp/question4.csv' with csv DELIMITER ',' HEADER

-- 5. List first name, last name, and sex for employees whose first name is 
-- "Hercules" and last names begin with "B."
COPY
	(SELECT first_name, last_name, sex
	FROM employees
	WHERE first_name = 'Hercules' AND last_name LIKE 'B%') 
TO '/tmp/question5.csv' WITH csv DELIMITER ',' HEADER

--6. List all employees in the Sales department, including their: 
-- employee number, last name, first name, and department name
COPY
	(SELECT * FROM employee_department
	WHERE dept_name = 'Sales') 
TO '/tmp/question6.csv' WITH csv DELIMITER ',' HEADER

-- 7. List all employees in the Sales and Development departments, including their
-- employee number, last name, first name, and department name.
COPY
	(SELECT * FROM employee_department
	WHERE dept_name = 'Sales' OR dept_name = 'Development') 
TO '/tmp/question7.csv' WITH csv DELIMITER ',' HEADER

-- 8. In descending order, list the frequency count of employee last names, 
-- i.e., how many employees share each last name.
COPY
	(SELECT last_name, count(last_name) AS "count"
	FROM employees
	GROUP BY last_name
	ORDER BY count desc) 
TO '/tmp/question8.csv' WITH csv DELIMITER ',' HEADER

-- BONUS: 
-- Create view from query for average salary
CREATE VIEW salary_by_title AS
	SELECT t.title, AVG(s.salary) AS avg_salary
	FROM salaries AS s
	JOIN employees AS e ON (e.emp_no = s.emp_no)
	JOIN titles AS t ON (e.emp_title_id = t.title_id)
		GROUP BY t.title;

-- Epilogue
COPY 
	(SELECT * FROM employees
	WHERE emp_no = 499942) 
TO '/tmp/epilogue.csv' WITH csv DELIMITER ',' HEADER
