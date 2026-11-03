/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Clase 12: Actividad Joins SQL */
/* 20 oct 2026 */

use uade_id1_2c2026;

/*
Practica SQL Joins
Dadas las siguientes tablas, realizar las consultas SQL indicadas.
*/

-- ==================================================================================================================
-- Tablas base (Fabricante / Producto)
-- ==================================================================================================================
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS fabricante;

CREATE TABLE fabricante (
    codigo INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE producto (
    codigo INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    codigo_fabricante INT NOT NULL,
    CONSTRAINT fk_producto_fabricante
        FOREIGN KEY (codigo_fabricante) REFERENCES fabricante(codigo)
);

-- Datos fabricante
INSERT INTO fabricante (codigo, nombre) VALUES
(1, 'Asus'),
(2, 'Lenovo'),
(3, 'Hewlett-Packard'),
(4, 'Samsung'),
(5, 'Seagate'),
(6, 'Crucial'),
(7, 'Gigabyte'),
(8, 'Huawei'),
(9, 'Xiaomi');

-- Datos producto
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES
(1,  'Disco Duro Sata3 1TB',              86.99,  5),
(2,  'Memoria RAM DDR4 8GB',              120.00, 6),
(3,  'Disco SSD 1 TB',                    150.99, 4),
(4,  'GeForce GTX 1050TI',                185.00, 7),
(5,  'GeForce GTX 1080 Xtreme',           755.00, 6),
(6,  'Monitor 24" LED Full HD',           202.00, 1),
(7,  'Monitor 27" LED Full HD',           245.99, 1),
(8,  'Notebook Yoga 520',                 559.00, 2),
(9,  'Notebook Ideapad 320',              444.00, 2),
(10, 'Impresora HP Deskjet 3720',          59.99,  3),
(11, 'Impresora HP Laserjetpro m26nw',    100.00, 3);

-- Visualizacion de tablas
SELECT * FROM fabricante;
SELECT * FROM producto;

-- ==================================================================================================================
-- EJERCICIO 1
-- Devolver una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos.
-- ==================================================================================================================
SELECT
    p.nombre AS nombre_producto,
    p.precio,
    f.nombre AS nombre_fabricante
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo;

-- ==================================================================================================================
-- EJERCICIO 2
-- Devolver una lista con el nombre del producto, precio y nombre de fabricante de todos los productos.
-- Ordenar el resultado por el nombre del fabricante, en orden alfabetico.
-- ==================================================================================================================
SELECT
    p.nombre AS nombre_producto,
    p.precio,
    f.nombre AS nombre_fabricante
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo
ORDER BY f.nombre ASC;

-- ==================================================================================================================
-- EJERCICIO 3
-- Devolver una lista con el codigo del producto, nombre del producto, codigo del fabricante y nombre del fabricante, de todos los productos.
-- ==================================================================================================================
SELECT
    p.codigo AS codigo_producto,
    p.nombre AS nombre_producto,
    f.codigo AS codigo_fabricante,
    f.nombre AS nombre_fabricante
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo;

-- ==================================================================================================================
-- EJERCICIO 4
-- Devolver el nombre del producto, su precio y el nombre de su fabricante, del producto mas barato.
-- ==================================================================================================================
SELECT TOP 1
    p.nombre AS nombre_producto,
    p.precio,
    f.nombre AS nombre_fabricante
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo
ORDER BY p.precio ASC;

-- ==================================================================================================================
-- EJERCICIO 5
-- Devolver el nombre del producto, su precio y el nombre de su fabricante, del producto mas caro.
-- ==================================================================================================================
SELECT TOP 1
    p.nombre AS nombre_producto,
    p.precio,
    f.nombre AS nombre_fabricante
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo
ORDER BY p.precio DESC;

-- ==================================================================================================================
-- EJERCICIO 6
-- Devolver una lista de todos los productos del fabricante Lenovo.
-- ==================================================================================================================
SELECT
    p.codigo,
    p.nombre,
    p.precio,
    f.nombre AS nombre_fabricante
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo
WHERE f.nombre = 'Lenovo';

-- ==================================================================================================================
-- EJERCICIO 7
-- Devolver una lista de todos los productos del fabricante Crucial que tengan un precio mayor que USD 200.
-- ==================================================================================================================
SELECT
    p.codigo,
    p.nombre,
    p.precio,
    f.nombre AS nombre_fabricante
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo
WHERE f.nombre = 'Crucial'
  AND p.precio > 200;

-- ==================================================================================================================
-- EJERCICIO 8
-- Devolver un listado con todos los productos de los fabricantes
-- Asus, Hewlett-Packard y Seagate, sin utilizar el operador IN.
-- ==================================================================================================================
SELECT
    p.codigo,
    p.nombre,
    p.precio,
    f.nombre AS nombre_fabricante
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo
WHERE f.nombre = 'Asus'
   OR f.nombre = 'Hewlett-Packard'
   OR f.nombre = 'Seagate';

-- ==================================================================================================================
-- EJERCICIO 9
-- Devolver un listado con todos los productos de los fabricantes
-- Asus, Hewlett-Packard y Seagate, utilizando el operador IN.
-- ==================================================================================================================
SELECT
    p.codigo,
    p.nombre,
    p.precio,
    f.nombre AS nombre_fabricante
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo
WHERE f.nombre IN ('Asus', 'Hewlett-Packard', 'Seagate');

-- ==================================================================================================================
-- EJERCICIO 10
-- Devolver un listado con el nombre y el precio de todos los productos de los fabricantes cuyo nombre termine por la vocal "e".
-- ==================================================================================================================
SELECT
    p.nombre AS nombre_producto,
    p.precio
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo
WHERE f.nombre LIKE '%e';

-- ==================================================================================================================
-- EJERCICIO 11
-- Devolver un listado con el nombre y el precio de todos los productos cuyo nombre de fabricante contenga el caracter "w" en su nombre.
-- ==================================================================================================================
SELECT
    p.nombre AS nombre_producto,
    p.precio
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo
WHERE f.nombre LIKE '%w%';

-- ==================================================================================================================
-- EJERCICIO 12
-- Devolver un listado con el nombre de producto, precio y nombre de fabricante, de todos los productos que tengan un precio mayor o igual a USD 180.
-- Ordenar el resultado en primer lugar por el precio (descendente) y en segundo lugar por el nombre (ascendente).
-- ==================================================================================================================
SELECT
    p.nombre AS nombre_producto,
    p.precio,
    f.nombre AS nombre_fabricante
FROM producto AS p
INNER JOIN fabricante AS f ON p.codigo_fabricante = f.codigo
WHERE p.precio >= 180
ORDER BY p.precio DESC, p.nombre ASC;

-- ==================================================================================================================
-- EJERCICIO 13
-- Devolver un listado con el codigo y el nombre de fabricante, solamente de aquellos fabricantes que tienen productos asociados en la base de datos.
-- ==================================================================================================================
SELECT DISTINCT
    f.codigo,
    f.nombre
FROM fabricante AS f
INNER JOIN producto AS p ON f.codigo = p.codigo_fabricante;
