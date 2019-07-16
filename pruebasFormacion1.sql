

-- CONTINUACION de pruebasFormacion


/* Multiple grouping  */

--Borramos la tabla customer y la creamos de nuevo con una nueva columna

DROP TABLE customer;
CREATE TABLE customer (
		number BIGINT PRIMARY KEY IDENTITY(1,1),
		name NVARCHAR (50) NOT NULL,
		area NVARCHAR(4) NOT NULL,
		region NVARCHAR(10) NOT NULL,
		revenue INT
		);


CREATE PROCEDURE spAddCustomer ( @name NVARCHAR (50), @area NVARCHAR(4), @region NVARCHAR(10), @revenue INT)
AS
	INSERT INTO customer(name, area, region, revenue) VALUES (@name, @area, @region ,@revenue)
GO 

EXEC spAddCustomer  'Sample Company 2', 'APAC','Singapore', 200.000;
EXEC spAddCustomer  'Sample Company 3', 'APAC','Australia', 430.000;
EXEC spAddCustomer  'Sample Company ','NA', 'US', 120.000;
EXEC spAddCustomer  'European Company ','EALA', 'France', 62.000;
EXEC spAddCustomer  'European Company 2 ','EALA', 'Spain',150.000;
EXEC spAddCustomer  'European Company 3 ','EALA', 'Spain', 700.000;

SELECT * FROM customer

/*		Grouping sets	 */

--SELECT area, region, SUM(revenue) as sum_revenue FROM customer GROUP BY GROUPING(area, region); --/// NO FUNCIONA
--DELETE FROM customer WHERE number = 8

SELECT area, Null AS region, SUM(revenue) AS sum_revenue FROM customer GROUP BY area
UNION ALL
SELECT null as area, region, SUM(revenue) AS sum_revenue FROM customer GROUP BY region;

/*		CUBE	 */
-- operador cube muestra todas las posibles convinaciones de los campos en la lista
SELECT area, region, SUM(revenue) as sum_revenue FROM customer GROUP BY CUBE(area, region);

/*		Rollup	*/
-- muestra todos los posibles prefijos dados en los campos, el primer campo muestra todas las convinaciones posibles
SELECT area, region, SUM(revenue) as sum_revenue FROM customer GROUP BY ROLLUP(area, region);

/*		HAVING	 */

SELECT area, region, SUM(revenue) as sum_revenue FROM customer GROUP BY ROLLUP(area, region) HAVING area='EALA';

/*		PIVOT	*/
/*PIVOT gira una expresión con valores de tabla convirtiendo los valores únicos de una columna 
de la expresión en varias columnas en la salida y ejecuta agregaciones donde son necesarias en cualquier valor de columna 
que se deje en la salida final. 

UNPIVOT no reproduce el resultado de la expresión con valores de tabla original porque las filas se han combinado. 
Además, los valores null de la entrada de UNPIVOT desaparecen en la salida.
*/

SELECT region, APAC, NA, EALA FROM (
SELECT area, region, revenue FROM customer) AS rawData
PIVOT(SUM(revenue) FOR area IN (APAC, NA, EALA)) AS pivotRules;

/*		UNPIVOT			*/
/* UNPIVOT no reproduce el resultado de la expresión con valores de tabla original 
porque las filas se han combinado. Además, los valores null de la entrada de UNPIVOT desaparecen en la salida.*/
SELECT area, region, revenue FROM  t
UNPIVOT(revenue FOR area in (APAC, NA, EALA)) AS unpvtRules;

/*		ROW_NUMBER		*/
-- Devuelve el número de fila
SELECT orderid, qty, ROW_NUMBER() OVER (ORDER BY qty) AS r FROM orderSale;

/*		 RANK		*/
--Devuelve el rango de cada fila en la partición de un conjunto de resultados. 
--El rango de una fila es uno más el número de rangos anteriores a la fila en cuestión.
SELECT orderid, qty, RANK() OVER(ORDER BY qty) AS r FROM orderSale;

/*		DENSE_RANK		*/
--Esta función devuelve el rango de cada fila dentro de una partición del conjunto de resultados, sin espacios en los valores de clasificación.
--El rango de una fila específica es uno más el número de valores de rango distintos anteriores a esa fila específica.

SELECT orderid, qty, DENSE_RANK() OVER (ORDER BY qty) AS r FROM orderSale;

/*		NTILE		*/
--Distribuye las filas de una partición ordenada en un número especificado de grupos. 
--Los grupos se numeran a partir del uno. Para cada fila, NTILE devuelve el número del grupo al que pertenece la fila.

SELECT orderid, qty, NTILE(2) OVER (ORDER BY qty) AS r FROM orderSale;
