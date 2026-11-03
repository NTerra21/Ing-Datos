/* Universidad Argentina de la Empresa (UADE) */
/* Ingenieria de Datos 1 */
/* 2do Cuatrimestre 2026 */
/* Triggers SQL */
use uade_id1_2c2026;

drop table Employees_2;
-- Creación de una tabla para mostrar el funcoinamiento de los triggers
CREATE TABLE Employees_2 (
    EmployeeID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100),
    Salary DECIMAL(10,2),
    Department NVARCHAR(50)
);
GO

drop table EmployeeAudit;
-- Creación de una tabla de auditoría para llevar el log de las acciones de trigger
CREATE TABLE EmployeeAudit (
    AuditID INT IDENTITY PRIMARY KEY,
    EmployeeID INT,
    ActionType NVARCHAR(50),
    ActionDate DATETIME DEFAULT GETDATE()
);
GO

-- Ejemplo 1: Trigger AFTER INSERT (a nivel de fila): se graba un registro en la tabla de auditoría 
-- luego de haber insertado un registro en la tabla de empleados
CREATE TRIGGER trg_AfterInsertEmployee
ON Employees_2
AFTER INSERT
AS
BEGIN
    INSERT INTO EmployeeAudit (EmployeeID, ActionType)
    SELECT EmployeeID, 'INSERT' FROM inserted;
END;
GO

/* listar los triggers*/
select * from sys.triggers;

/* Prueba del trigger */
INSERT INTO Employees_2 (Name, Salary, Department)
VALUES ('John Doe', 50000, 'IT');

select * from Employees_2; -- verificamos que se insertó el registro en la tabla de Empleados
select * from EmployeeAudit; -- verificamos que adicionalmente se insertó un registro en la tabla de Auditoría

update Employees_2 set salary = -15000 where EmployeeID = 1;

-- Ejemplo 2: AFTER UPDATE (a nivel de fila): se graba un registro en la tabla de Auditoría con el registro modificado
CREATE TRIGGER trg_AfterUpdateEmployee
ON Employees_2
AFTER UPDATE
AS
BEGIN
    INSERT INTO EmployeeAudit (EmployeeID, ActionType)
    SELECT EmployeeID, 'UPDATE' FROM inserted;
END;
GO

select * from Employees_2; -- verificamos que se insertó el registro en la tabla de Empleados
update Employees_2 set salary = 55000 where EmployeeID = 1;


select * from sys.triggers;
delete from Employees_2 where EmployeeID = 1;
-- Ejemplo 3: Trigger AFTER DELETE (a nivel de fila)
CREATE TRIGGER trg_AfterDeleteEmployee
ON Employees_2
AFTER DELETE
AS
BEGIN
    INSERT INTO EmployeeAudit (EmployeeID, ActionType)
    SELECT EmployeeID, 'DELETE' FROM deleted;
END;
GO


-- Ejemplo 4: Trigger INSTEAD OF DELETE
CREATE TRIGGER trg_InsteadOfDeleteEmployee
ON Employees_2
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'Delete operation is not allowed on Employees table!';
END;
GO

delete from Employees_2 where EmployeeID = 1;
delete from Employees_2 where EmployeeID = 2;
select * from EmployeeAudit;

-- Ejemplo 5: Trigger BEFORE UPDATE (simulado con INSTEAD OF UPDATE, a nivel de sentencia)
CREATE TRIGGER trg_BeforeUpdateEmployee
ON Employees_2
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Salary < 0)
    BEGIN
        PRINT 'Salary cannot be negative';
        RETURN;
    END
    UPDATE Employees_2
    SET Salary = inserted.Salary, Department = inserted.Department
    FROM Employees_2 e
    INNER JOIN inserted ON e.EmployeeID = inserted.EmployeeID;
END;
GO

