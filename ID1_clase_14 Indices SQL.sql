/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Indices SQL */
use uade_id1_2c2026;

drop table if exists DiffIndexTypesDemo;
CREATE TABLE DiffIndexTypesDemo
( ID INT IDENTITY (1,1) PRIMARY KEY,
  Name Varchar(50) CONSTRAINT UQ_Name UNIQUE,
  ADDRESS NVARCHAR(MAX)
)


/* INDICE UNICO */

/*
Un índice único es usado para mantener la integridad de la información de las 
columnas sobre las cuales es creado al asegurar que no hay 
valores duplicados en el índice clave, y la filas de la tabla, sobre la cual 
el índice es creado. 
Esto asegura que la información será única basada en el índice clave, 
dependiendo de las características de la información que es almacenada 
en la columna del índice clave o la lista de columnas. 
Si el índice Único clave consiste en una columna, el SQL Server garantizará 
que cada valor en el índice clave es único. Por otro lado, el índice Único 
clave consiste en múltiples columnas, cada combinación de valores en ese 
índice clave debería ser único. 
Se puede definir ambos el índice Agrupado (Clustered) y No Agrupado 
(not Clustered) para ser único, siempre que la información en esos índices 
clave sean únicos.

Un índice Único será creado automáticamente cuando defines una restricción 
de CLAVE PRIMARIA o CLAVE UNICA en las columnas específicas. 
En todos los casos, crear un índice Único en la información única, en vez 
de crear un índice no único en la misma información, es muy recomendable, 
ya que ayuda al Optimizador de Consultas SQL Server a generar el plan de 
ejecución más eficiente basado en la información adicional útil provista 
por el índice.
*/

/*
Se observa que que un índice Único Agrupado será creado automáticamente 
en la columna ID de esa tabla, para aplicar la restricción PRIMARY KEY, 
y un índice Único No agrupado será creado automáticamente en la columna 
Nombre para aplicar la restricción UNIQUE
*/


/*
el índice que es creado automáticamente para aplicar cualquier restricción 
no puede ser dejado usando una declaración DROP INDEX T-SQL. Si tratamos de 
dejar el índice Único creado previamente para aplicar la restricción UNIQUE 
usando la declaración DROP INDEX T-SQL la declaración fallará, mostrando que 
no podemos dejar explícitamente ningún índice que es creado automáticamente 
para aplicar la restricción
*/

--Falla por estar asociado a la restricción Unique en el campo 'Name'
DROP INDEX UQ_Name ON DiffIndexTypesDemo


/*
Para dejar ese índice, deberíamos dejar la restricción que creó el índice, 
usando la declaración ALTER TABLE…DROP CONSTRAINT T-SQL
*/
ALTER TABLE DiffIndexTypesDemo DROP CONSTRAINT UQ_Name

/*
El Índice Único puede también ser creado manualmente, fuera de la restricción, 
al especificar la palabra clave UNIQUE en la declaración 
de creación de índice Agrupado o No Agrupado
*/
CREATE UNIQUE NONCLUSTERED INDEX IX_DiffIndexTypesDemo_Name ON DiffIndexTypesDemo (NAME)

/*
Un índice Único es usado para aplicar la singularidad de los valores de 
índice clave. Por ejemplo, el índice previo es usado para asegurar que 
ningún valor duplicado para la columna Nombre este disponible en la tabla. 
Si tratamos de ejecutar la declaración INSERT INTO de abajo que inserta dos 
nuevos registros con los mismos valores Nombre en la tabla:
*/

INSERT INTO DiffIndexTypesDemo VALUES ('John', 'Amman'),
                                       ('John', 'Zarqa')

/*
La declaración fallará, mostrando que no es permitido insertar valores 
duplicados para el nombre de la columna, que es aplicada por el índice Único 
creado, proveyendo los valores duplicados evitados
*/


/*Si tratamos de dejar el índice Único, usando la declaración INDEX T-SQL*/
DROP INDEX IX_DiffIndexTypesDemo_Name ON DiffIndexTypesDemo


/*
Luego ejecutas la misma declaración INSERT INTO, verás que los valores 
duplicados Nombre serán insertados exitosamente, 
no teniendo restricción o índice que aplica la singularidad de los valores 
de esa columna
*/
INSERT INTO DiffIndexTypesDemo VALUES ('John', 'Amman'),
                                       ('John', 'Zarqa')

--Verificamos los valores insertados
select * from DiffIndexTypesDemo
/*
Ahora, si tratamos de crear el índice Único otra vez en esa tabla, 
la declaración CREATE INDEX va a fallar, como la tabla ya ha duplicado 
valores en la columna Nombre
*/
CREATE UNIQUE NONCLUSTERED INDEX IX_DiffIndexTypesDemo_Name ON DiffIndexTypesDemo (NAME)


