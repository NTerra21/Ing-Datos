USE uade_id1_2c2026;

-- 1. Devolver una lista con el nombre del producto, precio y nombre de fabricante
SELECT 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio, 
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo;

-- 2. Devolver una lista con el nombre del producto, precio y nombre de fabricante ordenada alfabéticamente por fabricante
SELECT 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio, 
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
ORDER BY f.nombre ASC;

-- 3. Devolver una lista con el código del producto, nombre, código del fabricante y nombre del fabricante
SELECT 
    p.codigo AS Codigo_Producto, 
    p.nombre AS Nombre_Producto, 
    f.codigo AS Codigo_Fabricante, 
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo;
















-- 4. Devolver el nombre del producto, su precio y el nombre de su fabricante, del producto más barato.
SELECT TOP 1 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio, 
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
ORDER BY p.precio ASC;

-- 5. Devolver el nombre del producto, su precio y el nombre de su fabricante, del producto más caro.
SELECT TOP 1 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio, 
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
ORDER BY p.precio DESC;

-- 6. Devolver una lista de todos los productos del fabricante Lenovo.
SELECT 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio, 
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre = 'Lenovo';

-- 7. Devolver una lista de todos los productos del fabricante Crucial que tengan un precio mayor que USD 200.
SELECT 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio, 
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre = 'Crucial' AND p.precio > 200;

-- 8. Devolver un listado con todos los productos de los fabricantes Asus, Hewlett-Packard y Seagate, sin utilizar el operador IN.
SELECT 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio, 
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre = 'Asus' OR f.nombre = 'Hewlett-Packard' OR f.nombre = 'Seagate';


-- 1. Devolver un listado con todos los productos de los fabricantes Asus, Hewlett-Packard y Seagate, utilizando el operador IN.
SELECT 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio, 
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre IN ('Asus', 'Hewlett-Packard', 'Seagate');

-- 2. Devolver un listado con el nombre y el precio de todos los productos de los fabricantes cuyo nombre termine por la vocal “e”.
SELECT 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio,
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre LIKE '%e';

-- 3. Devolver un listado con el nombre y el precio de todos los productos cuyo nombre de fabricante contenga el carácter “w” en su nombre.
SELECT 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre LIKE '%w%';  

-- 4. Devolver un listado con el nombre de producto, precio y nombre de fabricante, de todos los productos que tengan un precio mayor o igual a USD 180. Ordenar por precio descendente y nombre ascendente.
SELECT 
    p.nombre AS Nombre_Producto, 
    p.precio AS Precio, 
    f.nombre AS Nombre_Fabricante
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE p.precio >= 180
ORDER BY p.precio DESC, p.nombre ASC;

-- 5. Devolver un listado con el código y el nombre de fabricante, solamente de aquellos fabricantes que tienen productos asociados en la base de datos.
SELECT DISTINCT 
    f.codigo AS Codigo_Fabricante, 
    f.nombre AS Nombre_Fabricante
FROM fabricante f
INNER JOIN producto p ON f.codigo = p.codigo_fabricante;