ALTER TRIGGER trg_BeforeUpdateEmployee
ON Employees_2
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Salary < 0)
    BEGIN
	    RAISERROR ('no se puede actualizar salario en negativo', 16, 1)
        RETURN;
    END
    UPDATE Employees_2
    SET Salary = inserted.Salary, Department = inserted.Department
    FROM Employees_2 e
    INNER JOIN inserted ON e.EmployeeID = inserted.EmployeeID;
END;
GO
 

select * from Employees_2;
UPDATE Employees_2 SET Salary = -10000 WHERE Name = 'John Doe'; -- se modifica el salario del empleado de 50,000 a 55,000

/* Prueba del trigger */
UPDATE Employees_2 SET Salary = 60000 WHERE Name = 'John Doe'; -- se modifica el salario del empleado de 50,000 a 55,000
select * from Employees_2; -- verificamos que el salario fue actualizado
select * from EmployeeAudit; -- verificamos que adicionalmente se insertó un registro en la tabla de Auditoría



-- Ejemplo 6: Trigger AFTER INSERT (a nivel de sentencia)
CREATE TRIGGER trg_AfterInsertStatement
ON Employees_2
AFTER INSERT
AS
BEGIN
    PRINT 'A new employee record has been inserted.';
END;
GO

-- Ejemplo 7: Trigger AFTER UPDATE (a nivel de sentencia)
CREATE TRIGGER trg_AfterUpdateStatement
ON Employees_2
AFTER UPDATE
AS
BEGIN
    PRINT 'An update operation has been performed on the Employees table.';
END;
GO

-- Ejemplo 8: Trigger AFTER DELETE (a nivel de sentencia)
CREATE TRIGGER trg_AfterDeleteStatement
ON Employees_2
AFTER DELETE
AS
BEGIN
    PRINT 'A delete operation has been performed on the Employees table.';
END;
GO

/* Prueba del trigger */
DELETE FROM Employees_2 WHERE Name = 'John Doe'; -- verificamos que se dispara el trigger impidiendo la eliminación del registro
select * from Employees_2; -- verificamos que el empleado no fue eliminado

-- Verificamos el log de auditoría 
SELECT * FROM EmployeeAudit;
GO


-- Ejemplo 9: Trigger INSTEAD OF (simulando un trigger de validación BEFORE INSERT)
CREATE TRIGGER trg_ValidateBeforeInsertEmployee
ON Employees_2
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Salary < 30000)
    BEGIN
        PRINT 'Salary must be at least 30,000';
        RETURN;
    END
    INSERT INTO Employees_2 (Name, Salary, Department)
    SELECT Name, Salary, Department FROM inserted;
END;
GO

/* Prueba del trigger */
INSERT INTO Employees_2 (Name, Salary, Department)
VALUES ('Jane Doe', 25000, 'HR'); -- Esta inserción debería disparar una validación negativa siendo que el salario es menor que 30,000

select * from Employees_2; -- verificamos que no se insertó el registro

drop trigger trg_ValidateBeforeInsertEmployee;


--esta sentencia lista todos los triggers en la base de datos en uso
SELECT  
    name,
    is_instead_of_trigger
FROM 
    sys.triggers  
WHERE 
    type = 'TR'


-- Create Employee table
CREATE TABLE Employee
(
Id int Primary Key,
Name varchar(30),
Salary int,
Gender varchar(10),
DepartmentId int
)
GO
-- Insert data into Employee table
INSERT INTO Employee VALUES (1,'Pranaya', 5000, 'Male', 3)
INSERT INTO Employee VALUES (2,'Priyanka', 5400, 'Female', 2)
INSERT INTO Employee VALUES (3,'Anurag', 6500, 'male', 1)
INSERT INTO Employee VALUES (4,'sambit', 4700, 'Male', 2)
INSERT INTO Employee VALUES (5,'Hina', 6600, 'Female', 3)

--Ejemplo 1: Trigger For/After (INSERT) 
--Bloquear el alta de nuevos empleados

