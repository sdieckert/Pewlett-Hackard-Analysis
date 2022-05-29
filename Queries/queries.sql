SELECT * FROM retirement_info

--Retirement eligibility
SELECT first_name, last_name, birth_date
FROM employees
where birth_date BETWEEN '1952-01-01' AND '1952-12-31'

SELECT first_name, last_name, birth_date
FROM employees
where birth_date BETWEEN '1953-01-01' AND '1953-12-31'

SELECT first_name, last_name, birth_date
FROM employees
where birth_date BETWEEN '1954-01-01' AND '1954-12-31'

SELECT first_name, last_name, birth_date
FROM employees
where birth_date BETWEEN '1955-01-01' AND '1955-12-31'

--Retirement eligibility
SELECT first_name, last_name, birth_date, hire_date
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Number of Retirement eligibility
SELECT count(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Export list to new table 
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE retirement_info;

SELECT * FROM retirement_info;

--retirement_info to dept_emp
SELECT r.emp_no, r.first_name, r.last_name, de.to_date
FROM retirement_info as r
LEFT JOIN dept_emp as de ON r.emp_no=de.emp_no

---- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--create new retirement_info table
SELECT r.emp_no, 
	r.first_name, 
	r.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as r
LEFT JOIN dept_emp as de 
ON r.emp_no=de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT COUNT(ce.emp_no),
de.dept_no
INTO current_emp_grouped
FROM current_emp as ce
LEFT JOIN dept_emp as de ON ce.emp_no=de.emp_no
GROUP BY
de.dept_no
ORDER BY
de.dept_no;

----------------------------------------------
--7.3.5
--Employee Information

select * from employees
select * from salaries

SELECT e.emp_no
,e.last_name
,e.first_name
,e.gender
,de.to_date
,s.salary
INTO emp_info
FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no=de.emp_no
INNER JOIN salaries AS s ON e.emp_no=s.emp_no
WHERE (de.to_date = '9999-01-01')
AND (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

---------------------------
--Management Information

SELECT * from dept_manager

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
-------------------------
--Department Retirees

SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--------------------------
--Sales Employees Only
SELECT * FROM current_emp
SELECT * FROM emp_info --contains gender and salary
SELECT * FROM retirement_info --doesn't exclude employees that have left