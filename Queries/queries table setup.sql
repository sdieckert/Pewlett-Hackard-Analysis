select * from dept_emp
select * from departments
select * from dept_manager
select * from employees
select * from salaries
select * from titles

ALTER TABLE employees
ALTER COLUMN gender TYPE VARCHAR

drop table titles

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,	
	dept_no VARCHAR(4) NOT NULL,	
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);