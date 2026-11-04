/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Transacciones SQL: Actividades en clase*/

use uade_id1_2c2026;

USE [master];
GO

-- 1. Crear el Login a nivel del servidor (contenedor Docker)
CREATE LOGIN [UsuarioPrueba] WITH PASSWORD = 'TestPassword123!';
GO

-- 2. Entrar a tu base de datos de la materia
USE [uade_id1_2c2026];
GO

-- 3. Crear el usuario asociado al Login anterior
CREATE USER [UsuarioPrueba] FOR LOGIN [UsuarioPrueba];
GO

-- 4. Otorgar los permisos de lectura y escritura (opcional, basado en tu requerimiento anterior)
ALTER ROLE db_datareader ADD MEMBER [UsuarioPrueba];
ALTER ROLE db_datawriter ADD MEMBER [UsuarioPrueba];
GO




USE [uade_id1_2c2026];
GO

-- 1. Verificamos tu identidad actual (debería decir 'dbo' o tu usuario admin)
SELECT CURRENT_USER AS 'Identidad Actual';

-- 2. Cambiamos al perfil del usuario de prueba
EXECUTE AS USER = 'UsuarioPrueba';

-- 3. Comprobamos que el cambio fue exitoso (debería decir 'UsuarioPrueba')
SELECT CURRENT_USER AS 'Identidad Actual';

-- =======================================================
-- ACÁ EJECUTAS TUS PRUEBAS (SELECT, INSERT, UPDATE, etc.)
-- =======================================================
EXECUTE AS USER = 'dbo';
-- 4. Volvemos a tu perfil de Administrador original
REVERT;

-- 5. Comprobamos que volviste a ser Administrador
SELECT CURRENT_USER AS 'Identidad Actual';
GO




/* EJERCICIO 1 - USO MODO IMPLICITO
Activa el modo de transacciones impl�citas con SET IMPLICIT_TRANSACTIONS ON. Luego realiza una inserci�n en una tabla Clientes y otra en la tabla 
Pedidos. Verifica que ninguna de las operaciones se confirme hasta que se ejecute un COMMIT. Utiliza ROLLBACK si ocurre alg�n error.
*/ 

-- Definici�n tabla Clientes
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100),
    Email NVARCHAR(100)
);

-- Definici�n tabla Pedidos
CREATE TABLE Pedidos (
    PedidoID INT PRIMARY KEY IDENTITY,
    ClienteID INT,
    FechaPedido DATE DEFAULT GETDATE(),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);


-- 1. Activamos el modo de transacciones implícitas
SET IMPLICIT_TRANSACTIONS ON;
GO

BEGIN TRY
    -- Al estar en modo implícito, este INSERT inicia automáticamente una transacción
    -- (No es necesario escribir BEGIN TRANSACTION)
    INSERT INTO Clientes (Nombre, Email) 
    VALUES ('Nicolas Terradas', 'nicolas@ejemplo.com');

    -- Capturamos el ID del cliente recién insertado
    DECLARE @UltimoClienteID INT = SCOPE_IDENTITY();

    -- Realizamos la inserción en la tabla de Pedidos
    INSERT INTO Pedidos (ClienteID) 
    VALUES (@UltimoClienteID);

    -- Verificamos el estado: @@TRANCOUNT nos indica cuántas transacciones están abiertas
    PRINT 'Transacciones activas antes de confirmar: ' + CAST(@@TRANCOUNT AS VARCHAR(5));

    -- Si llegamos hasta acá sin errores, confirmamos las operaciones
    COMMIT TRANSACTION;
    
    PRINT 'Las inserciones se confirmaron exitosamente (COMMIT).';
END TRY
BEGIN CATCH
    -- Si ocurre algún error en los INSERTs, entra en este bloque
    IF @@TRANCOUNT > 0
    BEGIN
        -- Deshacemos cualquier cambio pendiente
        ROLLBACK TRANSACTION;
        PRINT 'Ocurrió un error. Se ejecutó un ROLLBACK.';
        PRINT 'Error: ' + ERROR_MESSAGE();
    END
END CATCH;
GO

