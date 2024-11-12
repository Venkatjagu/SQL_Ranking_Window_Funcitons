Create database employees;

Use employees;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE
);

INSERT INTO employees (emp_id, emp_name, department, salary, hire_date)
VALUES
(1, 'Alice', 'HR', 55000, '2018-01-15'),
(2, 'Bob', 'IT', 75000, '2017-05-23'),
(3, 'Charlie', 'Finance', 82000, '2019-03-12'),
(4, 'Diana', 'IT', 60000, '2020-07-19'),
(5, 'Eve', 'HR', 52000, '2021-11-05'),
(6, 'Frank', 'Finance', 72000, '2020-08-10'),
(7, 'Grace', 'HR', 61000, '2016-12-20'),
(8, 'Hank', 'IT', 69000, '2019-01-11'),
(9, 'Ivy', 'Finance', 73000, '2018-09-30'),
(10, 'Jack', 'HR', 54000, '2017-10-15'),
(11, 'Kate', 'IT', 78000, '2016-06-01'),
(12, 'Leo', 'HR', 59000, '2019-02-21'),
(13, 'Mia', 'Finance', 76000, '2019-04-10'),
(14, 'Nick', 'IT', 65000, '2018-12-05'),
(15, 'Olivia', 'HR', 53000, '2020-09-29'),
(16, 'Paul', 'Finance', 70000, '2021-03-22'),
(17, 'Quincy', 'IT', 72000, '2020-01-07'),
(18, 'Rita', 'HR', 60000, '2020-05-15'),
(19, 'Steve', 'Finance', 78000, '2019-08-18'),
(20, 'Tom', 'IT', 81000, '2018-07-23'),
(21, 'Uma', 'HR', 58000, '2020-02-17'),
(22, 'Victor', 'Finance', 75000, '2021-05-10'),
(23, 'Wendy', 'IT', 70000, '2020-10-05'),
(24, 'Xander', 'HR', 62000, '2017-11-22'),
(25, 'Yara', 'Finance', 82000, '2021-06-30');

SELECT * FROM Employees;

-- Window Functions -- 
-- Basic to Intermediate Level-- 

-- 1. Find the row number of each employee ordered by salary. [Use ROW_NUMBER() OVER (ORDER BY salary DESC)]. 
SELECT 
	*,
    Row_Number() Over(Order By Salary DESC) as RowNum
FROM
	Employees;
    
-- 2. Rank employees based on their salaries. [Use RANK() OVER (ORDER BY salary DESC)].
SELECT 
	*,
    Rank() Over(Order By Salary DESC) as `Rank`
FROM 
	Employees;
-- 2a. Rank Employees based on their salaries by departments.
SELECT 
	*,
    Rank() Over(Partition By Department Order By Salary DESC) as `EmpSalaryRank_DepartmentWise`
FROM 
	Employees;

-- 3. Dense rank employees within each department based on salary. [Use DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC)].
SELECT 
	*,
    DENSE_RANK() OVER(Order by Salary DESC) as EmpSalary_DenseRank
FROM 
	Employees;

-- 3a. Dense_Rank Employees based on their salaries by departments.
SELECT 
	*,
    Dense_Rank() Over(Partition By Department Order By Salary DESC) as `EmpSalaryDenseRank_Departmentwise`
FROM 
	Employees;

-- 4. Rank employees by hire date. [Use RANK() OVER (ORDER BY hire_date ASC)].
SELECT 
	*,
    Rank() Over(Order By hire_date ASC) as Rank_By_Hiredate
From 
	Employees;
    
-- 5. Find the row number of each employee within their department based on hire date. [Use ROW_NUMBER() OVER (PARTITION BY department ORDER BY hire_date)].
SELECT 
	*,
    row_number() Over(Partition By Department Order By Hire_date) as Hiredate_Rownum_withinDepartment
FROM 
	Employees;
    
-- Advanced level -- 
-- 6. Show the employee name and salary of the highest-paid employee in each department. [Use RANK() and filter for WHERE rank = 1]. 
SELECT
	Emp_name,
    Department,
    Salary
FROM
	(SELECT 
		*,
		Rank() Over(Partition By Department Order By Salary DESC) as `Rank` 
	FROM 
		Employees) as E ## Using sub-query in FROM clause.
WHERE 
	`Rank` = 1; ## Retrieved Department name for better output clarification
    
-- 7. Calculate the rank difference between employees with the same salary across departments. [Combine RANK() with a self-join].

-- 8. Get the 2nd highest salary in each department, showing the employee name. [Use RANK() and filter for WHERE rank = 2].
SELECT 
	Emp_Name,
	Salary,
    Department
FROM 
	(SELECT
		*,
        Rank() OVER(Partition By Department Order By Salary DESC) as `Rank`
	 FROM 
		Employees) as E
WHERE 
	`Rank` = 2
;
	
    
-- 9. Find the average salary of the top 3 highest-paid employees in each department. [Use ROW_NUMBER() with a PARTITION BY department].
SELECT 
    Department,
    AVG(Salary) AS Avg_Salary
FROM 
    (SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY Department ORDER BY Salary DESC) AS ROWNUM
    FROM 
        Employees) AS E
WHERE 
    ROWNUM <= 3
GROUP BY 
    Department;

WITH 
	ranked_salaries 
		AS ( SELECT 
				emp_id, 
                emp_name,
                department, 
                salary, 
                ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS `rank` FROM employees)
SELECT department, AVG(salary) AS avg_salary FROM ranked_salaries WHERE `rank` <= 3 GROUP BY department;
    
    
-- 10. Assign a dense rank to employees based on their hire date, resetting at each department change. [Combine DENSE_RANK() with PARTITION BY department ORDER BY hire_date].
SELECT 
	*,
    DENSE_RANK() OVER(Partition By Department Order By Hire_Date) as Hire_Rank
FROM 
	Employees;
