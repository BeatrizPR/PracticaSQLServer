/*  EJERCICIOS */

--1. CREATE DATABASE
CREATE DATABASE TestData
GO

--2. CREATE DATABASE

USE master;
GO
-- Delete the testdata database if it exists
IF EXISTS(SELECT * FROM sys.databases WHERE name ='TestData')
BEGIN
	DROP DATABASE TestData;
END
-- Create a new database called TestData
CREATE DATABASE TestData;


-- 3. Create product table
USE TestData;

CREATE TABLE dbo.Products
	(ProductID INT NOT NULL,
	ProductName VARCHAR(25) NOT NULL,
	Price MONEY NULL,
	ProductDescription TEXT NULL)

GO

--4. Insert data in product table

INSERT dbo.Products (ProductID, ProductName, Price, ProductDescription)
	VALUES(1, 'Clamp', 12.48, 'Workbench'),
			(50, 'Screwdriver', 3.17, 'Flat head'),
			(75, 'Tire Bar', null, 'Tool for changing tires'),
			(3000, '3mm Brtacket', 0.52, null);
GO

-- 5. Update products
USE TestData
UPDATE Products
	SET ProductName = 'Flat Head Screwdriver'
	WHERE ProductID = 50;
GO

--6. Get data from products

SELECT  * FROM dbo.Products
SELECT ProductName, Price 
	FROM dbo.Products;

--7. Get product with where condition
SELECT ProductID, ProductName, Price, ProductDescription 
	FROM dbo.Products
	WHERE ProductID < 60;
GO

--8. Get price with tax of 7% return with the name customerPays
SELECT ProductName, Price * 1.07 AS CustomerPays
	FROM dbo.Products;
GO

-- 9. Creating views
CREATE VIEW vw_Names
	AS
	SELECT ProductNAme, Price FROM Products;
GO

-- Test the view
SELECT * FROM vw_Names;

--10. Create stored procedure

CREATE PROCEDURE pr_Names @VarPrice MONEY
	AS
	BEGIN
		--The print statement returns text to the user
		PRINT 'Products less than ' + CAST(@VarPrice AS VARCHAR(10));
		-- A second statement starts here
		SELECT ProductName, Price FROM vw_Names
		WHERE Price < @VarPrice;
	END
GO

-- test de stored procedure
EXECUTE pr_Names 10.00;
GO

-- 11. Delete the store procedure
DROP PROC pr_Names;
GO
--12. Delete the view vw_Names
DROP View vw_Names;
GO

--13. Creating variables

DECLARE @result AS BIGINT;
DECLARE @factor1 AS INT = 15874;
DECLARE @factor2 AS SMALLINT = @factor1 -100;
SELECT @result = @factor1 * @factor2;

--14. create a table-value variable
DECLARE @t1 TABLE (
	f1 INTEGER,
	f2 INTEGER,
	r INTEGER
);

INSERT INTO @t1 (f1, f2, r)
	VALUES (43, 133, 0),
		(239, 125,0),
		(854, 143, 0);

SELECT f1, f2, r FROM @t1
WHERE f1 < 100;
GO


--15. Store procedures with variables
CREATE PROCEDURE spIntMultiplier (@p1 INT, @p2 INT, @r BIGINT OUTPUT)
AS
BEGIN 
	IF (@p1 = 0 OR @p2 = 0)
		BEGIN
		--PRINT 'The numbers should be larger than 0. The result is: '; -- NO LO IMPRIMEEEE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		SELECT @r = 0;
		END
	ELSE 
		BEGIN TRY
			--calculate 
			SELECT @r= @p1 * @p2;
		END TRY
		BEGIN CATCH
			SELECT @r = @p1 * CONVERT(BIGINT, @p2);
		END CATCH
		SELECT @r;
END
GO

-- text store procedure
DECLARE @result BIGINT;
EXEC spIntMultiplier 0,0, @result OUTPUT;

DECLARE @result BIGINT;
EXEC spIntMultiplier 100, 300, @result OUTPUT;

DECLARE @result BIGINT;
EXEC spIntMultiplier 10000000, 30000000, @result OUTPUT;



-- 16. Create funtion

