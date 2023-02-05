--1.Employees with Salary Above 35000
CREATE PROC usp_GetEmployeesSalaryAbove35000 
AS 
SELECT FirstName,LastName FROM Employees WHERE Salary > 35000
GO
EXEC usp_GetEmployeesSalaryAbove35000
--2.Employees with Salary Above Number
CREATE PROC usp_GetEmployeesSalaryAboveNumber(@Number DECIMAL(18,4))
AS 
SELECT FirstName,LastName FROM Employees WHERE Salary >= @Number
GO
EXEC usp_GetEmployeesSalaryAboveNumber @Number = 48100
--3.Town Names Starting With
CREATE PROC usp_GetTownsStartingWith(@Start Nvarchar(max))
AS
SELECT Towns.[Name] FROM Towns
WHERE Towns.[Name] LIKE @Start + '%'
GO
EXEC usp_GetTownsStartingWith @Start = 'b'
--4.Employees from Town
CREATE PROC usp_GetEmployeesFromTown(@TownName Nvarchar(max))
AS 
SELECT FirstName,LastName FROM Employees 
JOIN Addresses ON Employees.AddressID = Addresses.AddressID
JOIN Towns T ON Addresses.TownID = T.TownID
WHERE T.Name = @TownName
GO
EXEC usp_GetEmployeesFromTown @TownName='Sofia'
--5.Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel (@salary DECIMAL(18,4))
RETURNS NVARCHAR(7)
AS
    DECLARE @salary_level NVARCHAR(7)
    SELECT @salary_level = 
    CASE
        WHEN @salary < 30000 THEN 'Low'
        WHEN @salary BETWEEN 30000 and 50000 THEN 'Average'
        WHEN @salary > 50000 THEN 'High'
    RETURN @salary_level
END
select dbo.ufn_GetSalaryLevel(Salary) --a.k.a. any n number up to (18,4)
--6.Employees by Salary Level
CREATE proc usp_EmployeesBySalaryLeve1l(@salaryLevel NVARCHAR(MAX)) 
AS 
SELECT FirstName,LastName FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel
GO
EXEC usp_EmployeesBySalaryLeve1l @salaryLevel = 'Low'
--7.Define Function
CREATE FUNCTION ufn_IsWordComprised1(@setOfLetters NVARCHAR(MAX), @word NVARCHAR(MAX)) 
RETURNS BIT
BEGIN
DECLARE @count INT = 1
WHILE (@count<Len(@word))
BEGIN
DECLARE @currLetter CHAR(1) = CHARINDEX(@word,@count,1)
IF (CHARINDEX(@currLetter,@word) = 0)
RETURN 0

SET @count +=1
END
RETURN 1
END
SELECT dbo.ufn_IsWordComprised1('oistmiahf','Sofia')
--9.Find Full Name
CREATE PROC usp_GetHoldersFullName 
AS
SELECT CONCAT(FirstName,' ',LastName) AS FullName FROM AccountHolders
GO
EXEC usp_GetHoldersFullName
--10.People with Balance Higher Than
CREATE PROC usp_GetHoldersWithBalanceHigherThan(@Number DECIMAL(15,2))
AS
SELECT * FROM AccountHolders ah
JOIN [dbo].[Accounts] a ON a.AccountHolderId = ah.Id
WHERE a.Balance > @Number
GO
EXEC usp_GetHoldersWithBalanceHigherThan @Number = 432432--example num
--11.Future Value Function
 CREATE FUNCTION ufn_CalculateFutureValue(@InSum DECIMAL(18,2),@Interesest FLOAT(30),@Years INT)
 RETURNS DECIMAL(18,4)
 BEGIN
 DECLARE @Result DECIMAL(18,4) = 0;
 SET @Interesest += 1;
 SET @Result = @InSum * POWER(@Interesest,@Years)
 RETURN @Result
 END
 SELECT dbo.ufn_CalculateFutureValue(100.5,3.6,5)
 --12.Calculating Interest
 CREATE PROC usp_CalculateFutureValueForAccount 
 AS
 SELECT a.Id,FirstName,LastName,Balance,dbo.ufn_CalculateFutureValue(Balance,0.1,5) AS [Balance in 5 years] FROM AccountHolders ah
JOIN [dbo].[Accounts] a ON a.AccountHolderId = ah.Id
GO
EXEC usp_CalculateFutureValueForAccount 
--13.*Scalar Function: Cash in User Games Odd Rows
SELECT *
FROM
(
   SELECT SUM(Cash) AS totalCash,
          ROW_NUMBER() OVER (PARTITION BY g.Id ORDER BY g.Id) AS RowNum
   FROM Games g
   JOIN UsersGames ug ON g.Id = ug.GameId
   WHERE Name = 'Love in a mist'
   GROUP BY g.Id
) as t
WHERE t.RowNum % 2 != 0;