/* CURSOR */

-- Mirar información fila por fila o cambiar la información

-- CREAR CURSOR
USE prueba;

DECLARE cursorEjemplo CURSOR
FOR  SELECT * FROM employee

OPEN cursorEjemplo 
FETCH NEXT FROM cursorEjemplo

CLOSE cursorEjemplo
DEALLOCATE cursorEjemplo

--  OTRO EJEMPLOOOOO DE CURSOR

DECLARE cursorEjemplo CURSOR SCROLL
FOR  SELECT * FROM employee

OPEN cursorEjemplo 
											--  ///////////////// IMPORTANTE. MIRAR ESTO !!!!!!!!!!!!!!!!!!!
FETCH NEXT FROM cursorEjemplo  -- Con fetch next : va mostrando los datos siguientes
								-- para ver un valor anterior, se usa: fetch prior
								-- FETCH FIRST   :  muestra el 1º registro
								-- FETCH LAST    :  muestra el último registro

CLOSE cursorEjemplo
DEALLOCATE cursorEjemplo


-------------------------------------------
SELECT * FROM customer

DECLARE @number AS BIGINT;
DECLARE @name AS NVARCHAR(50);
DECLARE @area AS NVARCHAR(4);
DECLARE @region AS NVARCHAR(10);
DECLARE @revenue AS INT;
DECLARE @orders AS INT;

DECLARE cursorEjemplo CURSOR
FOR  SELECT * FROM customer

OPEN cursorEjemplo 
FETCH NEXT FROM cursorEjemplo INTO @number, @name, @area, @region, @revenue, @orders

WHILE(@@FETCH_STATUS = 0)
	BEGIN
		print @name+ '		'+ @area + '	  '+ @region;
		-- HACER AQUI SELECT, INSERT, DELETE  - Lo que se quiera hacer
		FETCH NEXT FROM cursorEjemplo INTO @number, @name, @area, @region, @revenue, @orders

	END



CLOSE cursorEjemplo
DEALLOCATE cursorEjemplo

/*  *************************************************************************** **/


-- TRIGGER

--Borramos la tabla customer y la creamos de nuevo con una nueva columna

DROP TABLE customer;
CREATE TABLE customer (
		number BIGINT PRIMARY KEY IDENTITY(1,1),
		name NVARCHAR (50) NOT NULL,
		area NVARCHAR(4) NOT NULL,
		region NVARCHAR(10) NOT NULL,
		revenue INT,
		orders INT
		);

		DROP PROCEDURE spAddCustomer ;
CREATE PROCEDURE spAddCustomer ( @name NVARCHAR (50), @area NVARCHAR(4), @region NVARCHAR(10), @revenue INT, @orders INT)
AS
	INSERT INTO customer(name, area, region, revenue, orders) VALUES (@name, @area, @region ,@revenue, @orders)
GO 

EXEC spAddCustomer  'Sample Company 2', 'APAC','Singapore', 200.000,20;
EXEC spAddCustomer  'Sample Company 3', 'APAC','Australia', 430.000,150;
EXEC spAddCustomer  'Sample Company ','NA', 'US', 120.000,15;
EXEC spAddCustomer  'European Company ','EALA', 'France', 62.000,95;
EXEC spAddCustomer  'European Company 2 ','EALA', 'Spain',150.000,42;
EXEC spAddCustomer  'European Company 3 ','EALA', 'Spain', 700.000,37;

SELECT * FROM customer


/* AFTER  triggers */

--TRIGGER DML
CREATE TRIGGER triggerCustomerDML ON customer
AFTER INSERT,UPDATE, DELETE                               --AFTER INSERT     /  AFTER UPDATE   /   AFTER DELETE
AS
BEGIN
	PRINT 'DML event has been raised to table Customer';
	RETURN
END

--TRIGGER DDL
CREATE TRIGGER triggerCustomerDML ON customer
-- AFTER   /  FOR  tipoEvento|Grupoevento
AS
BEGIN
	PRINT 'DML event has been raised to table Customer';
	RETURN
END

