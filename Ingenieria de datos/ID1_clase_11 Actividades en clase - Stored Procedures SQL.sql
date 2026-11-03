/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Ejercicios Stored Procedures */
use uade_id1_2c2026;

-- ==================================================================================================================
-- EJERCICIO 1
-- En base a la tabla cuya definición se incluye más abajo, se pide crear un procedimiento sp_InsertarCliente 
-- que reciba el nombre y email como entrada, inserte el cliente y devuelva el ClienteId generado como 
-- parámetro de salida.
-- ==================================================================================================================
CREATE TABLE Clientes (
    ClienteId INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    Email NVARCHAR(100),
    FechaRegistro DATE DEFAULT GETDATE()
);

-- ==================================================================================================================
-- EJERCICIO 2
-- En base a la tabla cuya definición se incluye más abajo, se pide crear un procedimiento sp_TotalOrdenesCliente 
-- que reciba un ClienteId y devuelva el número total de órdenes realizadas como parámetro de salida. 
-- ==================================================================================================================
CREATE TABLE Ordenes (
    OrdenId INT PRIMARY KEY IDENTITY(1,1),
    ClienteId INT,
    FechaOrden DATE,
    Total DECIMAL(10,2)
);

-- ==================================================================================================================
-- EJERCICIO 3
-- En base a la tabla cuya definición se incluye más abajo, se pide crear un procedimiento sp_ListarProductosStockBajo
-- que liste todos los productos cuyo stock sea menor o igual a 10.
-- ==================================================================================================================
CREATE TABLE Productos (
    ProductoId INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    Stock INT,
    Precio DECIMAL(10,2)
);


-- ================================================================================================================
-- EJERCICIO 4
-- En base a la tabla cuya definición se incluye más abajo, se pide crear un un procedimiento sp_AumentarSalario 
-- que reciba el EmpleadoId, un porcentaje de aumento, actualice el salario y devuelva el nuevo salario como 
-- parámetro de salida.
-- ================================================================================================================
CREATE TABLE Empleados (
    EmpleadoId INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    DepartamentoId INT,
    Salario DECIMAL(10,2)
);

-- ================================================================================================================
-- EJERCICIO 5
-- En base a la tabla del ejercicio 3 (Productos), se pide crear un procedimiento sp_EliminarProductosSinStock 
-- que elimine todos los productos que tengan stock igual a 0.
-- ================================================================================================================
