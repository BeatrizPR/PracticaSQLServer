USE prueba

  /*CREATE TABLES */
 
 CREATE TABLE employee (
	employeeid BIGINT PRIMARY KEY IDENTITY (1,1), 
	employeename NVARCHAR (50) NOT NULL
	); 

	CREATE TABLE addresses (
		addressid BIGINT PRIMARY KEY IDENTITY(1,1),
		employeeid BIGINT UNIQUE REFERENCES employee (employeeid),
		address NVARCHAR (50),
		country NVARCHAR (50) DEFAULT 'USA'
		);

	CREATE TABLE category (
	categoryid BIGINT PRIMARY KEY IDENTITY(1,1),
	categoryname NVARCHAR (60)
	);

	CREATE TABLE products (
		productid BIGINT PRIMARY KEY IDENTITY(1,1),
		unitprice BIGINT,
		nameproduct NVARCHAR (50),
		categoryid BIGINT REFERENCES category (categoryid)
		);
	
 /*INSERT INTO */
 INSERT INTO employee (employeename) 
	VALUES ('Tom James'),
			('Paula García'),
			('Marta Lopez'),
			( 'Juan Gonzalez'),
			( 'Pablo Martín'),
			( 'Lorena Martín'),
			( 'Minie Mouse'),
			('Caperucita Roja'),
			('Lobo Feroz');

			

/*INSERT INTO employee (employeeid, employeename) 
	VALUES (34225,'Tom James'),
			(34226, 'Paula García'),
			(34227, 'Marta Lopez'),
			(34228, 'Juan Gonzalez'),
			(34229, 'Pablo Martín'),
			(34230, 'Lorena Martín'),
			(34231, 'Minie Mouse'),
			(34232, 'Caperucita Roja'),
			(34233, 'Lobo Feroz');*/

INSERT INTO addresses ( employeeid, address, country) 
	VALUES (1, 'Calle Marques de Larios', 'ES'),
			(2, 'Calle Marie Curie', 'ES'),
			(3, 'Avenidad de Andalucía', 'ES'),
			(4,'Avenidad Juan Lopez Peñalver', 'ES'),
			(5, 'Calle Nueva', 'ES'),
			(6, 'Avenidad Juan XXIII', 'ES'),
			(7, 'Calle Kandinsky', 'ES'),
			(8, 'Avenidad Europa', 'ES'),
			(9, 'Calle Severo Ochoa', 'ES');

INSERT INTO category (categoryname)
	VALUES ('Vestimenta'),
	('Complementos'),
	('Zapatos');

INSERT INTO products (unitprice,nameproduct, categoryid) 
	VALUES	(20, 'camiseta',1),
			(35,'pantalón chinos',1),
			(5, 'camiseta corta',1),
			(4.50,'top',1 ),
			(16, 'pantalón corto',1),
			(2, 'diadema',2),
			(1.75, 'pinza de pelo',2),
			(25, 'camiseta estampada',1),
			(17, 'vaqueros',1),
			(5.95, 'cinturón blanco',2),
			(7.80, 'chanclas de playa', 3);
	

/*INSERT INTO address (addressid, employeeid, address, country) 
	VALUES (1, 34225,'Calle Marques de Larios', 'ES'),
			(2, 34226, 'Calle Marie Curie', 'ES'),
			(3, 34227, 'Avenidad de Andalucía', 'ES'),
			(4, 34228, 'Avenidad Juan Lopez Peñalver', 'ES'),
			(5, 34229, 'Calle Nueva', 'ES'),
			(6, 34230, 'Avenidad Juan XXIII', 'ES'),
			(7, 34231, 'Calle Kandinsky', 'ES'),
			(8, 34232, 'Avenidad Europa', 'ES'),
			(9, 34233, 'Calle Severo Ochoa', 'ES'); */



-- GET ALL employeeid FROM address table
SELECT employeeid FROM addresses;

--GET employeeid from employee table 
SELECT employeeid FROM employee;

SELECT * FROM products;
SELECT * FROM category;

/* INNER JOIN */

SELECT employeename, address FROM employee
INNER JOIN addresses ON employee.employeeid = addresses.employeeid;


/* DROP  - Borrar las tablas */
DROP TABLE employee
DROP TABLE address
DROP TABLE products

/* UPDATE - ACTUALIZAR UN DATO*/
USE prueba
UPDATE employee SET employeename = 'Jim Doe' WHERE employeeid = 1;

/* DELETE  - Borrar un campo */

				/*inserto un valor para borrarlo */
				INSERT INTO employee (employeename) 
				VALUES ('Tom James');
				SELECT * FROM employee;

DELETE FROM employee WHERE employeeid= 10;


