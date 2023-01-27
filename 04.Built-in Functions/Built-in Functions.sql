--1.Find Names of All Employees by First Name
SELECT FirstName,LastName FROM Employees WHERE FirstName LIKE 'Sa%'
--2.Find Names of All Employees by Last Name 
SELECT FirstName,LastName FROM Employees WHERE LastName LIKE '%ei%'
--3.Find First Names of All Employees
SELECT FirstName,HireDate FROM Employees WHERE DepartmentID IN (3,10)
AND NOT HireDate BETWEEN 1995 AND 2005
--4.Find All Employees Except Engineers/ps ig nobody likes engineers );
SELECT FirstName FROM Employees WHERE JobTitle NOT LIKE '%Engineer%' 
--5.Find Towns with Name Length
SELECT [Name] FROM Towns WHERE LEN([Name]) IN (5,6)
--6.Find Towns Starting With
SELECT [Name] FROM towns WHERE [Name] LIKE 'M%' OR name LIKE 'K%' OR name LIKE 'B%' OR name LIKE 'E%'
ORDER BY [Name]
--7.Find Towns Not Starting With
SELECT [Name] FROM towns WHERE [Name] NOT LIKE 'M%' OR name NOT LIKE 'K%' OR name NOT LIKE 'B%' OR name NOT LIKE 'E%'
ORDER BY [Name]
--8.Create View Employees Hired After 2000 Year
CREATE VIEW V_EmployeesHiredAfter2000
AS
SELECT FirstName, LastName
FROM Employees
WHERE HireDate > '2000-01-01'
SELECT * FROM V_EmployeesHiredAfter2000
--9.Length of Last Name
SELECT FirstName,LastName FROM Employees WHERE LEN(LastName) = 5
--10.Rank Employees by Salary
SELECT EmployeeID,FirstName,LastName,Salary,DENSE_RANK() OVER (ORDER BY SALARY DESC) AS RANK FROM Employees WHERE Salary BETWEEN 10000 AND 50000 
--11.Find All Employees with Rank 2
SELECT * FROM (SELECT EmployeeID,FirstName,LastName,Salary,DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Ranked FROM Employees WHERE Salary BETWEEN 10000 AND 50000 ) AS Result WHERE Ranked = 2 ORDER BY Salary DESC
--12.Countries Holding 'A' 3 or More Times
SELECT CountryName,IsoCode FROM Countries WHERE CountryName LIKE 'A%a%a%' AND CountryName LIKE '%a%a%a%' ORDER BY IsoCode
--13.Mix of Peak and River Names
SELECT RiverName,PeakName,LOWER(SUBSTRING(PeakName,1,LEN(PeakName)-1)+RiverName) AS mix FROM Peaks,Rivers WHERE LOWER(LEFT(RiverName,1)) = RIGHT(PeakName,1) ORDER BY mix
--14.Games from 2011 and 2012 Year
SELECT [Name],CONVERT(date,[Start],111) FROM Games WHERE [Start] > '2011' AND [Start] < '2012' ORDER BY [Start],[Name]
--15.User Email Providers
	SELECT
	 Username,
	  SUBSTRING(Email, CHARINDEX('@', Email), LEN(Email) - CHARINDEX('@', Email) + 1) AS substring
	FROM Users
	ORDER BY substring,Username
--16.Get Users with IP Address Like Pattern
SELECT Username,IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___' 
ORDER BY Username
--17.Show All Games with Duration and Part of the Day
SELECT [Name],CASE 
WHEN DATEPART(HOUR,[Start]) BETWEEN 0 AND 11 THEN 'Mornin'''
WHEN DATEPART(HOUR,[Start]) BETWEEN 12 AND 17 THEN 'Afternoo'''
WHEN DATEPART(HOUR,[Start]) BETWEEN 18 AND 23 THEN 'Evenin''' 
END
AS [Part of the day]
,CASE 
WHEN Duration <= 3 THEN 'Extra Short'
WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
WHEN Duration > 6 THEN 'Long'
WHEN Duration IS NULL THEN 'Extra Long' 
END 
AS Duration
FROM Games
--18.Orders Table
SELECT ProductName,OrderDate,DATEADD(day,3,OrderDate) AS [Pay Due],DATEADD(month,1,OrderDate) AS [Deliver Due] FROM Orders