/*
Tampoco usando la operación de creación IGNORE_DUP_KEY funcionará con el 
índice UNIQUE. Si tratamos de activar esa opción, 
al crear el índice Único, para ignorar los valores duplicados existentes, 
la declaración fallará nuevamente mostrando que no podemos 
crear un índice Único con valores de índice clave duplicados 
disponibles en la tabla
*/
CREATE UNIQUE NONCLUSTERED INDEX IX_DiffIndexTypesDemo_Name ON DiffIndexTypesDemo (NAME) WITH (IGNORE_DUP_KEY=ON)


/*
Para ser capaz de crear el índice Único en la columna Nombre, deberíamos borrar 
o actualizar los valores duplicados. 
En nuestro caso, vamos a actualizar el segundo nombre duplicado usando 
la declaración UPDATE
*/
SELECT * FROM DiffIndexTypesDemo
UPDATE DiffIndexTypesDemo SET Name='Jack' where ID=4
SELECT * FROM DiffIndexTypesDemo


/*
Tratando de crear el índice Único después de resolver el problema de duplicado, el índice Único será creado exitosamente
*/
CREATE UNIQUE NONCLUSTERED INDEX IX_DiffIndexTypesDemo_Name ON DiffIndexTypesDemo (NAME)


/*
Podemos incluir otra columna en el índice Único clave, para aplicar la singularidad de combinación de las dos columnas, 
a diferencia de aplicarlo solamente en la columna Nombre. El CREATE INDEX de abajo será usado para crear un índice único 
que aplica la singularidad de la combinación de columnas ID y Nombre
*/
DROP INDEX IX_DiffIndexTypesDemo_Name ON DiffIndexTypesDemo
CREATE UNIQUE NONCLUSTERED INDEX IX_DiffIndexTypesDemo_Name ON DiffIndexTypesDemo (ID,NAME)
INSERT INTO DiffIndexTypesDemo VALUES ('John', 'Amman'),
                                       ('John', 'Zarqa')

select * from DiffIndexTypesDemo

/* INDICE FILTRADO */

/*
Un índice Filtrado es un índice No Agrupado (not Clustered) optimizado, 
introducido en SQL Server 2008, que usa un filtro predicado 
para mejorar el rendimiento de las consultas que recuperan bien definidos 
subgrupos de filas de la tabla, al indexar la única porción
de las filas de la tabla. El tamaño más pequeño del índice Filtrado, 
que consume una pequeña cantidad del espacio del disco, comparado 
con la tamaño de la tabla completa de índice, y mientras más precisas 
las estadísticas filtradas, que cubren las filas del índice filtrado 
con solo costo mínimo de mantenimiento, ayuda a mejorar el rendimiento de las consultas al generar una más óptima ejecución del plan.

La columna Nombre en la tabla previa puede ser considerada una columna Dispersa, 
con cerca de 99 % de la información conteniendo valores NULL. 
Antes de planear crear el índice, deberíamos entender las consultas que 
están recuperando información de la tabla. 
Teniendo todas las consultas buscando las filas con valores NOT NULL en las columnas Nombre, después será beneficioso para crear un índice 
Filtrado en la columna de Nombre, que va a ser más pequeño cuesta menos 
de mantener ya que contiene menos de 1 % de los valores de la columna, 
comparado con un índice de tabla llena que contiene todos los valores de la 
columna Nombre, al proveer un predicado filtrado,
*/

DROP TABLE DiffIndexTypesDemo
GO
CREATE TABLE DiffIndexTypesDemo
( ID INT IDENTITY (1,1) PRIMARY KEY,
  Name Varchar(50) ,
  ADDRESS NVARCHAR(MAX)
)
GO
 
/*
Después de crear la tabla, vamos a llenarla con 50.100 registros, proveyendo solo con 100 valores de valores de columna Nombre y 
50 mil filas con valores NULL para esa columna, usando las declaraciones INSERT INTO T-SQL de abajo:
*/
INSERT INTO DiffIndexTypesDemo VALUES ('John', 'Ramtha')
GO 100
INSERT INTO DiffIndexTypesDemo VALUES (NULL, 'Zarqa')
GO 50000


SET STATISTICS TIME ON
SET STATISTICS IO ON
 
SELECT Name FROM DiffIndexTypesDemo WHERE NAME ='John'

SELECT Name FROM DiffIndexTypesDemo WHERE NAME ='John'


/*
La columna Nombre en la tabla previa puede ser considerada una columna Dispersa, con cerca de 99 % de la información conteniendo valores NULL. 
Antes de planear crear el índice, deberíamos entender las consultas que están recuperando información de la tabla. 
Teniendo todas las consultas buscando las filas con valores NOT NULL en las columnas Nombre, después será beneficioso para crear un índice Filtrado 
en la columna de Nombre, que va a ser más pequeño cuesta menos de mantener ya que contiene menos de 1 % de los valores de la columna, comparado con un 
índice de tabla llena que contiene todos los valores de la columna Nombre, al proveer un predicado filtrado,
*/

CREATE INDEX IX_DiffIndexTypesDemo_Name ON DiffIndexTypesDemo (Name) WHERE NAME IS NOT NULL

SELECT Name FROM DiffIndexTypesDemo WHERE NAME ='John'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

DROP INDEX IX_DiffIndexTypesDemo_Name ON DiffIndexTypesDemo