/* SUBCONSULTAS */

SELECT productid, unitprice FROM products
WHERE unitprice >= (SELECT AVG(unitprice) FROM products);

-- AVG(x)  - para hacer la media de un valor 
USE prueba

--Con la subconsulta obtengo el precio minimo de los productos por categoria  
SELECT categoryid, productid, nameproduct, unitprice 
FROM products AS P1
WHERE unitprice =
(SELECT MIN(unitprice) FROM products AS P2 WHERE P1.categoryid = P2.categoryid);

/* VARIABLES  ESCALARES*/

DECLARE @size AS BIGINT = 10;

DECLARE @name AS NVARCHAR (50);
SET @name = 'Jim Doe';

-- ESTO DE ARRIBA ES LO MISMO QUE lo de ABAJO 

DECLARE @name AS NVARCHAR (50) = 'Jim Doe';

-- CREO UNA TABLA a partir de una variable 

DECLARE @customer TABLE (
	coll BIGINT NOT NULL
);

INSERT INTO @customer VALUES(1587);

-- SELECT de la TABLA CREADA A TRAVÉS DE LA VARIABLE 

DECLARE @name AS NVARCHAR(50);
SET @name = 'Jim Doe';
SELECT @name;

/****************************************/

DECLARE @customer TABLE (
	number BIGINT NOT NULL,
	name NVARCHAR (50) NOT NULL,
	area NVARCHAR(4) NOT NULL,
	revenue INT
	);

INSERT INTO @customer VALUES (1587, 'Sample Company', 'NA', 120.000);
SELECT number, name, area, revenue FROM @customer;


/****/

DECLARE @c1 BIGINT;
DECLARE @customer TABLE(
	number BIGINT NOT NULL,
	name NVARCHAR (50) NOT NULL
);
INSERT INTO @customer VALUES (1587, 'Sample Company');

SELECT @c1 = number FROM @customer WHERE name= 'Sample Company';

/* EJEMPLO DE VARIABLE PARA HACER UN CONTADOR AL RECORRER UN BUCLE */

-- Create the table.
CREATE TABLE TestTable (cola int, colb char(3));
GO
SET NOCOUNT ON;
GO
-- Declare the variable to be used.
DECLARE @MyCounter int;

-- Initialize the variable.
SET @MyCounter = 0;

-- Test the variable to see if the loop is finished.
WHILE (@MyCounter < 26)
BEGIN;
   -- Insert a row into the table.
   INSERT INTO TestTable VALUES
       -- Use the variable to provide the integer value
       -- for cola. Also use it to generate a unique letter
       -- for each row. Use the ASCII function to get the
       -- integer value of 'a'. Add @MyCounter. Use CHAR to
       -- convert the sum back to the character @MyCounter
       -- characters after 'a'.
       (@MyCounter,
        CHAR( ( @MyCounter + ASCII('a') ) )
       );
   -- Increment the variable to count this iteration
   -- of the loop.
   SET @MyCounter = @MyCounter + 1;
END;
GO
SET NOCOUNT OFF;
GO
-- View the data.
SELECT cola, colb
FROM TestTable;
GO
DROP TABLE TestTable;
GO

/****************************************************************************/

/* PROCEDIMIENTOS ALMACENADOSS    - STORED PROCEDURES 

		Creo tabla customer*/
		CREATE TABLE customer (
		number BIGINT NOT NULL,
		name NVARCHAR (50) NOT NULL,
		area NVARCHAR(4) NOT NULL,
		revenue INT
		);


CREATE PROCEDURE spAddCustomer (@number BIGINT, @name NVARCHAR (50), @area NVARCHAR(4), @revenue INT)
AS
	INSERT INTO customer(number, name, area, revenue) VALUES (@number, @name, @area, @revenue)
GO 


EXEC spAddCustomer 5678, 'Sample Company 2', 'APAC', 200.000;
EXEC spAddCustomer 5679, 'Sample Company 3', 'APAC', 430.000;
EXEC spAddCustomer 5680, 'Sample Company ','NA', 120.000;
EXEC spAddCustomer 5681, 'European Company ','EALA', 62.000;
EXEC spAddCustomer 5682, 'European Company 2 ','EALA', 150.000;
EXEC spAddCustomer 5683, 'European Company 3 ','EALA', 700.000;



--BORRAR PROCEDIMIENTO 

DROP PROCEDURE spAddCustomer;
GO

-- ALTER PROCEDURE   -  MODIFICAR UN PROCEDIMIENTO 
ALTER PROCEDURE  spAddCustomer
-- OBTENGO LOS DATOS 

SELECT * FROM customer;

