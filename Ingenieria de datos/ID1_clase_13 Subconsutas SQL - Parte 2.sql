/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Subconsultas SQL - Parte 2 */

use uade_id1_2c2026;

--Creamos tablas de fabricantes
DROP TABLE if exists manufacturers;
CREATE TABLE manufacturers (
  manufacturer_id INT identity(1,1) NOT NULL,
  manufacturer VARCHAR(50) NOT NULL,
  create_date DATETIME NOT NULL DEFAULT SYSDATETIME(),
  last_update DATETIME NOT NULL DEFAULT SYSDATETIME(),
  PRIMARY KEY (manufacturer_id) );

--Creamos tabla de aviones 
DROP TABLE if exists airplanes;
CREATE TABLE airplanes (
  plane_id INT identity(1,1) NOT NULL,
  plane VARCHAR(50) NOT NULL,
  manufacturer_id INT NOT NULL,
  engine_type VARCHAR(50) NOT NULL,
  engine_count TINYINT NOT NULL,
  max_weight BIGINT NOT NULL,
  wingspan DECIMAL(5,2) NOT NULL,
  plane_length DECIMAL(5,2) NOT NULL,
  parking_area AS (wingspan * plane_length) PERSISTED,
  icao_code CHAR(4) NOT NULL,
  create_date DATETIME NOT NULL DEFAULT SYSDATETIME(),
  last_update DATETIME NOT NULL DEFAULT SYSDATETIME(),
  PRIMARY KEY (plane_id),
  CONSTRAINT fk_manufacturer_id 
  FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (manufacturer_id));


--Insertamos registros en la tabla de fabricantes
INSERT INTO manufacturers (manufacturer)
VALUES ('Airbus'), ('Beagle Aircraft Limited'), ('Beechcraft'), ('Boeing'), 
  ('Bombardier'), ('Cessna'), ('Dassault Aviation'), ('Embraer'), ('Piper');
 
--Insertamos registros en la tabla de aviones
INSERT INTO airplanes 
  (plane, manufacturer_id, engine_type, engine_count, 
    wingspan, plane_length, max_weight, icao_code)
VALUES
  ('A340-600',1,'Jet',4,208.17,247.24,837756,'A346'),
  ('A350-800 XWB',1,'Jet',2,212.42,198.58,546700,'A358'),
  ('A350-900',1,'Jet',2,212.42,219.16,617295,'A359'),
  ('A380-800',1,'Jet',4,261.65,238.62,1267658,'A388'),
  ('A380-843F',1,'Jet',4,261.65,238.62,1300000,'A38F'),
  ('A.109 Airedale',2,'Piston',1,36.33,26.33,2750,'AIRD'),
  ('A.61 Terrier',2,'Piston',1,36,23.25,2400,'AUS6'),
  ('B.121 Pup',2,'Piston',1,31,23.17,1600,'PUP'),
  ('B.206',2,'Piston',2,55,33.67,7500,'BASS'),
  ('D.5-108 Husky',2,'Piston',1,36,23.17,2400,'D5'),
  ('Baron 56 TC Turbo Baron',3,'Piston',2,37.83,28,5990,'BE56'),
  ('Baron 58 (and current G58)',3,'Piston',2,37.83,29.83,5500,'BE58'),
  ('Beechjet 400 (same as MU-300-10 Diamond II)',3,'Jet',2,43.5,48.42,15780,'BE40'),
  ('Bonanza 33 (F33A)',3,'Piston',1,33.5,26.67,3500,'BE33'),
  ('Bonanza 35 (G35)',3,'Piston',1,32.83,25.17,3125,'BE35'),
  ('747-8F',4,'Jet',4,224.42,250.17,987000,'B748'),
  ('747-SP',4,'Jet',4,195.67,184.75,696000,'B74S'),
  ('757-300',4,'Jet',2,124.83,178.58,270000,'B753'),
  ('767-200',4,'Jet',2,156.08,159.17,315000,'B762'),
  ('767-200ER',4,'Jet',2,156.08,159.17,395000,'B762'),
  ('Learjet 24',5,'Jet',2,35.58,43.25,13000,'LJ24'),
  ('Learjet 24A',5,'Jet',2,35.58,43.25,12499,'LJ24'),
  ('Challenger (BD-100-1A10) 350',5,'Jet',2,69,68.75,40600,'CL30'),
  ('Challenger (CL-600-1A11) 600',5,'Jet',2,64.33,68.42,36000,'CL60'),
  ('Challenger (CL-600-2A12) 601',5,'Jet',2,64.33,68.42,42100,'CL60'),
  ('414A Chancellor',6,'Piston',2,44.17,36.42,6750,'C414'),
  ('421C Golden Eagle',6,'Piston',2,44.17,36.42,7450,'C421'),
  ('425 Corsair-Conquest I',6,'Turboprop',2,44.17,35.83,8600,'C425'),
  ('441 Conquest II',6,'Turboprop',2,49.33,39,9850,'C441'),
  ('Citation CJ1 (Model C525)',6,'Jet',2,46.92,42.58,10600,'C525'),
  ('EMB 175 LR',8,'Jet',2,85.33,103.92,85517,'E170'),
  ('EMB 175 Standard',8,'Jet',2,85.33,103.92,82673,'E170'),
  ('EMB 175-E2',8,'Jet',2,101.67,106,98767,'E170'),
  ('EMB 190 AR',8,'Jet',2,94.25,118.92,114199,'E190'),
  ('EMB 190 LR',8,'Jet',2,94.25,118.92,110892,'E190');

