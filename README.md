# Pewlett-Hackard-Analysis
## Project Overview
Using SQL to query the csv files, determine the number of retiring employees per title, and identify employees who are eligible to participate in a mentorship program

## Resources
- Data Source: employees.csv, departments.csv, dept_emp.csv, dept_manager.csv, salaries.csv
titles.csv
- Software: PostgreSQL

## Challenge Overview
This assignment consists of two technical analysis deliverables and a written report. 
Deliverable 1: The Number of Retiring Employees by Title
Deliverable 2: The Employees Eligible for the Mentorship Program
Deliverable 3: A written report on the employee database analysis (README.md)

## Results

### Deliverable 1: The Number of Retiring Employees by Title

1. Query to Create Retirement Titles for employees who are born between January 1, 1952 and December 31, 1955.

--Create a csv file of employees born from 1952-1955 and their titles
Select e.emp_no
,e.first_name
,e.last_name
,et.title
,et.from_date
,et.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as et ON e.emp_no=et.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY emp_no asc;

File: Data/retirement_titles.csv

<insert 1retirement_title.png>

Summary: Creates a list of employees with the titles and dates in that position. Duplicates are created for employees that have been
in more than one title.

2. A query is written and executed to create a Unique Titles table that contains the employee number, first and last name, and most recent title.

-- Use Distinct with Order by to remove duplicate rows
SELECT DISTINCT ON (emp_no) r.emp_no,
r.first_name,
r.last_name,
r.title
INTO unique_titles
FROM retirement_titles as r
WHERE (r.to_date = '9999-01-01')
ORDER BY r.emp_no asc,
r.title desc;

File: Data/unique_titles.csv

<insert 2unique_titles.png>

Summary: Using Distinct On allows to remove duplicate rows.

3. A query is written and executed to create a Retiring Titles table that contains the number of titles filled by employees who are retiring

--Create A Retiring Titles Table
SELECT count(emp_no),
title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count(emp_no) desc;

File: Data/retiring_titles.csv

<insert 3retiring_titles.png>

Summary: Groups and counts the number of employees by title. Senior Engineer and Senior Staff have the highest number of employees retiring.

### Deliverable 2: The Employees Eligible for the Mentorship Program

1. A query is written and executed to create a Mentorship Eligibility table for current employees who were born between January 1, 1965 and December 31, 1965.

--Create a table for Mentorsip Eligibility
Select DISTINCT ON (e.emp_no) e.emp_no
,e.first_name
,e.last_name
,e.birth_date
,de.from_date
,de.to_date
,et.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no=de.emp_no
INNER JOIN titles AS et ON e.emp_no=et.emp_no
WHERE (de.to_date = '9999-01-01')
AND e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY emp_no asc;

File: Data/mentorship_elibibility.csv

<insert 4mentorship.png>

Summary: Identifies employee born in 1965, at least 10 years younger than those retiring, that are eligible to be a part of a mentor program and replace retiring employees.


## Summary
- Overall, there are 72,458 possible employees that the company needs to prepare for retiring. The majority of titles that are retiring are Senior Engineer at 36% and Senior Staff at 34%.
- Looking at the number of employees that are eligible for a mentorship, having been born in 1965 and 10-15 years younger, there's enough employees retiring that would be able to mentor this upcoming group.

### Additional Query 1

- What are the number of employees retiring by department.

--SUMMARY 1 Number of Employees to leave by Department
SELECT DISTINCT ON (emp_no) r.emp_no,
r.first_name,
r.last_name,
r.title,
d.dept_name
INTO unique_titles_dept
FROM retirement_titles AS r
INNER JOIN dept_emp AS de ON r.emp_no=de.emp_no
INNER JOIN departments AS d ON de.dept_no=d.dept_no
WHERE (r.to_date = '9999-01-01')
ORDER BY r.emp_no asc,
r.title desc;

--GROUP BY DEPARTMENT
SELECT dept_name
,count(emp_no)
FROM unique_titles_dept
GROUP BY dept_name
ORDER BY count(emp_no)desc;

<insert 5retire_department.png>

Summary: The majority of employees retiring are in the Development (27%), Production (25%), and Sales (16%) departments. Management would do best to apply efforts to hiring for these three departments to replace the loss expected.

### Additional Query 2

- Excluding the employees retiring, what's the average number of years that employees are in their current title.

--Summary 2 Average Time in Current Position EXCLUDING RETIRING STAFF

--Create a csv file of employees born after 1955 and their titles
Select e.emp_no
,e.first_name
,e.last_name
,et.title
,et.from_date
,et.to_date
INTO non_retirement_titles
FROM employees as e
INNER JOIN titles as et ON e.emp_no=et.emp_no
WHERE e.birth_date > '1955-12-31'
ORDER BY emp_no asc;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) r.emp_no,
r.first_name,
r.last_name,
r.title,
d.dept_name,
r.from_date,
extract(year from r.from_date) as title_year,
extract(year from CURRENT_DATE) as current_year,
(extract(year from CURRENT_DATE))-(extract(year from r.from_date)) as years_in_title
INTO non_retirement_unique_titles
FROM non_retirement_titles as r
INNER JOIN dept_emp AS de ON r.emp_no=de.emp_no
INNER JOIN departments AS d ON de.dept_no=d.dept_no
WHERE (r.to_date = '9999-01-01')
ORDER BY r.emp_no asc,
r.title desc;

--AVERAGE and MEDIAN YEARS BY DEPARTMENT AND TITLE
SELECT dept_name
,title
,count(emp_no) AS emp_count
,ROUND(AVG(years_in_title)) AS averge_years
,PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY years_in_title) AS Median
FROM non_retirement_unique_titles
GROUP BY dept_name, title
ORDER BY Dept_name ASC,
count(emp_no) DESC;

<insert 6aveargeyears>

Summary: The average and median number of years for staff in their current titles, across all departments, is on average between 24-33 years. The more senior positions have the highest average. Although this may indicate employee satisfaction and employees remaining with the company for the duration of their careers, it could also indicate the companies lack of recruitment, outdated processes due to less influence of new employee change, and dissatisfaction among staff with the relative flat hierarchy and opportunities for promotions. Since management is addressing the high number of retiring staff, they should look at promoting staff to new positions to diversity tenure by title.