USE BAM

select * from MobileSessionDetails
select * from MobileSessionSavedDetails

-- Task 1 

SELECT
   CONVERT(DATE ,t2.CreatedOn ) as CreatedOn,
   SUM(DATEDIFF(MINUTE, t1.LogInTimeStamp, t1.LogOutTimeStamp)) AS Sessions,
   COUNT(t1.SessionId) as "No of Sessions",
CASE
	WHEN count(t1.SessionId) = 0 THEN NULL 
	ELSE SUM(DATEDIFF(Minute , t1.LogInTimeStamp,t1.LogOutTimeStamp))/Count(t1.SessionId)
    END AS "Time Per Session"
FROM
    MobileSessionDetails t2
	 LEFT JOIN MobileSessionSavedDetails t1   
	 ON t1.SessionId = t2.Id
GROUP BY
    CONVERT(DATE,CreatedOn)
ORDER BY
    CONVERT(DATE,CreatedOn);

--Task 2 
-- Select Max and Min nof LoginTimeStamp w.r.t every Module to find NoofDays which is the difference between MaxTimeStamp and MinTimeStamp

SELECT 
    Module,
    FORMAT(MAX(CONVERT(DATETIME, LogInTimeStamp)), 'mm:ss.f') AS MaxTimeStamp,
    FORMAT(MIN(CONVERT(DATETIME, LogInTimeStamp)), 'mm:ss.f') AS MinTimeStamp,
    DATEDIFF(DAY, MIN(LogInTimeStamp), MAX(LogInTimeStamp)) AS NoofDays
FROM MobileSessionSavedDetails
GROUP BY Module;

-- Task 3 
-- Q1: Is this kind of transformation possible in SQL? If yes name the Transformation and perform it in SQL.	
--Answer : Yes, this kind of transformation is possible in SQL, and it is known as "pivot" operation. 

-- Created a table called 'Sales' - INPUT TABLE 

CREATE TABLE Sales (
    Name VARCHAR(50),
    Month VARCHAR(3),
    Revenue INT
);

-- Insert records into the "Sales" table
INSERT INTO Sales (Name, Month, Revenue)
VALUES
    ('A', 'JAN', 100),
    ('B', 'JAN', 20),
    ('C', 'JAN', 3),
    ('D', 'APR', 200),
    ('E', 'APR', 235),
    ('F', 'JUL', 144),
    ('A', 'JUL', 10),
    ('B', 'JUL', 22),
    ('A', 'JAN', 300),
    ('B', 'JAN', 20);

SELECT * FROM Sales;

SELECT Name,
       ISNULL([JAN], 0) AS JAN,
       ISNULL([APR], 0) AS APR,
       ISNULL([JUL], 0) AS JULY
FROM ( SELECT Name, Month, Revenue FROM Sales) AS Input_table
PIVOT (SUM(Revenue) FOR Month IN ([JAN], [APR], [JUL])) AS PivotTable;
