select * from manufacturers;
select * from airplanes;

--1. Subconsulta escalar: Construyendo una subconsulta escalar básica (tablas diferentes)  
/*Devuelve un único valor, que se pasa a la consulta externa a través de una de sus cláusulas. 
La subconsulta se utiliza en lugar de otras expresiones posibles, como constantes o nombres de columnas. 
Por ejemplo, la siguiente sentencia SELECT (la consulta externa) incluye una subconsulta en la condición de búsqueda de la cláusula WHERE:
*/
SELECT plane_id, plane
FROM airplanes
WHERE manufacturer_id = 
  (SELECT manufacturer_id FROM manufacturers 
    WHERE manufacturer = 'Beechcraft');

--2. Subconsulta escalar: Construyendo una subconsulta escalar básica (misma tabla)
/*
La subconsulta del ejemplo anterior recupera datos de una segunda tabla, en este caso, fabricantes. 
Una subconsulta podría recuperar datos de la misma tabla. 
Por ejemplo, la subconsulta de la siguiente sentencia SELECT recupera el valor promedio de peso_máximo de la tabla aviones y la externa los aviones que la superaron:
*/
SELECT plane_id, plane, max_weight
FROM airplanes
WHERE max_weight > 
  (SELECT AVG(max_weight) FROM airplanes); 

--3. SUBCONSULTA CORRELACIONADA: EJEMPLO 1
/*  
Una de las características más valiosas de una subconsulta es su capacidad para hacer referencia a la consulta externa desde dentro de la subconsulta.
Este tipo de subconsulta, denominada subconsulta correlacionada, puede devolver datos específicos de la fila actual evaluada por la sentencia externa.
Por ejemplo, la siguiente sentencia SELECT utiliza una subconsulta correlacionada para calcular el peso medio de los aviones de cada fabricante, en lugar de para todos los aviones:
*/
WITH avg_weights AS (
  SELECT manufacturer_id, ROUND(AVG(max_weight), 0) AS avg_weight
  FROM airplanes
  GROUP BY manufacturer_id
)
SELECT m.manufacturer_id, m.manufacturer, 
       a.plane_id, a.plane, a.max_weight
FROM airplanes a
INNER JOIN manufacturers m 
  ON a.manufacturer_id = m.manufacturer_id
INNER JOIN avg_weights aw 
  ON a.manufacturer_id = aw.manufacturer_id
WHERE a.max_weight > aw.avg_weight;

    
--4. SUBCONSULTA CORRELACIONADA: EJEMPLO 2
/*
Se podría utilizar esta misma subconsulta en la cláusula SELECT como una de las expresiones de columna. 
En el siguiente ejemplo, he añadido la subconsulta después de la columna peso_máximo y se asignó el alias peso_avg a la nueva columna:
*/
SELECT 
    a.manufacturer_id,
    a.plane_id,
    a.plane,
    a.max_weight,
    (SELECT ROUND(AVG(a2.max_weight), 0)
       FROM airplanes a2
       WHERE a2.manufacturer_id = a.manufacturer_id) AS avg_weight
FROM airplanes a
WHERE a.max_weight > 
  (SELECT ROUND(AVG(a3.max_weight), 0)
     FROM airplanes a3
     WHERE a3.manufacturer_id = a.manufacturer_id);
    