-- CREATE PROCEDURE WITH BEGIN AND END

CREATE PROCEDURE spGetCustomerNumber (@name NVARCHAR(50), @number BIGINT OUTPUT)
AS
BEGIN
		SELECT number FROM customer WHERE name=@name;
END
GO

-- Ejecuto el procedimiento almacenado con un valor name y un number
EXEC spGetCustomerNumber 'Sample Company', 1587;


/*		IF  /  ELSE			*/

DECLARE @var1 AS INT, @var2 AS INT;
SET @var1 = 1;
SET @var2 = 2;

IF @var1 = @var2
	PRINT 'The variables are equal';

ELSE 
	PRINT 'The variables are not equal';


/* PROCEDIMIENTO ALAMACENADO  */
-- Procedimiento que compara dos numeros

CREATE PROCEDURE spCompareCustomerNumbers (@number1 BIGINT, @numer2 BIGINT)
AS
BEGIN 
	IF @number1 = @numer2
		PRINT 'same customer number';

	ELSE 
		PRINT 'different customer numbers';

END


EXEC spCompareCustomerNumbers 1587,5678;

EXEC spCompareCustomerNumbers 5679, 5679;


/*		WHILE		*/

DECLARE @count AS INT = 0;
WHILE @count < 10
BEGIN
	SET @count +=1;
	print @count;
END;

-- PROCEDURE para sacar los 100 primeros números 
-- a partir del número que se le pasa como parámetro

CREATE PROCEDURE spCount100From (@i INTEGER)
AS
BEGIN 
	DECLARE @count AS INT = 1;
	WHILE @count <=100
	BEGIN 
		SET @count +=1;
		SET @i +=1;
		PRINT CAST (@i AS CHAR(3));
	END
END
GO

--ALTER PROCEDURE

ALTER PROCEDURE spCount100From (@i INTEGER)
AS
BEGIN 
	DECLARE @count AS INT = 1;
	WHILE @count <=100
	BEGIN 
		SET @count +=1;
		SET @i +=1;
		PRINT CAST (@i AS CHAR(3));
	END
END
GO

EXEC spCount100From 10;  --Print all numbers from 10 to 110


-- PROCEDURE WITH RETURN

CREATE PROCEDURE spCount50Max100From (@i INTEGER)
AS
BEGIN
	DECLARE @count AS INT = 0;
	WHILE @count <=50
	BEGIN
		SET @count+=1;
		SET @i +=1;
		IF @i <=100
			PRINT CAST(@i AS CHAR(3));
		ELSE
			RETURN -- directly exist while loop and stored procedure
		END
END
GO

EXEC spCount50Max100From 12;
EXEC spCount50Max100From 72;
EXEC spCount50Max100From 40;


/*		TRY / CATCH			*/

BEGIN TRY
	--Table does not exist; object name resolution
	SELECT * FROM NonExistentTable;
END TRY
BEGIN CATCH
	SELECT 
		ERROR_NUMBER() AS ErrorNumber
		,ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- MIRAR ESTO : https://docs.microsoft.com/es-es/sql/t-sql/language-elements/return-transact-sql?view=sql-server-2017 


/*		 SCALAR FUNCTION		*/

ALTER FUNCTION getCustomerName (@number int)
RETURNS NVARCHAR(50) -- lo que devuelve la función
AS
BEGIN
	DECLARE @name NVARCHAR(50);
	SELECT @name=name FROM customer WHERE number = @number
	RETURN @name
END

--SELECT @number, getCustomerName(@number) AS name
SELECT 5678, dbo.getCustomerName (5678) AS name   -- devulve el numero con el nombre


-- **************************

CREATE FUNCTION getCustomerNamesWithHigherCustomerNumber
(
@number BIGINT
)
RETURNS TABLE AS RETURN -- devuelve una tabla
(
SELECT name FROM customer WHERE number > @number
)

-- ****************************************************

CREATE FUNCTION getCustomerAsTable (@number BIGINT, @name NVARCHAR(50))
RETURNS @returnable TABLE (c1 BIGINT, c2 NVARCHAR(50))
AS
BEGIN
	INSERT INTO @returnable
	SELECT @number, @name 
RETURN 
END
GO


/**		CONVERTIR DATOS de un TIPO  a OTRO		 **/

SELECT CAST('20120101' AS datetime);

SELECT CONVERT(datetime, '20120101');

-- HACER CASTEO CON TRY por si ocurre algún error

SELECT   
    CASE WHEN TRY_CONVERT(float, 'test') IS NULL   
    THEN 'Cast failed'  
    ELSE 'Cast succeeded'  
END AS Result;  
GO  

