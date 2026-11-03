use uade_id1_2c2026

-- Creación e inserción para la tabla Fabricante
CREATE TABLE fabricante (
    codigo INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);
-- Creación e inserción para la tabla Producto

CREATE TABLE producto (
    codigo INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    codigo_fabricante INT NOT NULL,
    FOREIGN KEY (codigo_fabricante) REFERENCES fabricante(codigo)
);


SET IDENTITY_INSERT fabricante ON;

INSERT INTO fabricante (codigo, nombre) VALUES (1, 'Asus');
INSERT INTO fabricante (codigo, nombre) VALUES (2, 'Lenovo');
INSERT INTO fabricante (codigo, nombre) VALUES (3, 'Hewlett-Packard');
INSERT INTO fabricante (codigo, nombre) VALUES (4, 'Samsung');
INSERT INTO fabricante (codigo, nombre) VALUES (5, 'Seagate');
INSERT INTO fabricante (codigo, nombre) VALUES (6, 'Crucial');
INSERT INTO fabricante (codigo, nombre) VALUES (7, 'Gigabyte');
INSERT INTO fabricante (codigo, nombre) VALUES (8, 'Huawei');
INSERT INTO fabricante (codigo, nombre) VALUES (9, 'Xiaomi');

SET IDENTITY_INSERT fabricante OFF;



SET IDENTITY_INSERT producto ON;

INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (1, 'Disco Duro Sata3 1TB', 86.99, 5);
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (2, 'Memoria RAM DDR4 8GB', 120.00, 6);
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (4, 'GeForce GTX 1050TI', 185.00, 7);
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (5, 'GeForce GTX 1080 Xtreme', 755.00, 6);
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (6, 'Monitor 24" LED Full HD', 202.00, 1);
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (7, 'Monitor 27" LED Full HD', 245.99, 1);
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (8, 'Notebook Yoga 520', 559.00, 2);
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (9, 'Notebook Ideapad 320', 444.00, 2);
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES (11, 'Impresora HP Laserjetpro m26nw', 100.00, 3);

SET IDENTITY_INSERT producto OFF;