CREATE TRIGGER trInsertEmployee
ON Employee
FOR INSERT
AS
BEGIN
PRINT 'YOU CANNOT PERFORM INSERT OPERATION'
ROLLBACK TRANSACTION
END

INSERT INTO Employee VALUES (6, 'Saroj', 7600, 'Male', 1)

--Ejemplo 2: Trigger For/After (UPDATE) 
--Bloquear la modificación de empleados

CREATE TRIGGER trUpdateEmployee
ON Employee
FOR UPDATE
AS
BEGIn
PRINT 'YOU CANNOT PERFORM UPDATE OPERATION'
ROLLBACK TRANSACTION
END

UPDATE Employee SET Salary = 90000 WHERE Id = 1

--Ejemplo 3: Trigger For/After (DELETE) 
--Bloquear la eliminación de empleados


CREATE TRIGGER trDeleteEmployee
ON Employee
FOR DELETE
AS
BEGIN
PRINT 'YOU CANNOT PERFORM DELETE OPERATION'
ROLLBACK TRANSACTION
END

DELETE FROM Employee WHERE Id = 1

--Ejemplo 4: Trigger For/After (INSERT, UPDATE, DELETE) 
--Bloquear el alta, actualización y eliminación de empleados

CREATE TRIGGER trAllDMLOperationsOnEmployee
ON Employee
FOR INSERT, UPDATE, DELETE
AS
BEGIN
PRINT 'YOU CANNOT PERFORM DML OPERATION'
ROLLBACK TRANSACTION
END

DELETE FROM Employee WHERE Id = 2


--Ejemplo 5 :
--Trigger para bloquear el alta, modificación y eliminación de empleados los días miércoles.
--1. DOM DIA = 1
--2. LU DIA = 2
--3. MA DIA = 3
--4. MIE DIA = 4
--5. JUE DIA = 5
--6. VIE DIA = 6
--7. SA DIA = 7

CREATE TRIGGER trOperationsOnEmployee
ON Employee
FOR INSERT, UPDATE, DELETE
AS
BEGIN
IF DATEPART(DW,GETDATE())= 4
BEGIN
PRINT 'DML OPERATIONS ARE RESTRICTED ON WEDNESDAY'
ROLLBACK TRANSACTION
END
END

DELETE FROM Employee WHERE Id = 2


--EJEMPLO 6:
--Bloquear el alta, modificación y eliminación de empleados antes de las 13 hs. 
CREATE TRIGGER trAllDMLOperationsOnEmployee
ON Employee
FOR INSERT, UPDATE, DELETE
AS
BEGIN
IF DATEPART(HH,GETDATE()) < 13
BEGIN
PRINT 'INVALID TIME'
ROLLBACK TRANSACTION
END
END
DELETE FROM Employee WHERE Id = 2



--Se crea la tabla de estudiantes
CREATE table highschooler(
ID int, 
firstname varchar(25), 
lastname varchar(25),
grade int
)

--Se crea la tabla de relaciones de amistad
CREATE table friend(
ID1 int NOT NULL, 
ID2 int NOT NULL
PRIMARY KEY CLUSTERED(
ID1,
ID2
)
)


--Se crea la tabla de likes
CREATE table likes(
ID1 int NOT NULL, 
ID2 int NOT NULL
PRIMARY KEY CLUSTERED(
ID1,
ID2
)
)

--Se insertan valores en la tabla de estudiantes
INSERT into highschooler (ID, firstname, lastname, grade) values 
(0001, 'Juan','Perez', 1),
(0002, 'Alejo','Gómez', 2),
(0003, 'Laura','Gutierrez', 1),
(0004, 'Pamela','Gotz', 3),
(0005, 'Leandro','Freyre', 5)

--Se insertan valores en la tabla de amistades
INSERT into friend (ID1, ID2) values (0001,0002), (0001,0004), (0001,0005), (0002,0001), (0004,0001), (0005,0001)

--Se insertan valores en la tabla de likes
INSERT into likes (ID1, ID2) values (0001,0005), (0001,0003)