-- 2. Verificamos que la transacción ya se cerró
PRINT 'Transacciones activas al finalizar: ' + CAST(@@TRANCOUNT AS VARCHAR(5));

-- 3. Desactivamos el modo implícito para dejar la sesión como estaba por defecto
SET IMPLICIT_TRANSACTIONS OFF;
GO













/* EJERCICIO 2 - TRANSACCION EXPLICITA CON COMMIT Y ROLLBACK
Implementa una transacci�n expl�cita utilizando BEGIN TRAN, COMMIT y ROLLBACK en la siguiente operaci�n:
	-Actualiza el stock de un producto en la tabla Productos restando la cantidad vendida.
	-Inserta un nuevo registro en la tabla Ventas.
	 Si alguna de las operaciones falla (por ejemplo, stock insuficiente), revierte toda la transacci�n.
*/

-- Definici�n tabla Productos
CREATE TABLE Productos2 (
    Producto2ID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100),
    Stock INT,
    Precio DECIMAL(10,2)
);

-- Definici�n tabla Ventas
CREATE TABLE Ventas (
    VentaID INT PRIMARY KEY IDENTITY,
    Producto2ID INT,
    Cantidad INT,
    FechaVenta DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (Producto2ID) REFERENCES Productos2(Producto2ID)
);


/* EJERCICIO 3 - MANEJO DE ERRORES CON TRASACCIONES EXPLICITAS
Crea una transacci�n expl�cita para transferir saldo entre dos cuentas en la tabla Cuentas.
Resta un valor de una cuenta origen.
	-Suma el mismo valor a una cuenta destino.
	-Usa un bloque TRY...CATCH para detectar errores y ejecutar un ROLLBACK en caso de excepci�n. 
	 Aplica COMMIT solo si ambas operaciones se ejecutan correctamente.
*/

-- Definici�n tabla Cuentas
CREATE TABLE Cuentas (
    CuentaID INT PRIMARY KEY IDENTITY,
    NombreTitular NVARCHAR(100),
    Saldo DECIMAL(10,2)
);

/* EJERCICIO 4 - MARCADO DE TRANSACCION INTERMEDIA CON SAVE TRANSACTION
Dentro de una transacci�n expl�cita, realiza tres operaciones:
	1. Insertar un nuevo cliente.
	2. Marcar un punto de guardado con SAVE TRANSACTION punto1.
	3. Insertar un pedido vinculado al cliente.
	4. Insertar detalles de la factura.
En caso de error en la tercera operaci�n, vuelve al punto de guardado (ROLLBACK TRAN punto1) sin perder el cliente insertado.
*/

-- Definici�n tabla Factura
CREATE TABLE Facturas (
    FacturaID INT PRIMARY KEY IDENTITY,
    ClienteID INT,
    Fecha DATETIME DEFAULT GETDATE(),
    MontoTotal DECIMAL(10,2),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Definici�n tabla DetalleFactura
CREATE TABLE DetalleFactura (
    DetalleID INT PRIMARY KEY IDENTITY,
    FacturaID INT,
    Producto2ID INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    FOREIGN KEY (FacturaID) REFERENCES Facturas(FacturaID),
    FOREIGN KEY (Producto2ID) REFERENCES Productos2(Producto2ID)
);

/* EJERCICIO 5 - TRANSACCION FALLIDA Y RECUPERACION PARCIAL
Simula un escenario donde varias operaciones est�n encadenadas en una transacci�n:
	-Registrar una factura.
	-Insertar varios �tems en DetalleFactura.
	-Registrar el pago en Pagos.
Si ocurre un error al insertar los �tems, vuelve a un punto de guardado intermedio despu�s de registrar la factura (usa SAVE TRAN). Finaliza la transacci�n adecuadamente con COMMIT o ROLLBACK, 
seg�n corresponda.
*/

-- Definici�n tabla Pagos
CREATE TABLE Pagos (
    PagoID INT PRIMARY KEY IDENTITY,
    FacturaID INT,
    Monto DECIMAL(10,2),
    FechaPago DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (FacturaID) REFERENCES Facturas(FacturaID)
);