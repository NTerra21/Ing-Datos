/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Clase 13: Guia de estudio - Subconsultas SQL y Vistas SQL */
/* Material para repasar lo visto en practica (20 oct / 27 oct 2026) */

/*
================================================================================
COMO USAR ESTA GUIA
================================================================================
1. Primero ejecuta el script de practica HR:
   "ID1_clase_13 Actividades en clase - Subconsultas HR y Vistas SQL.sql"
   (crea tablas regions, countries, locations, jobs, departments, employees, dependents)

2. Esta guia NO recrea la base. Solo explica conceptos y deja consultas de ejemplo
   para estudiar / copiar / adaptar.

3. Base: uade_id1_2c2026
*/

USE uade_id1_2c2026;
GO

/*
================================================================================
PARTE A - SUBCONSULTAS SQL
================================================================================
Definicion:
  Una subconsulta es un SELECT dentro de otro SELECT (o INSERT/UPDATE/DELETE).
  Se escribe entre parentesis.

Para que sirve:
  Comparar contra un valor calculado (promedio, maximo, id buscado).
  Filtrar con listas (IN / NOT IN).
  Armar columnas calculadas.
  Usar tablas derivadas en el FROM.

Tipos basicos:
  1) Escalar     -> devuelve 1 fila y 1 columna (un solo valor)
  2) De columna  -> 1 columna, N filas (sirve con IN)
  3) De fila     -> 1 fila, N columnas
  4) De tabla    -> N filas y N columnas (tabla derivada en FROM)
  5) Correlacionada -> la interna usa columnas de la externa (se re-ejecuta por fila)

Operadores utiles:
  =, >, <, >=, <=     con subconsulta escalar
  IN / NOT IN         con lista de valores
  EXISTS / NOT EXISTS existencia de filas
  SOME / ANY / ALL    comparar contra un conjunto
*/


-- ---------------------------------------------------------------------------
-- A1. Subconsulta escalar (otra tabla)
-- Idea: "dame aviones/empleados cuyo X sea igual al id buscado por nombre"
-- ---------------------------------------------------------------------------
-- Patron:
--   WHERE columna = (SELECT ... WHERE condicion_unica)

SELECT employee_id, first_name, last_name, department_id
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM departments
    WHERE department_name = 'IT'
);


-- ---------------------------------------------------------------------------
-- A2. Subconsulta escalar (misma tabla)
-- Idea: comparar cada fila contra un agregado de toda la tabla
-- ---------------------------------------------------------------------------
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


-- ---------------------------------------------------------------------------
-- A3. Subconsulta correlacionada
-- Idea: el promedio (o max/min) NO es global: es "de SU departamento"
-- La interna referencia e.department_id de la externa
-- ---------------------------------------------------------------------------
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    (
        SELECT AVG(e2.salary)
        FROM employees e2
        WHERE e2.department_id = e.department_id
    ) AS avg_depto
FROM employees e
WHERE e.salary > (
    SELECT AVG(e3.salary)
    FROM employees e3
    WHERE e3.department_id = e.department_id
);


-- ---------------------------------------------------------------------------
-- A4. Subconsulta en SELECT (columna calculada)
-- Idea: mostrar el valor agregado al lado de cada fila
-- ---------------------------------------------------------------------------
SELECT
    e.employee_id,
    e.first_name,
    e.salary,
    (SELECT AVG(e2.salary)
     FROM employees e2
     WHERE e2.department_id = e.department_id) AS avg_depto,
    e.salary - (SELECT AVG(e2.salary)
                FROM employees e2
                WHERE e2.department_id = e.department_id) AS diferencia
FROM employees e;


-- ---------------------------------------------------------------------------
-- A5. Subconsulta de columna + IN / NOT IN
-- Idea: filtrar por pertenencia a un conjunto
-- ---------------------------------------------------------------------------
-- Empleados de departamentos que estan en Seattle
SELECT employee_id, first_name, last_name, department_id
FROM employees
WHERE department_id IN (
    SELECT d.department_id
    FROM departments d
    INNER JOIN locations l ON d.location_id = l.location_id
    WHERE l.city = 'Seattle'
);


-- ---------------------------------------------------------------------------
-- A6. SOME / ANY (al menos un valor del conjunto)
-- Idea practica clase: salario < minimo de ALGUN otro departamento
-- ---------------------------------------------------------------------------
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    e.department_id
FROM employees e
WHERE e.salary < SOME (
    SELECT MIN(e2.salary)
    FROM employees e2
    WHERE e2.department_id IS NOT NULL
      AND e2.department_id <> e.department_id
    GROUP BY e2.department_id
);


