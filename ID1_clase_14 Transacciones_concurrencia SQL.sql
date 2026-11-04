/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Transacciones SQL: Práctica de Concurrencia*/

use uade_id1_2c2026;

-- ========================================
-- SETUP: Creamos un ambiente de pruebas
-- ========================================
-- Eliminamos y recreamos la tabla para evitar conflictos
IF OBJECT_ID('dbo.BankAccounts', 'U') IS NOT NULL
    DROP TABLE dbo.BankAccounts;

CREATE TABLE dbo.BankAccounts (
    AccountID INT PRIMARY KEY,
    AccountHolder NVARCHAR(100),
    Balance DECIMAL(10,2)
);

-- Insertamos algunos datos de ejemplo
INSERT INTO dbo.BankAccounts (AccountID, AccountHolder, Balance)
VALUES 
(1, 'Alice', 1000.00),
(2, 'Bob', 1500.00);

DBCC useroptions

-- ========================================
-- 1. READ UNCOMMITTED (Dirty Read)
-- ========================================
-- Abrir DOS sesiones (Sesión A y Sesión B) para observar esto.
-- Sesión A: Iniciar una transacción pero NO HACER COMMIT.
BEGIN TRANSACTION;
UPDATE dbo.BankAccounts
SET Balance = Balance - 100
WHERE AccountID = 1;
-- No hacer commit aún!

-- Sesión B: Ver los cambios sin el commit
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT * FROM dbo.BankAccounts
WHERE AccountID = 1;

-- 👉 Sesión B puede ver el saldo de Alice ya reducido (aún sin que se haya hecho el commit).
-- A esto se lo llama una "LECTURA SUCIA" o "DIRTY READ".

-- Para limpiar:
-- En la Sesion A:
-- ROLLBACK;
ROLLBACK;

-- ========================================
-- 2. READ COMMITTED (Nivel por default)
-- ========================================
-- Sesión A: Iniciar una transacción y actualizar.
BEGIN TRANSACTION;
UPDATE dbo.BankAccounts
SET Balance = Balance - 50
WHERE AccountID = 2;
-- No hacer el commit aún!

-- Sesión B: Intentar leeer el saldo de Bob
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT * FROM dbo.BankAccounts
WHERE AccountID = 2;

-- 👉 Sesión B **ESPERARÁ** hasta que la Sesión A haga commit o rollback.
-- No se permiten lecturas sucias.

-- Para limpiar:
-- En la Sesión A:
-- ROLLBACK;
ROLLBACK;
-- =====================================================
-- 3. REPEATABLE READ (Prevenir lecturas (No-Repetibles)
-- =====================================================
-- Sesión A: Seteamos el nivel de aislamiento e iniciamos una transacción 
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;

SELECT * FROM dbo.BankAccounts
WHERE AccountID = 1;

-- Mantenemos ABIERTA la Sesión A.

-- Sesión B: Intentar ACTUALIZAR el mismo registro
BEGIN TRANSACTION;
UPDATE dbo.BankAccounts
SET Balance = Balance + 300
WHERE AccountID = 1;

-- 👉 Sesión B **QUEDARÁ BLOQUEADA** hasta que la Sesión A hace commmit o rollback.
-- Previene a otras transacciones de hacer cambios en datos que fueron leidos. 

-- Para limpiar:
-- En Sesión A:
-- COMMIT;
COMMIT;
select * from dbo.BankAccounts;
-- En Sesión B:
-- La ACTUALIZACIÓN ahora finalizará.
rollback;
-- ========================================
-- 4. SERIALIZABLE (Nivel más alto de Aislamiento, Previene Phantom Read)
-- ========================================
-- Sesión A: Seteamos el nivel de aislamiento a SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;

SELECT * FROM dbo.BankAccounts
WHERE Balance > 1000;

-- En la Sesión A, mantenemos abierta la transacción.

-- Sesión B: Intentar INSERTAR un nuevo registro que concordaría con la consulta previa
BEGIN TRANSACTION;
INSERT INTO dbo.BankAccounts (AccountID, AccountHolder, Balance)
VALUES (3, 'Michael', 1250.00);

-- 👉 Sesión B **SE BLOQUEARA** porque SERIALIZABLE bloquea el rango.

-- Para limpiar:
-- En Sesión A:
-- COMMIT;
COMMIT;

-- In Sesión B:
-- Se procederá con el INSERT.

-- ========================================
-- Resumen Rápido:
-- ========================================
-- READ UNCOMMITTED  -> Permite Dirty Reads.
-- READ COMMITTED    -> No permite Dirty Reads (Default).
-- REPEATABLE READ   -> Previene Lecturas No-Repetibles (pero no Fantasmas).
-- SERIALIZABLE      -> Aislamiento Completo (Previene Lecturas Fantasmas y todo el resto).