select * from highschooler
select * from friend
select * from likes



--1 Escribir uno o más triggers para mantener la simetría en la tabla de relaciones. 
--Específicamente, si (A,B) se borra de la tabla Friend, entonces (B,A) se debería borrar también.
--Si (A,B) se inserta en la tabla Friend entonces (B,A) se debería insertar también.
--No preocuparse en este momento por actualizaciones a la tabla Friend


--TRIGGER DE ELIMINACION
create trigger F1_Del ON friend FOR DELETE 
AS
	DECLARE @oldID1 int, @oldID2 int
	select @oldID1=ID1,@oldID2=ID2 from DELETED
	delete from friend where ID1 = @oldID2 and ID2 = @oldID1
GO

select * from friend

delete from friend where ID1 = 1 and ID2 = 4


--TRIGGER DE INSERCION
create trigger F1_Ins ON friend FOR INSERT
AS
	DECLARE @newID1 int, @newID2 int
	select @newID1=ID1,@newID2=ID2 from INSERTED
	INSERT into friend (ID1, ID2) values (@newID2, @newID1)
GO

insert into friend (ID1, ID2) values (0003, 0001)

insert into friend (ID1, ID2) values (6, 2)

--->
--->
--A partir de la tabla empleados 'Employee' (Id int, Name(45), Salary(9,2), Gender(12), Departmentid int) y la tabla de auditoría 'Employee_Audit_Test' generar un 
--registro en la tabla de auditoría cada vez que se da de alta un empleado

--Se crea la tabla de empleados
CREATE TABLE Employee_1  
(  
  Id INT PRIMARY KEY,  
  Name VARCHAR(45),  
  Salary INT,  
  Gender VARCHAR(12),  
  DepartmentId INT  
)

--Se dan de alta registros en la tabla de empleados
INSERT INTO Employee_1 VALUES (1,'Steffan', 82000, 'Male', 3),  
(2,'Amelie', 52000, 'Female', 2),  
(3,'Antonio', 25000, 'male', 1),  
(4,'Marco', 47000, 'Male', 2),  
(5,'Eliana', 46000, 'Female', 3) 

--Se consultan los registros de la tabla empleados
SELECT * FROM Employee_1;

--Se crea la tabla de auditoría de empleados
CREATE TABLE Employee_Audit_Test  
(    
Id int IDENTITY,   
Audit_Action text   
)  

--creación del trigger para loguear cada vez que se da de alta un nuevo empleado
CREATE TRIGGER trInsertEmployee_1 ON Employee_1  
FOR INSERT  
AS  
BEGIN  
  Declare @Id int  
  SELECT @Id = Id from inserted  
  INSERT INTO Employee_Audit_Test  
  VALUES ('New employee with Id = ' + CAST(@Id AS VARCHAR(10)) + ' is added at ' + CAST(Getdate() AS VARCHAR(22)))  
END

--testeamos el trigger
INSERT INTO Employee_1 VALUES (6,'Peter', 62000, 'Male', 3) 

select * from employee_audit_test





select * from highschooler
delete from highschooler where grade = 1

CREATE TRIGGER Empl_Delete ON highschooler
FOR DELETE
AS
IF (SELECT COUNT(*) FROM DELETED) > 1
BEGIN
RAISERROR(
'No se puede eliminar más de un registro a la vez.'
, 16, 1)
ROLLBACK TRANSACTION
END



create table arenas(
ID varchar(4) PRIMARY KEY,
name varchar(30) NOT NULL, 
city varchar(30) NOT NULL,
capacity numeric(4))


--crear un trigger para no permitir el alta de escenarios de eventos con capacidad menor a 5,000 personas
create trigger minseating ON arenas for insert
AS
DECLARE @capacity as int

select @capacity = capacity from inserted
if @capacity < 5000

begin
	rollback
	print 'El escenario para eventos es muy pequeño'
end

insert into arenas values ('0001', 'escenario x', 'Buenos Aires', 300) 