-- ---------------------------------------------------------------------------
-- A7. Tabla derivada (subconsulta en FROM)
-- Idea: primero agregas, despues consultas el resultado como si fuera tabla
-- ---------------------------------------------------------------------------
SELECT ROUND(AVG(cantidad), 2) AS promedio_empleados_por_depto
FROM (
    SELECT department_id, COUNT(*) AS cantidad
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
) AS por_depto;


-- ---------------------------------------------------------------------------
-- A8. HAVING con agregado (equivalente util a "puestos con avg > 10000")
-- ---------------------------------------------------------------------------
SELECT
    job_id,
    AVG(salary) AS salario_promedio,
    COUNT(*) AS cantidad_empleados
FROM employees
GROUP BY job_id
HAVING AVG(salary) > 10000;


/*
================================================================================
CHEAT SHEET - CONSIGNAS SUBCONSULTAS (practica 20 oct)
================================================================================
1) Empleados con salario > promedio de SU departamento
   -> correlacionada por department_id + mostrar ese promedio

2) Empleados que ganan mas que SU gerente
   -> comparar salary con (SELECT salary FROM employees m WHERE m.employee_id = e.manager_id)
   -> join a departments para nombre de depto

3) job_id con AVG(salary) > 10000
   -> GROUP BY job_id + HAVING + COUNT(*)

4) salary < minimo de algun OTRO departamento
   -> salary < SOME (SELECT MIN(salary) ... GROUP BY department_id)

5) salary > promedio de empleados en la MISMA region
   -> join employees -> departments -> locations -> countries
   -> correlacionar por region_id

6) Antiguedad > media del pais Y salary > promedio del depto
   -> DATEDIFF(DAY, hire_date, GETDATE())
   -> dos condiciones correlacionadas (pais + depto)
*/


/*
================================================================================
PARTE B - VISTAS SQL
================================================================================
Definicion:
  Una vista es un SELECT guardado con nombre. No guarda datos propios
  (salvo vistas indexadas avanzadas). Al consultar la vista, SQL Server
  ejecuta el SELECT de definicion.

Para que sirve:
  Simplificar consultas complejas (joins, calculos).
  Reutilizar la misma proyeccion.
  Restringir columnas/filas visibles (seguridad / claridad).
  Actualizar tablas base en casos simples (vista actualizable).

Sintaxis base:
  CREATE VIEW nombre_vista AS
  SELECT ...
  FROM ...
  WHERE ...;

  -- En SQL Server moderno tambien:
  CREATE OR ALTER VIEW nombre_vista AS ...

Consultar:
  SELECT * FROM nombre_vista;

Borrar:
  DROP VIEW IF EXISTS nombre_vista;

WITH CHECK OPTION:
  Si la vista tiene WHERE, impide INSERT/UPDATE que dejen filas
  fuera del filtro de la vista.
  Ejemplo: vista solo Sales -> no deja insertar department_id de otro depto.
*/


-- ---------------------------------------------------------------------------
-- B1. Vista simple (columnas basicas)
-- ---------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW vw_study_employees_basic AS
SELECT employee_id, first_name, last_name, email, salary
FROM employees;
GO

SELECT * FROM vw_study_employees_basic;


-- ---------------------------------------------------------------------------
-- B2. Vista con filtro
-- ---------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW vw_study_high_salary AS
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > 9000;
GO


-- ---------------------------------------------------------------------------
-- B3. Vista con expresion (concatenacion) y alias con espacios
-- ---------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW vw_study_employee_contact AS
SELECT
    employee_id,
    first_name + ' ' + last_name AS [Nombre y Apellido],
    phone_number
FROM employees;
GO


-- ---------------------------------------------------------------------------
-- B4. Vista con JOIN
-- ---------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW vw_study_employee_department AS
SELECT
    e.employee_id,
    e.first_name + ' ' + e.last_name AS nombre_completo,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;
GO


-- ---------------------------------------------------------------------------
-- B5. Vista con agregacion (GROUP BY)
-- Nota: esta vista NO suele ser actualizable (tiene agregados)
-- ---------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW vw_study_department_salary_stats AS
SELECT
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS cantidad_empleados,
    AVG(e.salary) AS salario_promedio,
    MIN(e.salary) AS salario_minimo,
    MAX(e.salary) AS salario_maximo
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;
GO


-- ---------------------------------------------------------------------------
-- B6. Vista con WITH CHECK OPTION (solo Sales)
-- ---------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW vw_study_sales_emps AS
SELECT
    employee_id, first_name, last_name, email, phone_number,
    hire_date, job_id, salary, manager_id, department_id