--5. SUBCONJUNTA CORRELACIONADA: EJEMPLO 3
/*
En el ejemplo anterior, utilizamos una subconsulta para crear una columna generada. 
Podríamos utilizar una subconsulta para crear una columna generada aún más compleja. 
En el siguiente ejemplo, añadimos una columna generada llamada amt_over, que resta el peso medio devuelto por la subconsulta del peso de la columna max_weight:
*/
SELECT 
    a.manufacturer_id,
    a.plane_id,
    a.plane,
    a.max_weight,
    (SELECT ROUND(AVG(a2.max_weight), 0)
       FROM airplanes a2
       WHERE a2.manufacturer_id = a.manufacturer_id) AS avg_weight,
    (a.max_weight - 
      (SELECT ROUND(AVG(a3.max_weight), 0)
         FROM airplanes a3
         WHERE a3.manufacturer_id = a.manufacturer_id)
    ) AS amt_over
FROM airplanes a
WHERE a.max_weight > 
  (SELECT ROUND(AVG(a4.max_weight), 0)
     FROM airplanes a4
     WHERE a4.manufacturer_id = a.manufacturer_id); 


--6. TRABAJANDO CON FILA DE DATOS
/*
Hasta ahora, todos los ejemplos han devuelto valores escalares, pero las subconsultas también podrían devolver valores múltiples. 
Por ejemplo, una subconsulta para agregar los datos de una tabla, calcular promedios específicos en esos datos (devueltos como una única fila) y recuperar filas de la misma tabla que superen esos promedios, que es lo que he hecho en la siguiente sentencia SELECT:
*/
SELECT 
    m.manufacturer,
    a.plane_id,
    a.plane,
    a.max_weight,
    a.parking_area,
    (SELECT ROUND(AVG(a2.max_weight), 0)
       FROM airplanes a2
       WHERE a2.manufacturer_id = a.manufacturer_id) AS avg_weight,
    (SELECT ROUND(AVG(a2.parking_area), 0)
       FROM airplanes a2
       WHERE a2.manufacturer_id = a.manufacturer_id) AS avg_area
FROM airplanes a
INNER JOIN manufacturers m
    ON a.manufacturer_id = m.manufacturer_id
WHERE 
    a.max_weight > (
        SELECT ROUND(AVG(a2.max_weight), 0)
        FROM airplanes a2
        WHERE a2.manufacturer_id = a.manufacturer_id
    )
AND 
    a.parking_area > (
        SELECT ROUND(AVG(a2.parking_area), 0)
        FROM airplanes a2
        WHERE a2.manufacturer_id = a.manufacturer_id
    );


--7. TRABAJANDO CON UNA COLUMNA DE DATOS
/*
En el ejemplo anterior vimos las subconsultas de filas. 
Una subconsulta de fila sólo puede devolver una fila, aunque esa fila puede incluir una o más columnas. 
Esto contrasta con una subconsulta escalar, que sólo devuelve una fila y una columna. 
Ahora veremos la subconsulta de columna, que devuelve sólo una columna con una o más filas.
*/

SELECT manufacturer_id, manufacturer 
FROM manufacturers
WHERE manufacturer_id IN 
  (SELECT DISTINCT manufacturer_id FROM airplanes
    WHERE engine_type = 'piston');
    
--8. USANDO SUBONSULTAS EN LA CLÁUSULA FORM
/*
Además de filas, columnas y valores escalares, las subconsultas también pueden devolver tablas, que se denominan tablas derivadas. 
Al igual que otras subconsultas, una subconsulta de tabla debe ir entre paréntesis. Además, también se le debe asignar un alias, de forma similar a la especificación de un alias de tabla cuando se construyen subconsultas correlacionadas. 
Por ejemplo, la siguiente sentencia SELECT incluye una subconsulta de tabla denominada total_planes, que se incluye en la cláusula FROM de la sentencia externa:
*/

/*
La consulta interna cuenta el número de aviones producidos por cada fabricante. Agrupa los datos por manufacturer_id 
y calcula el número de aviones de cada fabricante.

La consulta externa calcula la media de los recuentos obtenidos en la consulta interna, redondeando el resultado 
a dos decimales. El resultado se denomina avg_amt.
*/
SELECT ROUND(AVG(amount), 2) avg_amt
FROM 
  (SELECT manufacturer_id, COUNT(*) AS amount 
  FROM airplanes
  GROUP BY manufacturer_id) AS total_planes;    