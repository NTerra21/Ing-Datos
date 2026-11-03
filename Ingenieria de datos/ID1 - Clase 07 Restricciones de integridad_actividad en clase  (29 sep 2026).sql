/* UADE*/
/* INGENIERIA DE DATOS 1*/
/* 2do CUATRIMESTRE 2026*/
/* Clase 7: Ejercicios Restricciones*/
/* Martes 8/9/2026*/

use uade_id1_2c2026;

/*Ejercicio Constraints
Crear las siguientes tablas y aplicar restricciones según se indica:
 LIBROS (isbn, título, precio, cantidad (not null))
 AUTORES (id_author, email (unique)
 LIBROS_AUTORES (isbn (PK, FK), authored (PK, FK))
Restricciones:
1. Agregar restricción UNIQUE al campo título de la tabla LIBROS;
2. Agregar restricción NOT NULL al campo precio de la tabla LIBROS;
3. Modificar la restricción NOT NULL del campo precio en la tabla LIBROS e incluir una
restricción de tipo CHECK para que el valor sea mayor que 0;
4. Eliminar la restricción UNIQUE del campo email de la tabla AUTORES;
5. Eliminar cualquiera de las restricciones de foreign key;
6. Eliminar la clave primaria (luego que la foreign key referenciada es eliminada);
7. Agregar un atributo en la tabla autores e incluirle una restricción.
*/


-- Creación tabla Libros
create table libros(
					isbn numeric(15) primary key,
					titulo varchar(120),
					precio decimal(9,2),
					cantidad numeric(5) not null);

create table autores(
					id_author numeric(3) primary key,
					email varchar(50) unique);

create table libros_autores(
							isbn numeric(15),
							id_author numeric(3),
							constraint fk_isbn foreign key (isbn) references libros(isbn),
							constraint fk_author foreign key (id_author) references autores(id_author),
							primary key (isbn, id_author));

			
-- 1. Agregar restricción UNIQUE al campo título de la tabla LIBROS;
--COMPLETAR
INSERT INTO libros 
  (isbn, titulo, precio, cantidad)
VALUES
  (01, "Avatar", 4000 , 40),
  (02, "Segunda Guerra", 5500, 35)

-- 2. Agregar restricción NOT NULL al campo precio de la tabla LIBROS;
--COMPLETAR

-- 3. Modificar la restricción NOT NULL del campo precio en la tabla LIBROS e incluir una restricción de tipo CHECK para que el valor sea mayor que 0;
--COMPLETAR

-- 4. Eliminar la restricción UNIQUE del campo email de la tabla AUTORES;
--COMPLETAR

-- 5. Eliminar cualquiera de las restricciones de foreign key;
--COMPLETAR

-- 6. Eliminar la clave primaria (luego que la foreign key referenciada es eliminada);
--COMPLETAR

-- 7. Agregar un atributo en la tabla autores e incluirle una restricción.
--COMPLETAR

SELECT * FROM libros
