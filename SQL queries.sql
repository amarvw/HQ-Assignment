/*
1. Using the tables provided above, write a query to return all employees still working for the company with
   last names starting with "Baker" sorted by name then surname.
*/

SELECT * 
FROM   dbo.employees 
WHERE  terminationdate IS NULL      -- no termination date --> active employee 
AND SurName LIKE 'Baker%'           -- surname starts with Baker 
ORDER BY Name,SurName               -- Order by name ,surname 

/* 
2. Given the `Employee` and `AnnualReviews` tables, write a query to return all employees who have never
had a review sorted by the newest hire.
*/

SELECT DISTINCT emp.* 
FROM   dbo.employees AS emp 
LEFT OUTER JOIN dbo.annualreviews AS ar 
       ON emp.number = ar.employeeid 
WHERE  ar.id IS NULL 
AND emp.terminationdate IS NULL           -- active employees need to be reviewed, 
ORDER BY emp.HireDate ASC                 -- comment out in case we even need terminated employees 


/*
3.Write a query to calculate the difference (in days) between the most and least tenured employee still
working for the company.
*/

SELECT Max(Datediff(day, hiredate, Isnull(terminationdate, Getdate())))         -- For active employees I take todays date as ref date. 
- MIN(DATEDIFF(DAY,HireDate,ISNULL(TerminationDate,GETDATE()))) 
FROM dbo.employees

/*
4.Given the employee table above, write a query to calculate the longest period (in days) that the company
has gone without a hiring or firing anyone.
*/

SELECT Max(Datediff(day, T1.[date], T1.nextdate)) 
FROM   (
        SELECT COALESCE(terminationdate, hiredate)  AS [Date], 
               Lead(COALESCE(terminationdate, hiredate), 1, Getdate()) OVER (ORDER BY COALESCE(terminationdate, hiredate)) AS [NextDate] 
        FROM   #employees
        ) AS T1 
