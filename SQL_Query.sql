/*Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and
details of their department.*/

select e.emp_id , e.first_name , e.last_name , e.gender , d.DEPT
from emp_record_table as e
join data_science_team as d on e.emp_id = d.EMP_ID;

/*Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 

less than two

greater than four 

between two and four */

--less than two

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING  from
emp_record_table where EMP_RATING < 2;

--greater than four
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING  from
emp_record_table where EMP_RATING >4;

--between two and four
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING  from
emp_record_table where EMP_RATING between 2 and 4;

/* Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee
table and then give the resultant column alias as NAME.*/

select CONCAT(FIRST_NAME,' ',LAST_NAME) as Name 
from emp_record_table
where DEPT = 'Finance';

/*Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).*/
SELECT e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, COUNT(r.EMP_ID) + 1 AS Num_Reporters
FROM emp_record_table e
LEFT JOIN data_science_team r ON e.EMP_ID = r.EMP_ID
GROUP BY e.EMP_ID, e.FIRST_NAME, e.LAST_NAME
HAVING COUNT(r.EMP_ID) > 0;

/*Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.*/
select EMP_ID, FIRST_NAME, LAST_NAME , DEPT from emp_record_table where 
DEPT = 'Healthcare' 
union
select EMP_ID, FIRST_NAME, LAST_NAME , DEPT from emp_record_table where 
DEPT = 'finance'

/*Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept.
Also include the respective employee rating along with the max emp rating for the department.*/
SELECT 
    d.EMP_ID,d.FIRST_NAME,d.LAST_NAME,d.ROLE,d.DEPT,
    max_rating.Max_Rating_For_Dept
FROM 
    data_science_team d
JOIN 
    (SELECT DEPT, MAX(EMP_RATING) AS Max_Rating_For_Dept
     FROM emp_record_table e
     GROUP BY DEPT) max_rating 
ON 
    d.DEPT = max_rating.DEPT
ORDER BY 
    d.DEPT;
/*
Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.*/
SELECT 
    ROLE,
    MIN(SALARY) AS Min_Salary,
    MAX(SALARY) AS Max_Salary
FROM 
    emp_record_table
GROUP BY 
    ROLE;
/*Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.*/
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    ROLE,
    EXP,
    RANK() OVER (ORDER BY EXP DESC) AS Experience_Rank
FROM 
    emp_record_table;
/*Write a query to create a view that displays employees in various countries whose salary is more than six thousand. 
Take data from the employee record table.*/
CREATE VIEW HighSalaryEmployeesByCountry AS
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    COUNTRY,
    SALARY
FROM 
    emp_record_table
WHERE 
    SALARY > 6000;
GO
SELECT * FROM HighSalaryEmployeesByCountry;
/*Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.*/
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
FROM emp_record_table
WHERE EXP > (
    SELECT 10
);

/*Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years.
Take data from the employee record table.*/
CREATE PROCEDURE GetEmployeesWithExperience
AS
BEGIN
    SET NOCOUNT ON;

    SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
    FROM emp_record_table
    WHERE EXP > 3;
END;
EXEC GetEmployeesWithExperience;

/*Write a query using stored functions in the project table to check whether the job profile assigned to each employee 
in the data science team matches the organization’s set standard.

 

The standard being:

For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',

For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',

For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',

For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',

For an employee with the experience of 12 to 16 years assign 'MANAGER'.*/
CREATE FUNCTION dbo.GetJobProfile (@experience INT)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @jobProfile NVARCHAR(50)

    IF @experience <= 2
        SET @jobProfile = 'JUNIOR DATA SCIENTIST'
    ELSE IF @experience > 2 AND @experience <= 5
        SET @jobProfile = 'ASSOCIATE DATA SCIENTIST'
    ELSE IF @experience > 5 AND @experience <= 10
        SET @jobProfile = 'SENIOR DATA SCIENTIST'
    ELSE IF @experience > 10 AND @experience <= 12
        SET @jobProfile = 'LEAD DATA SCIENTIST'
    ELSE IF @experience > 12 AND @experience <= 16
        SET @jobProfile = 'MANAGER'
    ELSE
        SET @jobProfile = 'UNKNOWN'

    RETURN @jobProfile
END;

SELECT 
    p.PROJECT_ID, 
    e.FIRST_NAME, 
    e.LAST_NAME, 
    dbo.GetJobProfile(e.EXP) AS JobProfile
FROM 
    proj_table p
INNER JOIN 
    emp_record_table e ON p.PROJECT_ID = e.EMP_ID
WHERE 
    p.DOMAIN = 'Data Science';

/*Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table
after checking the execution plan.*/
--CREATE INDEX IX_FirstName ON emp_record_table (FIRST_NAME);
SET SHOWPLAN_TEXT ON;
SELECT *
FROM emp_record_table
WHERE FIRST_NAME = 'Eric';

/*Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).*/
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY,
    EMP_RATING,
    0.05 * SALARY * EMP_RATING AS Bonus
FROM 
    emp_record_table;
SET SHOWPLAN_TEXT OFF;

/*Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.*/
SELECT 
    CONTINENT,
    COUNTRY,
    AVG(SALARY) AS Average_Salary
FROM 
    emp_record_table
GROUP BY 
    CONTINENT,
    COUNTRY;






 




 






 
