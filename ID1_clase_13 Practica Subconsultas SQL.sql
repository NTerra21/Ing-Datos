/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Clase 13: Práctica Subconsultas SQL */
use uade_id1_2c2026;

/*Consignas
Tomando la base de datos creada en clase (empleados, puestos de trabajo, etc.), 
generar las siguientes consultas SQL mediante subconsultas:
*/

--1. Obtener el id, nombre, apellido, salario, salario promedio del departamento 
--de todos los empleados con salario mayor al promedio de su departamento;
select
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    (select avg(e2.salary)
    from employees e2
    where e2.department_id = e.department_id) as salario_promedio_depto
from employees e
where e.salary > (
    select avg(e3.salary)
    from employees e3
    where e3.department_id = e.department_id
);

--2. Obtener el id, nombre de departamento, id del gerente, id del empleado, nombre 
--del empleado, apellido del empleado y salario de aquellos departamentos con empleados 
--que ganan más que el gerente;
select
    d.department_id,
    d.department_name,
    e.manager_id,
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary
from employees e
inner join departments d on e.department_id = d.department_id
where e.salary > (
    select m.salary
    from employees m
    where m.employee_id = e.manager_id
);

--3. Listar los id de puesto de trabajo que tienen un salario promedio mayor a $10,000, 
--mostrando además el salario promedio y la cantidad de empleados en ese puesto de trabajo;
select t.job_id, t.salario_promedio, t.cantidad_empleados
from (
    select job_id, avg(salary) as salario_promedio, count(*) as cantidad_empleados
    from employees
    group by job_id
) as t
where t.salario_promedio > 10000;

--4. Listar los empleados cuyo salario es menor que el salario mínimo de algún otro departamento 
--(distinto al suyo). Mostrar id de empleado, nombre, apellido, salario y id de departamento;
select e.employee_id, e.first_name, e.last_name, e.salary, e.department_id
from employees e
where e.salary < any (
    select min(e2.salary)
    from employees e2
    where e2.department_id <> e.department_id
    group by e2.department_id
);

--5. Listar los empleados cuyo salario es mayor que el promedio de salarios de todos los departamentos 
--que pertenecen a la misma región que su ubicación. Se pide mostrar el id, nombre, apellido, salario, 
--id de departamento, id de región;
select e.employee_id, e.first_name, e.last_name, e.salary, e.department_id, c.region_id
from employees e
inner join departments d on e.department_id = d.department_id
inner join locations l on d.location_id = l.location_id
inner join countries c on l.country_id = c.country_id
where e.salary > (
    select avg(e2.salary)
    from employees e2
    inner join departments d2 on e2.department_id = d2.department_id
    inner join locations l2 on d2.location_id = l2.location_id
    inner join countries c2 on l2.country_id = c2.country_id
    where c2.region_id = c.region_id
);

--6. Listar todos los empleados con antigüedad superior a la media de su país y salario por encima del 
--promedio de su departamento. Mostrar el id, nombre, apellido, fecha de ingreso, salario, id de departamento, 
--id de país.
select e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary, e.department_id, l.country_id
from employees e
inner join departments d on e.department_id = d.department_id
inner join locations l on d.location_id = l.location_id
where datediff(day, e.hire_date, getdate()) > (
        select avg(datediff(day, e2.hire_date, getdate()) * 1.0)
        from employees e2
        inner join departments d2 on e2.department_id = d2.department_id
        inner join locations l2 on d2.location_id = l2.location_id
        where l2.country_id = l.country_id
    )
    and e.salary > (
        select avg(e3.salary)
        from employees e3
        where e3.department_id = e.department_id
    );
