--1.Create Table Logs
CREATE TABLE Logs
(
LogId INT IDENTITY PRIMARY KEY NOT NULL,
AccountId INT FOREIGN KEY REFERENCES [dbo].[Accounts](Id),
OldSum DECIMAL(15,2),
NewSum DECIMAL(15,2)
)
CREATE TRIGGER tr_InsertAccountInfo ON Accounts FOR UPDATE
AS
BEGIN
DECLARE @newSum DECIMAL(15,2) = (SELECT BALANCE from inserted)
DECLARE @oldSum DECIMAL(15,2) = (SELECT BALANCE from deleted)
DECLARE @accountId INT = (SELECT Id FROM inserted)
INSERT INTO Logs(AccountId,NewSum,OldSum) VALUES 
(@accountId,@newSum,@oldSum)
END
select * from logs
UPDATE Accounts 
SET Balance-=10
WHERE Id = 1
--2.Create Table Emails
CREATE TABLE NotificationEmails
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
Subject NVARCHAR(100),
Body NVARCHAR(100)
)
CREATE TRIGGER tr_notificationEmailInfo ON Logs FOR INSERT 
AS
BEGIN
DECLARE @recipient INT = (SELECT top(1)inserted.AccountId FROM inserted)
DECLARE @subject NVARCHAR(100) = 'Balance change for account: '+ CAST(@recipient AS VARCHAR(10))--CAST(GETDATE() AS VARCHAR(30))
DECLARE @oldsum decimal(15,2) = (SELECT top(1)inserted.OldSum FROM inserted)
DECLARE @newsum decimal(15,2) = (SELECT top(1)inserted.NewSum FROM inserted)
DECLARE @body NVARCHAR(100) = 'On ' + CAST(GETDATE() AS VARCHAR(30)) + ' your balance was changed from ' + CAST(@oldsum AS VARCHAR(30)) + ' to' + CAST(@newsum AS VARCHAR(30)) + '.';
INSERT INTO NotificationEmails ([AccountId],[Subject],[Body]) VALUES 
(@recipient,@subject,@body)
END
--3.Deposit Money
CREATE PROC usp_DepositMoney(@accountId INT, @moneyAmount DECIMAL(15,4))
AS
IF @moneyAmount > 0
BEGIN
UPDATE Accounts
SET Balance+=@moneyAmount
WHERE Id = @accountId
END
GO
EXEC usp_DepositMoney @accountId = 1 ,@moneyAmount=10
--4.Withdraw Money Procedure
CREATE PROC usp_WithdrawMoney (@accountId INT , @moneyAmount decimal(15,4))
AS
IF @moneyAmount > 0
BEGIN
UPDATE Accounts
SET Balance-=@moneyAmount
WHERE Id = @accountId
END
GO
--5.Money Transfer
CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15,4))
AS
exec usp_WithdrawMoney @accountId = @SenderId,@moneyAmount=@Amount
exec usp_DepositMoney @accountId = @ReceiverId,@moneyAmount=@Amount
GO
--6.Trigger

CREATE TRIGGER tr_RestrictItems ON UserGameItems INSTEAD OF INSERT 
AS
DECLARE @itemId INT = (SELECT ItemId FROM inserted)
DECLARE @userGameId INT = (SELECT UserGameId FROM inserted)

DECLARE @itemLevel INT = (select minlevel FROM Items WHERE @itemId = Id) 
DECLARE @userGameLevel INT = (select level from UsersGames where id = @userGameId)

if @userGameLevel >= @itemLevel
	BEGIN
		INSERT INTO UserGameItems(ItemId,UserGameId) VALUES 
		(@itemId,@userGameId)
	END
GO
INSERT INTO UserGameItems (ItemId,usergameid) VALUES
(2,38)
SELECT * FROM UserGameItems
WHERE ItemId = 2 and UserGameId = 38--works

SELECT * FROM Users u 
JOIN UsersGames ug ON u.Id = ug.UserId
JOIN Games g ON g.Id = ug.GameId
where name ='Bali'
UPDATE UsersGames 
SET Cash-=50000 
SELECT * FROM Users u 
JOIN UsersGames ug ON u.Id = ug.UserId
JOIN Games g ON g.Id = ug.GameId
where name ='Bali'
CREATE PROC usp_BuyItem @userId INT,@itemId INT 
AS
BEGIN TRANSACTION
DECLARE @user INT = (SELECT Id FROM USERS WHERE ID = @userId)
DECLARE @item INT = (SELECT Id FROM Items WHERE ID = @itemId)
IF @user IS NULL OR @item IS NULL
BEGIN
ROLLBACK
RAISERROR('Invalid user or item id',16,1)
RETURN 
END
DECLARE @userCash DECIMAL (15,2) = (SELECT CASH FROM UsersGames WHERE UserId = @userId AND GameId = 212)
DECLARE @itemPrice DECIMAL (15,2) = (SELECT price from items where id = @itemId)

IF(@userCash - @itemPrice < 0)
BEGIN
ROLLBACK 
raiserror('Invalid user or item id!',16,1)
RETURN
END
UPDATE UsersGames
SET Cash -=@itemPrice
WHERE UserId = @userId
COMMIT 
--8.Employees with Three Projects
CREATE PROC usp_AssignProject (@emloyeeId INT, @projectID INT) 
AS
BEGIN TRANSACTION
DECLARE @employee INT = (SELECT EmployeeId FROM Employees WHERE EmployeeID = @emloyeeId)
DECLARE @project INT = (SELECT ProjectId FROM Projects WHERE ProjectID = @projectID)
IF (@emloyeeId IS NULL or @projectID IS NULL)
	BEGIN
	ROLLBACK
	RAISERROR('Invalid employee id or project id!',16,1)
	RETURN
	END
DECLARE @employeeProjects INT = (SELECT COUNT(*) FROM EmployeesProjects ep 
WHERE ep.EmployeeID = @emloyeeId)
IF (@employeeProjects >= 3)
ROLLBACK
RAISERROR('The employee has too many projects!',16,2)
RETURN
COMMIT
--9.Delete Employees
create table Deleted_Employees
(EmployeeId INT PRIMARY KEY IDENTITY NOT NULL,
FirstName VARCHAR(30) NOT NULL,
LastName VARCHAR(30) NOT NULL,
MiddleName VARCHAR(30) NOT NULL,
JobTitle VARCHAR(30) NOT NULL,
DepartmentId INT NOT NULL,
Salary DECIMAL(15,2) NOT NULL)

CREATE TRIGGER tr_deletedEmpSaver ON Employees FOR DELETE
AS
INSERT INTO Deleted_Employees (FirstName,LastName,MiddleName,JobTitle,DepartmentId,Salary)
SELECT FirstName,LastName,MiddleName,JobTitle,DepartmentId,Salary FROM deleted