/* CREO TRIGGER - PARA COMPROBAR QUE NO SE INSERTEN DOS CATEGORIAS CON EL MISMO NOMBRE  */
-- TRIGGER FOR INSERT
CREATE TRIGGER trCategoryNotRepeat ON category FOR INSERT
AS
IF(SELECT COUNT(*) FROM inserted, category WHERE inserted.categoryname = category.categoryname)>1
BEGIN
ROLLBACK TRANSACTION
PRINT 'El nombre de la categoría ya existe';
END
ELSE
PRINT 'Categoría insertada en la base de datos';
GO

SELECT * FROM category
-- Intento insertar una categoria que existe para comprobar si funciona el trigger
INSERT INTO category (categoryname)
			values('Maquillaje');

/* TRIGGER -  Dispara un error si se intenta borrar más de un registro a la vez */
CREATE TRIGGER trDelete1Customer
ON customer FOR DELETE
AS
IF(SELECT COUNT(*) FROM deleted)>1  -- se cuentan cuantos registros se han eliminado
BEGIN
RAISERROR('No se puede eleminar más de un trabajador a la vez', 16, 1);
ROLLBACK TRAN
END
GO
-- Compruebo si funciona el trigger
DELETE customer WHERE number in (1,4);


/* TRIGGER INSTEAD OF  */
CREATE TRIGGER triggerCustomerDML
ON customer
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	PRINT 'DML event overwritten. Nothing has happened. DROP de trigger "triggerCustomerDML"';
	RETURN
END

--borro el trigger
DROP  TRIGGER triggerCustomerDML

--                  *******************************************************
/*				DDL trigger           */
CREATE TRIGGER safety 
ON DATABASE
FOR DROP TABLE, ALTER TABLE
AS 
BEGIN
	PRINT 'You must disable trigger "safety" to drop or alter tables!';
	ROLLBACK
END
--borro el trigger
DROP TRIGGER safety;

-- ********************************************************************
/*		Transaction			*/

BEGIN TRANSACTION
BEGIN TRY
	DELETE FROM customer WHERE orders = 95
	INSERT INTO customer (name, area, region) VALUES ('European Company5', 'EALA', 'France');
	COMMIT TRANSACTION  -- se realizan los cambios de forma definitiva
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @msg NVARCHAR (MAX);
	SELECT @msg = ERROR_MESSAGE();
	RAISERROR ('Error occurred: $s', 20, 101, @msg) WITH LOG
END CATCH



-- CATALOG VIEWS  - Ver metadatos de las vistas creadas

USE prueba
SELECT name, recovery_model_desc
	FROM sys.databases;
GO

-- Información de la estructura de la base de datos

SELECT *
	FROM information_schema.tables
	WHERE table_type='base table';
GO

-- informacion de las vistas

SELECT * 
	FROM information_schema.tables 
	WHERE table_type = 'view';
GO
-- para más info, mirar  https://docs.microsoft.com/es-es/sql/relational-databases/system-information-schema-views/system-information-schema-views-transact-sql?view=sql-server-2017

/*			INDICES				*/
-- crear un indice agrupado - clustered - solo puede existir uno por tabla - y se crea automatica+ con la primary key
CREATE CLUSTERED INDEX clusteredIndex
	ON customer(name);

--crear un indice no agrupado - nonclustered - se puede crear sin poner nonclustered, dejar solo create index....
CREATE NONCLUSTERED INDEX nonclusteredIndex
	ON customer(area, region);

-- Ver indices de una tabla
EXEC sp_helpindex addresses;
EXEC sp_helpindex customer;

-- PARA VER TODOS LOS INDICES DE LA BD 
SELECT name FROM sysindexes;

-- Para regenerar un indice que ya existia, se le podrían agregar campos o  eliminar algun campo del indice
CREATE NONCLUSTERED INDEX nonclusteredIndex
	ON customer(area, region)
	WITH drop_existing;  -- esto NO SE PUEDE usar con restriccion primary key ni unique

-- eliminar un indice
DROP INDEX customer.nonclusteredIndex;  --nombreDeLaTabla.nombreDelIndice

-- Podemos eliminar un indice, a partir de una consulta a si existe ese indice
IF EXISTS(SELECT name from sysindexes WHERE name='nonclusteredIndex')
	DROP INDEX customer.nonclusteredIndex;