FROM employees
WHERE department_id = (
    SELECT department_id FROM departments WHERE department_name = 'Sales'
)
WITH CHECK OPTION;
GO


-- ---------------------------------------------------------------------------
-- B7. Actualizar tabla base MEDIANTE la vista (demostracion)
-- Funciona si la vista es simple (sin GROUP BY / DISTINCT problematico)
-- ---------------------------------------------------------------------------
-- UPDATE vw_study_employees_basic
-- SET salary = 4500
-- WHERE employee_id = 107;


-- ---------------------------------------------------------------------------
-- B8. Vista con CASE (categoria calculada)
-- ---------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW vw_study_salary_category AS
SELECT
    employee_id,
    first_name + ' ' + last_name AS nombre_completo,
    CASE
        WHEN salary > 10000 THEN 'ALTO'
        WHEN salary >= 5000 AND salary <= 10000 THEN 'MEDIO'
        ELSE 'BAJO'
    END AS categoria_salarial
FROM employees;
GO

SELECT * FROM vw_study_salary_category;


/*
================================================================================
CHEAT SHEET - CONSIGNAS VISTAS (practica 27 oct)
================================================================================
1) vw_employees_basic
   -> employee_id, first_name, last_name, email, salary

2) vw_high_salary_employees
   -> WHERE salary > 9000

3) vw_employee_contact
   -> first_name + ' ' + last_name AS [Nombre y Apellido], phone_number

4) vw_employee_department
   -> join departments, mostrar department_name

5) vw_employee_department_location
   -> join departments + locations, mostrar city

6) vw_department_salary_stats
   -> COUNT, AVG, MIN, MAX por departamento

7) vw_sales_department_emps
   -> filtro Sales + WITH CHECK OPTION

8) UPDATE sobre vw_employees_basic
   -> cambia employees de verdad

9) vw_employee_salary_category
   -> CASE: ALTO (>10000) / MEDIO (5000..10000) / BAJO (<5000)
*/


/*
================================================================================
MAPA RAPIDO DE TABLAS HR (para armar joins de memoria)
================================================================================
regions      (region_id)
   ^
countries    (country_id, region_id)
   ^
locations    (location_id, country_id, city)
   ^
departments  (department_id, location_id, department_name)
   ^
employees    (employee_id, department_id, job_id, manager_id, salary, hire_date)
   ^
dependents   (dependent_id, employee_id)

jobs         (job_id) <-- employees.job_id
*/


/*
================================================================================
ERRORES FRECUENTES (para no fallar en parcial)
================================================================================
1) Subconsulta escalar que devuelve MAS de 1 fila con operador =
   -> Error. Usar IN, o asegurar unicidad (TOP 1 / agregacion).

2) Olvidar correlacion
   -> Comparas contra promedio GLOBAL cuando pedian "de su departamento".

3) IN con NULL
   -> NOT IN + NULLs en la lista puede devolver vacio. Preferir NOT EXISTS.

4) Vista con JOIN/GROUP BY
   -> Puede no aceptar UPDATE/INSERT. Item 8 pide vista SIMPLE.

5) WITH CHECK OPTION
   -> Sin eso, podes insertar filas que despues "desaparecen" de la vista.

6) Alias con espacios
   -> Usar corchetes: AS [Nombre y Apellido]

7) GO
   -> CREATE VIEW debe ir en su propio batch (separar con GO en SSMS).
*/


/*
================================================================================
CHECKLIST DE ESTUDIO (10 minutos)
================================================================================
[ ] Explicar diferencia escalar vs correlacionada vs IN vs tabla derivada
[ ] Escribir de memoria: empleados > promedio de su depto
[ ] Escribir de memoria: empleados > salario del gerente
[ ] Escribir CREATE VIEW basica + otra con JOIN
[ ] Explicar para que sirve WITH CHECK OPTION
[ ] Armar CASE de categorias salariales
[ ] Recorrer el mapa HR: employees -> departments -> locations -> countries -> regions
*/

-- Limpieza opcional de vistas de estudio (descomentar si queres borrarlas)
/*
DROP VIEW IF EXISTS vw_study_employees_basic;
DROP VIEW IF EXISTS vw_study_high_salary;
DROP VIEW IF EXISTS vw_study_employee_contact;
DROP VIEW IF EXISTS vw_study_employee_department;
DROP VIEW IF EXISTS vw_study_department_salary_stats;
DROP VIEW IF EXISTS vw_study_sales_emps;
DROP VIEW IF EXISTS vw_study_salary_category;
*/
