--1.Records' Count
SELECT COUNT(*) AS Count FROM WizzardDeposits
--2.Longest Magic Wand
SELECT * FROM WizzardDeposits
SELECT MAX(MagicWandSize) as LongestMagicWand FROM WizzardDeposits
--3.Longest Magic Wand Per Deposit Groups
SELECT DepositGroup,MAX(MagicWandSize) as LongestMagicWand FROM WizzardDeposits
GROUP BY DepositGroup
--4.Smallest Deposit Group Per Magic Wand Size
SELECT TOP(2) DepositGroup 
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize) 
--5.Deposits Sum
SELECT DepositGroup,SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
GROUP BY DepositGroup
--6.Deposits Sum for Ollivander Family
SELECT DepositGroup,SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
--7.Deposits Filter
SELECT DepositGroup,SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC
--8.Deposit Charge
SELECT DepositGroup,MagicWandCreator,MIN(DepositCharge) FROM WizzardDeposits
GROUP BY DepositGroup,MagicWandCreator
ORDER BY MagicWandCreator,DepositGroup
--9.Age Groups
SELECT Result.AgeGroup,COUNT(Result.AgeGroup) FROM (
SELECT CASE 
WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
WHEN Age >= 61 THEN '[61+]' end as AgeGroup FROM WizzardDeposits) AS Result
GROUP BY AgeGroup
order by AgeGroup
--10.First Letter
SELECT Result.FirstLetter FROM (SELECT SUBSTRING(FirstName,1,1) AS FirstLetter FROM WizzardDeposits) AS Result
GROUP BY Result.FirstLetter
ORDER BY Result.FirstLetter
--11.Average Interest 
SELECT DepositGroup,IsDepositExpired,AVG(DepositInterest) FROM WizzardDeposits
WHERE WizzardDeposits.DepositStartDate > '1985-01-01'
GROUP BY DepositGroup,IsDepositExpired
ORDER BY DepositGroup desc,IsDepositExpired
--12. *Rich Wizard, Poor Wizard
SELECT Host.DepositAmount,Host.FirstName,Guest.DepositAmount,Guest.FirstName,
CASE WHEN Host.Id = 162 THEN 0
ELSE Host.DepositAmount-Guest.DepositAmount END as diff FROM WizzardDeposits Host
JOIN WizzardDeposits Guest ON Host.Id = Guest.Id + 1
--13.Departments Total Salaries
SELECT d.DepartmentID,SUM(e.Salary) FROM Employees e 
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID
ORDER BY d.DepartmentID
--14.Employees Minimum Salaries
SELECT d.DepartmentID,MIN(e.Salary) FROM Employees e 
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentID IN (2,5,7) AND e.HireDate > '2000-01-01'
GROUP BY d.DepartmentID
ORDER BY d.DepartmentID
--15.Employees Average Salaries
SELECT * INTO MyNewTable FROM Employees WHERE SALARY > 30000

DELETE FROM MyNewTable WHERE ManagerID = 42

UPDATE MyNewTable SET Salary += 5000 WHERE DepartmentID = 1
--16. Employees Maximum Salaries
SELECT DepartmentID,MAX(e.Salary) as [max] FROM Employees e 
WHERE Salary not BETWEEN 30000 AND 70000
GROUP BY DepartmentID
ORDER BY DepartmentID
--17. Employees Count Salaries
SELECT COUNT(Salary)as [Count] FROM Employees 
WHERE ManagerID IS NULL
--18. *3rd Highest Salary
SELECT DISTINCT k.DepartmentID,k.Salary FROM (SELECT DepartmentID,Salary,
DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY SALARY DESC) as ranked FROM Employees) as k
WHERE ranked = 3
--19. **Salary Challenge
SELECT TOP(10)FirstName,LastName,DepartmentID FROM Employees emp
WHERE Salary > (SELECT AVG(SALARY) FROM Employees
WHERE DepartmentID=emp.DepartmentID
GROUP BY DepartmentID)
ORDER BY DepartmentID