-- ---------------------------------------
SELECT   
    CASE WHEN TRY_CONVERT(datetime, '20120101') IS NULL   
    THEN 'Cast failed'  
    ELSE 'Cast succeeded'  
END AS Result;  
GO  
-- DEVUELVE la fecha y hora actual
SELECT SYSDATETIME();

-- devuelve fecha y hora sin tantos numeros como sysdatetime
SELECT CURRENT_TIMESTAMP

-- 
SELECT GETUTCDATE  -- NO FUNCIONAAAA

-- formatear la fecha con guiones pasandole números
SELECT DATEFROMPARTS(2012,02,12);

-- Le suma 2 año a la fecha que se le pase
SELECT DATEADD(year, 2, '20120212');
-- Le suma un mes a la fecha que se le pase
SELECT DATEADD(month, 1, '20120212');
-- CALCULA LOS DIAS QUE HAY ENTRE LA FECHA 1º y la 2º que se le pasen
SELECT DATEDIFF (day, '20110212', '20120212');

--CONCATENACION  con +
SELECT 1+1;
SELECT 'Hola '+' prueba';

--SUBSTRING para devolver algo  - eliminando, para dividir
SELECT employeename, SUBSTRING(employeename, 1, 1) AS Initial  
FROM employee 

-- String leng
SELECT DATALENGTH(2012-02-12)

/*			 VIEWS			*/

CREATE VIEW ESEmployees
AS
SELECT addressid, a.employeeid, address, country, employeename FROM addresses AS a inner join employee AS e ON a.employeeid = e.employeeid WHERE country = 'ES';
GO

--Ejecuto la vista
SELECT * FROM ESEmployees;
/*   INSERTO DATOS ANTES DE HACER LA VISTA */
					Insert into employee (employeename)
					values ('Pitufo azul'),
						('Bella'),
						('Capitan América'),
						('Pedro Jiménez'),
						('Isabel Granada'),
						('Sofía Lara');

					Insert into addresses (employeeid, address, country)
					values (11, 'Rue Picasso','FR'),
						(12, 'Rue Pisarro','FR'),
						(13, 'Street Charles Dickens','EN'),
						(14, 'Street Harry Potter', 'EN'),
						(15, 'Rue Marie Curie', 'FR');

-- Consulta para hacer la vista
Select addressid, a.employeeid, address, country, employeename from addresses as a inner join employee as e on a.employeeid = e.employeeid where country = 'ES';


/* CREO OTRA VISTA CON EL TOTAL DE LOS PRODUCTOS Y SU PRECIO  */
-- Creo la tabla orderSale y le introduzco datos
CREATE TABLE orderSale(
	orderid BIGINT PRIMARY KEY IDENTITY (1,1), 
	productid BIGINT REFERENCES products (productid),
	qty BIGINT DEFAULT 0,
	orderDate date
	); 
	INSERT INTO orderSale (productid, qty)
	VALUES (1, 2),
			(2,1),
			(10, 5),
			(7,2),
			(4,17),
			(9,25);
	INSERT INTO orderSale (productid, qty, orderDate)
	VALUES (1, 8, '2016-08-24'),
			(2,9, '2017-10-05'),
			(10, 26, '2017-12-18'),
			(7,32, '2018-05-24'),
			(4,57, '2018-09-16'),
			(9,75, '2019-04-27');
	--CREO LA VISTA

CREATE VIEW TotalSales
AS
SELECT products.productid, (orderSale.qty * products.unitprice) AS totalSum  FROM products
INNER JOIN orderSale ON products.productid = orderSale.productid
WHERE orderSale.orderDate >= '20140101';

/* ALTER A VIEW */

ALTER VIEW TotalSales
AS
SELECT products.productid, (orderSale.qty * products.unitprice) AS totalSum FROM products
INNER JOIN orderSale ON products.productid = orderSale.productid
WHERE orderSale.orderDate < '20171220'
AND orderSale.orderDate >= '20140101';

/* DROP a VIEW */
SELECT * FROM TotalSales;
DROP VIEW TotalSales;


/* ORDER BY  -  ORDENAR POR */
SELECT number, name, area FROM customer ORDER BY name;

/* GROUP BY  - Agrupar por   - HACER COUNT, SUM, AVG  */

SELECT area, COUNT(*)  AS c FROM customer GROUP BY area;

SELECT area, SUM(revenue) AS 'revenue sum' FROM customer GROUP BY area;

SELECT area, AVG(revenue) AS revenue_average FROM customer GROUP BY area;

SELECT area, MIN(revenue) AS revenue_min FROM customer GROUP BY area;

SELECT area, MAX(revenue) AS revenue_max FROM customer GROUP BY area;

