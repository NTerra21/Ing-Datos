/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Transacciones SQL */
use uade_id1_2c2026;

--///TRANSACCIONES SQL

--creación de tabla Person
DROP TABLE if exists Person;
CREATE TABLE Person (
    PersonID int PRIMARY KEY IDENTITY(1,1),
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255),
	Age INT
)
 
GO

--inserción de registros en tabla Person 
INSERT INTO Person VALUES('Hayes', 'Corey','123  Wern Ddu Lane','LUSTLEIGH',23)
INSERT INTO Person VALUES('Macdonald','Charlie','23  Peachfield Road','CEFN EINION',45)
INSERT INTO Person VALUES('Frost','Emma','85  Kingsway North','HOLTON',26)
INSERT INTO Person VALUES('Thomas', 'Tom','59  Dover Road', 'WESTER GRUINARDS',51)
INSERT INTO Person VALUES('Baxter','Cameron','106  Newmarket Road','HAWTHORPE',46)
INSERT INTO Person VALUES('Townsend','Imogen ','100  Shannon Way','CHIPPENHAM',20)
INSERT INTO Person VALUES('Preston','Taylor','14  Pendwyallt Road','BURTON',19)
INSERT INTO Person VALUES('Townsend','Imogen ','100  Shannon Way','CHIPPENHAM',18)
INSERT INTO Person VALUES('Khan','Jacob','72  Ballifeary Road','BANCFFOSFELEN',11)
select * from person;

--muestra las transacciones en ejeecución
SELECT * FROM sys.dm_tran_session_transactions

/*IMPORTANTE*/
--definiendo una transacción implicita en SQL Server
--TRANSACCIONES IMPLICITAS cuentan con auto commit. No hay comienzo o fin de la transacción
--TRANSACCIONES EXPLICITAS tienen el comienzo, fin y rollback de las transacciones con los comandos BEGIN TRANSACTION, COMMIT TRAN, ROLLBACK TRAN
--En la transacción explicita, si un error ocurre en el medio se puede volver al inicio de la transacción lo que no puede ser realizado en el modo implícito 
--@TRANCOUNT devuelve el número de sentencia de BEGIN TRANSACTION de la sesión actual y se puede usar esta función para contar el número de 
--transacciones locales abiertas 

/* este modo implica que una nueva transacción es comenzada en forma implícita cuando la transacción anterior finaliza, pero cada
transacción es explícitamente terminada, generalmente con una instrucción COMMIT o ROLLBACK*/
SET IMPLICIT_TRANSACTIONS ON
UPDATE 
    Person 
SET 
    Lastname = 'Sawyer', 
    Firstname = 'Tom' 
WHERE 
    PersonID = 2 
SELECT 
    IIF(@@OPTIONS & 2 = 2, --> esta instrucción da 2 si el modo implícito está en ON, 0 si el modo implícito está en OFF
    'Implicit Transaction Mode ON', 
    'Implicit Transaction Mode OFF'
    ) AS 'Transaction Mode' 
SELECT 
    @@TRANCOUNT AS OpenTransactions --antes del commit @@TRANCOUNT muestra la cantidad de transacciones en ejecución
COMMIT TRAN 
SELECT 
    @@TRANCOUNT AS OpenTransactions --luego del commit

--definiendo una transacción en modo explicito
--se debe usar el comando BEGIN TRANSACTION para identificar el punto de comienzo de la transacción explícita

--sintaxis general
--BEGIN TRANSACTION [ {transaction_name | @tran_name_variable }
--    [WITH MARK ['description']]]

--transaction_name se usa para asignar un nombre específico a las transacciones
--@trans_var se usacomo variable definida por el usuario para contener el nombre de la transacción
--WITH MARK permite marcar una transacción particular en el archivo de log

--SELECT * FROM sys.dm_tran_session_transactions
SET IMPLICIT_TRANSACTIONS OFF
BEGIN TRAN
UPDATE Person 
SET    Lastname = 'Lucky', 
        Firstname = 'Luke' 
WHERE  PersonID = 1
 
SELECT @@TRANCOUNT AS OpenTransactions

--ejecución del commit
BEGIN TRAN
UPDATE Person 
SET    Lastname = 'Lucky', 
        Firstname = 'Luke' 