CREATE FUNCTION udfMultiplyValues (@p1 INT, @p2 INT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @r AS BIGINT;
	SET @r = @p1 * @p2;
	RETURN @r;
END
GO


EXEC udfMultiplyValues 2,2;

--17. Aggregation function using Sales.SalesOrderHeader

-- a. How many rows are in the table? - ¿Cuántas filas hay en la tabla?
-- b. What is the highest TotalDue amount used inthe sales order? -  ¿Cuál es el total más alto de las ventas?
-- c. What is the average Freight weight of all sales orders? - ¿Cuál es la media de Freight de todas las ventas?
-- d. How many different customer did place a sales order in the system? - ¿cuántos clientes distintos han realizado pedidos en el sistema?
-- e. What is the total TotalDue amount of all sales orders shipedd in November 2005? - ¿cuál es la cuenta total de TotalDue en todas las ventas realizadas en noviembre de 2005?

USE AdventureWorks2012
GO
--a 
SELECT COUNT(*) AS Total FROM Sales.SalesOrderHeader;
--b
SELECT MAX(TotalDue) AS MaxTotalDue FROM Sales.SalesOrderHeader;
--c
SELECT AVG(Freight) AS AverageFreight FROM Sales.SalesOrderHeader;
--d
SELECT COUNT(DISTINCT CustomerID) AS TotalCustomer FROM Sales.SalesOrderHeader;
--e
SELECT SUM(TotalDue) AS TotalDueNovember FROM Sales.SalesOrderHeader WHERE MONTH(OrderDate)=11 AND YEAR(OrderDate) = 2005;

-- 18. Get salesordernumber with the highest totalDue value in the same table
SELECT SalesOrderNumber FROM Sales.SalesOrderHeader
	WHERE TotalDue IN (SELECT MAX(TotalDue) FROM Sales.SalesOrderHeader);

-- 19.combine the salesorderheader table and the sales territory table by using the territoryID column
-- a. analyze the totaldue amount per territory group by using the group by statement.
-- b. analyze the totaldue amount per (group, countryRegionCode) and the total value by using a grouning sets statement.
-- c. filter both queries to only display those item related to Europe.

SELECT SUM(TotalDue) AS AmounTotalDue, ST.TerritoryID FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.SalesTerritory AS ST
	ON SOH.TerritoryID = ST.TerritoryID
	WHERE [ST].[Group] = 'Europe'
	GROUP BY ST.TerritoryID;
GO
SELECT SUM(TotalDue) AS 'Amount Total Due', ST.CountryRegionCode 
	FROM Sales.SalesOrderHeader
	AS SOH
	INNER JOIN Sales.SalesTerritory AS ST
	ON SOH.TerritoryID = ST.TerritoryID
	WHERE [ST].[Group] = 'Europe'
	GROUP BY GROUPING SETS (([ST].[Group], ST.CountryRegionCode),());
GO

-- 19. Joins and pivoting.
--1.Write a query to join the three tables SalesOrderHeader, SalesOrderHeaderSalesReason and SalesReason by using the defined foreign key constraints.
-- a. Select the table columns TotalDue, Reason Name and Reason Type.
-- b. Please notice: There may be cases in wich one SalesOrder is assigned to multiple Sales Reasons with the same type.
-- 2.Adjust the query to pivotize the results and display the ReasonTypes as column headers and the reason name in the rows. 
--The value field should contain the sum of all TotalDue values falling into a specific bucket.
--1
SELECT TotalDue, Name, ReasonType FROM Sales.SalesOrderHeader AS SOH  
LEFT JOIN Sales.SalesOrderHeaderSalesReason AS SOHSR ON SOH.SalesOrderID = SOHSR.SalesOrderID
LEFT JOIN Sales.SalesReason AS SR ON SOHSR.SalesReasonID = SR.SalesReasonID;
--2
WITH PivotData AS 
(
	SELECT TotalDue, Name, ReasonType FROM Sales.SalesOrderHeader AS SOH  
	LEFT JOIN Sales.SalesOrderHeaderSalesReason AS SOHSR ON SOH.SalesOrderID = SOHSR.SalesOrderID
	LEFT JOIN Sales.SalesReason AS SR ON SOHSR.SalesReasonID = SR.SalesReasonID)
	SELECT Name, Marketing, Other, Promotion FROM PivotData
		PIVOT(SUM(TotalDue) FOR ReasonType IN(Marketing, Other, Promotion)) AS P;

-- 20. Trigger
--1.Check the Database Trigger you can find in the programmability section
-- a.Open the trigger called ddlDatabaseTriggerLog and Describe what this trigger does

-- Este trigger crea un log con el usuario, esquema, la fecha, el objeto que se modifica, el evento xml.

--2. You want to create a table loggin the history of data in the SalesPerson table.
-- a. Create a new history called SalesReasonHistory holding the same column names and data types as the SalesReason table
--		i. Remove the primary key constrain in the new table for the SalesReasonID column.
--		ii. Remove the Default constraint in the new table from the ModifiedData Column.
--		iii. Add a column named ValidFrom of datetime data type to the new table

CREATE TABLE Sales.SalesReasonHistory (  
	SalesReasonID INT not null,
	Name NVARCHAR(50) not null,
	ReasonType NVARCHAR(50) not null,
	ModifiedDate datetime not null,
	ValidFrom datetime
	);

-- b. Create triggers to the new table to fulfill the folowing requirements.
-- When a new row is iserted or an existing row is update in the SalesReason table, 
--the updated or an existing row is updated in the SalesReason History table. The ValidFrom date is set to the current date and time.
-- When a row is deleted from the SalesReason table, the deleted row is inserted into the SalesReasonHistory table. 
--The ValidFrom date is set to the maximal value allowed in this field.
CREATE TRIGGER TriggerLogSalesReason ON Sales.SalesReason
	AFTER INSERT, UPDATE, DELETE
	AS
	BEGIN
		INSERT INTO Sales.SalesReasonHistory
			SELECT SalesReasonID, Name, ReasonType, ModifiedDate, GETDATE() 
			FROM inserted

			SELECT SalesReasonID, Name, ReasonType, ModifiedDate, '99991231' --numero más grande en fecha año 9999 diciembre 31
			FROM deleted
	END
-- c. Run queries to test your triggers and double check the corresponding entries in the SalesReasonHistory table.

SELECT * FROM Sales.SalesReasonHistory;

SELECT * FROM Sales.SalesReason;

INSERT INTO Sales.SalesReason VALUES( 'Ejemplo', 'Ejemplo', '2002-06-01');

INSERT INTO Sales.SalesReason VALUES( 'Ejemplo2', 'Ejemplo2', '2002-06-01');

DELETE FROM Sales.SalesReason WHERE Name = 'Ejemplo2';

