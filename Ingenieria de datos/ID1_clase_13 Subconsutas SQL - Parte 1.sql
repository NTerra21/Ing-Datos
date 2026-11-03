/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Subconsultas SQL - Parte 1 */
use uade_id1_2c2026;

drop table if exists fabricantes;
create table fabricantes(
	codigo int identity(1,1) primary key,
	name varchar(250) not null);

set identity_insert fabricantes ON;  

insert into fabricantes (codigo,name) values 
(1, 'Asus') , 
(2, 'Lenovo'), 
(3, 'Hewlett-Packard') , 
(4, 'Samsung') , 
(5, 'Seagate'), 
(6, 'Crucial'), 
(7, 'Gigabyte'), 
(8, 'Huaweic'), 
(9, 'Xiaomi');
set identity_insert fabricantes OFF;

drop table if exists productos;
create table productos (
	codigo_m int identity(1,1) primary key not null,
	name varchar(250) not null,
	precio float,
	codigo_f int not null);


set identity_insert productos ON;  
insert into productos (codigo_m, name, precio, codigo_f) values 
(1, 'Disco Duro Sata3 1TB', 86.99, 5), 
(2, 'Memoria RAM DDR4 8GB', 120, 6), 
(3, 'Disco SSD 1 TB', 150.99, 4), 
(4, 'GeForce GTX 1050TI', 185, 7), 
(5, 'GeForce GTX 1080 Xtreme', 755, 6), 
(6, 'Monitor 24" LED Full HD', 202, 1), 
(7, 'Monitor 27" LED Full HD', 245.99, 1), 
(8, 'Notebook Yoga 520', 559, 2), 
(9, 'Notebook Ideapad 320', 444, 2), 
(10, 'Impresora HP Deskjet 3720', 59.99, 3), 
(11, 'Impresora HP Laserjetpro m26nw', 100, 3);

set identity_insert productos OFF;

--Verificamos los productos insertados
select * from productos;

--Verificamos los fabricantes insertados
select * from fabricantes;


--1 Devolver todos los productos del fabricante 'Lenovo'
/*
*/
SELECT * 
FROM productos
WHERE codigo_f = (SELECT codigo FROM fabricantes WHERE name = 'Lenovo');

--2 Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del fabricante Lenovo. (Sin utilizar INNER JOIN).
/*
*/
SELECT *
FROM productos
WHERE precio = (SELECT MAX(precio) FROM productos WHERE codigo_f = ( SELECT codigo FROM fabricantes WHERE name = 'Lenovo'));

--3)Lista el nombre del producto más caro del fabricante Lenovo.
/*
*/
SELECT *
FROM productos
WHERE codigo_f = (SELECT codigo FROM fabricantes WHERE name = 'Hewlett-Packard')
  AND precio = (
      SELECT MAX(precio)
      FROM productos
      WHERE codigo_f = (SELECT codigo FROM fabricantes WHERE name = 'Hewlett-Packard')
  );

--4) Lista el nombre del producto más barato del fabricante Hewlett-Packard.
/*
*/
SELECT *
FROM productos
WHERE codigo_f = (SELECT codigo FROM fabricantes WHERE name = 'Hewlett-Packard')
  AND precio = (
      SELECT MIN(precio)
      FROM productos
      WHERE codigo_f = (SELECT codigo FROM fabricantes WHERE name = 'Hewlett-Packard')
  );

--5) Devuelve todos los productos de la base de datos que tienen un precio mayor o igual al producto más caro del fabricante Lenovo.

/*
*/
SELECT * FROM productos WHERE precio >=
(SELECT MAX(precio) FROM productos WHERE codigo_f = (SELECT codigo from fabricantes WHERE name = 'Lenovo'));

--6) Lista todos los productos del fabricante Asus que tienen un precio superior al precio medio de todos sus productos.

SELECT * 
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos WHERE codigo_f = (SELECT codigo FROM fabricantes WHERE name = 'Asus')) AND 
codigo_f = (SELECT codigo FROM fabricantes WHERE name = 'Asus');


--7) Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o NOT IN).
/*
*/
SELECT name
FROM fabricantes
WHERE codigo IN (SELECT codigo_f FROM productos);


--8) Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando IN o NOT IN).
/*
 */
SELECT name
FROM fabricantes
WHERE codigo NOT IN (SELECT codigo_f FROM productos);


--9)  Lista el nombre de cada fabricante con el nombre y el precio de su producto más caro.
/*
*/
SELECT f.name AS fabricante,
       p.name AS producto,
       p.precio
FROM productos p
INNER JOIN fabricantes f
    ON f.codigo = p.codigo_m
INNER JOIN (
    SELECT codigo_f, MAX(precio) AS max_precio
    FROM productos
    GROUP BY codigo_f
) AS maxp
    ON p.codigo_f = maxp.codigo_f
   AND p.precio = maxp.max_precio;

--10) Devuelve un listado de todos los productos que tienen un precio mayor o igual a la media de todos los productos de su mismo fabricante.
/*
*/
SELECT * 
FROM productos
WHERE precio >= (SELECT AVG(precio) FROM productos WHERE codigo_f = codigo_f);


--11) Lista el nombre del producto más caro del fabricante Lenovo.
/*
*/
SELECT name 
FROM productos
WHERE precio = (SELECT MAX(precio) FROM productos WHERE codigo_f = (SELECT codigo FROM fabricantes WHERE name = 'Lenovo'));