WHERE  PersonID = 1
SELECT @@TRANCOUNT AS OpenTransactions --antes del commit
COMMIT TRAN -- aplica los datos a la base de datos quedando permanentes
SELECT @@TRANCOUNT AS OpenTransactions --luego del commit
GO

commit;
--USO DEL ROLLBACK
--la sentencia ROLLBACK TRANSACTION ayuda a deshacer las modificaciones de los datos que fueron aplicadas por la transacción

select * from person;
SELECT * FROM Person WHERE PersonID=2 -- tabla previo a la modificación
BEGIN TRAN
UPDATE Person 
SET    Lastname = 'Donald', 
        Firstname = 'Duck'  WHERE PersonID=2
 
SELECT * FROM Person WHERE PersonID=2 -- tabla luego de la modificación
ROLLBACK TRAN  -- se vuelven atrás los cambios
 
SELECT * FROM Person WHERE PersonID=2 -- tabla luego de la modificación y de haber ejecutado la instrucción ROLLBACK TRAN


--USO DE SAVEPOINTS
--Los savepoints son de bastante utilidad cuando se necesita volver atrás parte de una transacción SQL. 
select * from person; --existen 9 registros en la tabla

BEGIN TRANSACTION	
INSERT INTO Person 
VALUES('Mouse', 'Micky','500 South Buena Vista Street, Burbank','California',43) --se inserta un registro en la tabla
SAVE TRANSACTION InsertStatement -- se define un save point (TODAS las actualizaciones previas a este punto no deberían ser deshechas con el rollback!!)
DELETE Person WHERE PersonID=3 -- como esta actualización está luego del savepoint se puede volver atrás con el rollback
SELECT * FROM Person 
ROLLBACK TRANSACTION InsertStatement
COMMIT
SELECT * FROM Person


--Auto Rollback de transacciones en SQL SERVER
--Generalmente, las transacciones incluyen más de un query. De esta manera, si alguna de las sentencias SQL devuelve un error entonces todas las modificaciones son
--borradas, y las sentencias pendientes no son ejecutadas. A este proceso se lo denomina Auto Rollback Transaction en SQL.
select * from person;
BEGIN TRAN
INSERT INTO Person 
VALUES('Bunny', 'Bugs','742 Evergreen Terrace','Springfield',54) -- se inserta un registro nuevo
    
UPDATE Person SET Age='MiddleAge' WHERE PersonID=7 -- se fuerza un error al actualizar en un campo INT (Age) con un campo caracter.
SELECT * FROM Person
 
COMMIT TRAN

SELECT * FROM Person


--OPCION WITH MARK
--SQL Server nos permite marcar y añadir una descripción a una transacción específica en los archivos de registro pudiendo generar un punto de recuperación. 
--Por ejemplo, cuando se produce una modificación accidental de datos en la base de datos y no conocemos la hora exacta de la modificación de datos,
--el esfuerzo de recuperación de datos puede llevar mucho tiempo. 
--Por esta razón, las transacciones marcadas pueden ser una solución útil para averiguar la hora exacta de las modificaciones de datos. 
--Para crear una transacción marcada, necesitamos dar un nombre a la transacción y también necesitamos añadir la sintaxis WITH MARK. 

-- Hacemos un full backup de la base de datos
BACKUP DATABASE ort_2c2025_2C TO DISK = 'C:\Users\AJ534VA\Downloads\UADE\2025\2C\UADE_test_2c2025'
GO

SELECT * FROM sys.dm_tran_session_transactions

BEGIN TRAN DeletePerson WITH MARK N'MarkedTransactionDescription' 
   DELETE Person WHERE PersonID BETWEEN 3 AND 4
   
   COMMIT TRAN DeletePerson

--La tabla 'logmarkhistory' almacena los detalles de cada transacción marcada que ha sido comiteada y es ubicada en la base de datos msdb
SELECT * FROM msdb.dbo.logmarkhistory
--GO
--
-- Permite identificar el nivel de aislamiento
DBCC USEROPTIONS

/*READ COMMITED
Es el nivel de aislamiento por default. Previene lecturas sucias (dirty reads) especificando que las sentencias no pueden leer valores de datos que han
sido modificados pero no aún comiteados por otras transacciones.*/

/*READ UNCOMMITED
Es el nivel más bajo de aislamiento. No previene las lecturas sucias (dirty reads).*/