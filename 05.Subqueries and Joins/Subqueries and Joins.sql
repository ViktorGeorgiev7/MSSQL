--1.Employee Address
SELECT top(5)EmployeeID,JobTitle,e.AddressID,a.AddressText 
FROM Employees as e 
JOIN Addresses as a 
ON e.AddressID = a.AddressID 
ORDER BY AddressID
--2.Addresses with Towns
SELECT TOP(50)FirstName,LastName,t.[Name],a.AddressText FROM Employees AS e 
JOIN Addresses AS a 
ON e.AddressID = a.AddressID 
JOIN Towns AS t 
ON a.TownID = t.TownID
ORDER BY FirstName,LastName
--3.Sales Employee
SELECT EmployeeID,FirstName,LastName,d.[Name] FROM Employees as 
e JOIN Departments AS d 
ON e.DepartmentID = d.DepartmentID 
WHERE d.[Name] = 'Sales' 
ORDER BY e.EmployeeID
--4.Employee Departments
SELECT TOP(5)EmployeeID,FirstName,Salary,d.[Name] FROM Employees as 
e JOIN Departments AS d 
ON e.DepartmentID = d.DepartmentID 
WHERE e.Salary > 15000
ORDER BY d.DepartmentID
--5.Employees Without Project
SELECT TOP(3) e.EmployeeID,FirstName FROM Employees AS e LEFT JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID WHERE ep.EmployeeID IS NULL ORDER BY e.EmployeeID 
--6. Employees Hired After
SELECT FirstName,LastName,e.HireDate,d.[Name] FROM Employees as 
e JOIN Departments AS d 
ON e.DepartmentID = d.DepartmentID 
WHERE e.HireDate > '1999-01-01'
AND d.Name IN ('Sales','Finance')
ORDER BY HireDate
--7.Employees with Project
SELECT TOP(5)e.EmployeeID,FirstName,p.[Name],p.EndDate FROM Employees AS e 
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID 
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE p.StartDate > '2002-08-13' AND EndDate IS NULL
ORDER BY EmployeeID
--8.Employee 24
SELECT e.EmployeeID,FirstName,
CASE WHEN p.EndDate > '2004' THEN NULL 
ELSE p.[Name] END AS ProjectName,p.EndDate FROM Employees AS e
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID 
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE e.EmployeeID = 24 
--9.Employee Manager
	SELECT emp.EmployeeID,emp.FirstName,mng.ManagerID,mng.FirstName FROM Employees emp 
	JOIN Employees mng ON mng.EmployeeID = emp.ManagerID
	WHERE mng.ManagerID = 3 OR mng.ManagerID = 7
	ORDER BY emp.EmployeeID
--10.Employees Summary
SELECT TOP(50)emp.EmployeeID,emp.FirstName+' '+emp.LastName AS EmployeeName,mng.FirstName+' '+mng.LastName AS ManagerName,dep.[Name] FROM Employees emp 
	JOIN Employees mng ON emp.ManagerID=mng.EmployeeID 
	JOIN Departments dep ON emp.DepartmentID = dep.DepartmentID
	ORDER BY EmployeeID
--11.Min Average Salary
SELECT Distinct TOP(1)AVG(Salary) as avgSalary FROM Employees emp
JOIN Departments dep ON dep.DepartmentID = emp.DepartmentID
GROUP BY dep.DepartmentID
ORDER BY avgSalary
--12.Highest Peaks in Bulgaria
SELECT CountryCode,Mountains.MountainRange,PeakName,Elevation FROM Peaks 
JOIN Mountains ON Peaks.MountainId = Mountains.Id
JOIN MountainsCountries ON MountainsCountries.MountainId = Mountains.Id
WHERE CountryCode = 'BG'
ORDER BY Elevation desc
--13.Count Mountain Ranges
SELECT DISTINCT CountryCode,COUNT(MountainRange) AS MountainRanges FROM Mountains
JOIN MountainsCountries ON MountainsCountries.MountainId = Mountains.Id
WHERE CountryCode IN ('BG','RU','US')
GROUP BY CountryCode
--14.Countries With or Without Rivers
SELECT TOP(5)c.CountryName,r.RiverName FROM Countries c
JOIN Continents con ON con.ContinentCode = c.ContinentCode 
LEFT JOIN CountriesRivers cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers r ON r.Id = cr.RiverId
WHERE con.ContinentCode = 'AF'
ORDER BY c.CountryName
--15.*Continents and Currencies
SELECT rankedCurrencies.ContinentCode, rankedCurrencies.CurrencyCode, rankedCurrencies.Count
FROM (
SELECT c.ContinentCode, c.CurrencyCode, COUNT(c.CurrencyCode) AS [Count], DENSE_RANK() OVER (PARTITION BY c.ContinentCode ORDER BY COUNT(c.CurrencyCode) DESC) AS [rank] 
FROM Countries c
GROUP BY c.ContinentCode, c.CurrencyCode) AS rankedCurrencies
WHERE rankedCurrencies.rank = 1 and rankedCurrencies.Count > 1
--16.Countries Without Any Mountains
SELECT count(*) FROM Countries
LEFT JOIN MountainsCountries ON MountainsCountries.CountryCode = Countries.CountryCode
WHERE MountainId IS NULL
--17.Highest Peak and Longest River by Country
SELECT TOP(5)CountryName,MAX(p.Elevation) AS MaxEval,MAX(r.Length) AS MaxLenght
FROM Countries c
LEFT JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains m ON m.Id = mc.MountainId
LEFT JOIN Peaks p ON p.MountainId = m.Id
LEFT JOIN CountriesRivers cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers r ON r.Id = cr.RiverId 
WHERE p.Elevation IS NOT NULL AND R.[Length] IS NOT NULL 
GROUP BY c.CountryName
ORDER BY MaxEval desc,MaxLenght desc,C.CountryName
--18.Highest Peak Name and Elevation by Country
SELECT TOP(5)c.CountryName,
CASE WHEN mc.MountainId IS NULL THEN '(no highest peak)'
ELSE PeakName END AS PeakName,
CASE  WHEN mc.MountainId IS NULL THEN 0
ELSE P.Elevation END AS Elevation,
CASE WHEN mc.MountainId IS NULL THEN '(no mountain)'
ELSE m.MountainRange END AS Mountain
FROM Countries c
LEFT JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains m ON m.Id = mc.MountainId
LEFT JOIN Peaks p ON p.MountainId = m.Id
ORDER BY c.CountryName

