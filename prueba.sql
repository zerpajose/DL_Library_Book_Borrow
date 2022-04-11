CREATE DATABASE biblioteca
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Spain.1252'
    LC_CTYPE = 'Spanish_Spain.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

CREATE TABLE socio (
    id serial NOT NULL,
    rut varchar(20),
    nombre_socio varchar(255),
    apellido_socio varchar(255),
    direccion varchar(255),
    telefono varchar(255),
    PRIMARY KEY (id)
);

CREATE TABLE prestamo (
    id serial NOT NULL,
    f_inicio date,
    f_posible_dev date,
    f_real_dev date,
    id_socio int,
    PRIMARY KEY (id),
    FOREIGN KEY (id_socio) REFERENCES socio(id)
);

CREATE TABLE libro (
    id serial NOT NULL,
    isbn varchar(15),
    titulo varchar(100),
    pag int,
    PRIMARY KEY (id)
);

CREATE TABLE prestamo_libro (
    id serial NOT NULL,
    id_libro int,
    id_prestamo int,
    PRIMARY KEY (id),
    FOREIGN KEY (id_libro) REFERENCES libro(id),
    FOREIGN KEY (id_prestamo) REFERENCES prestamo(id)
);

CREATE TABLE autor (
    cod_autor int NOT NULL,
    nombre_autor varchar(255),
    apellido_autor varchar(255),
    f_nacimiento int,
    f_muerte int,
    tipo_autor varchar(100),
    id_libro int,
    PRIMARY KEY (cod_autor),
    FOREIGN KEY (id_libro) REFERENCES libro(id)
);

INSERT INTO socio (rut, nombre_socio, apellido_socio, direccion, telefono)
VALUES
('1111111-1','JUAN','SOTO','AVENIDA 1, SANTIAGO','911111111'),
('2222222-2','ANA','PÉREZ','PASAJE 2, SANTIAGO','922222222'),
('3333333-3','SANDRA','AGUILAR','AVENIDA 2, SANTIAGO','933333333'),
('4444444-4','ESTEBAN','JEREZ','AVENIDA 3, SANTIAGO','944444444'),
('5555555-5','SILVANA','MUÑOZ','PASAJE 3, SANTIAGO','955555555');

INSERT INTO prestamo (f_inicio, f_posible_dev, f_real_dev, id_socio)
VALUES
('2020-01-20','2020-01-27','2020-01-27',1),
('2020-01-20','2020-01-30','2020-01-30',5),
('2020-01-22','2020-01-30','2020-01-30',3),
('2020-01-23','2020-01-30','2020-01-30',4),
('2020-01-27','2020-02-04','2020-02-04',2),
('2020-01-31','2020-02-12','2020-02-12',1),
('2020-01-31','2020-02-12','2020-02-12',3);

INSERT INTO libro (isbn, titulo, pag)
VALUES
('111-1111111-111','CUENTOS DE TERROR',344),
('222-2222222-222','POESÍAS CONTEMPO RANEAS',167),
('333-3333333-333','HISTORIA DE ASIA',511),
('444-4444444-444','MANUAL DE MECÁNICA',298);

INSERT INTO prestamo_libro (id_libro, id_prestamo)
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(1,5),
(4,6),
(2,7);

INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, f_nacimiento, f_muerte, tipo_autor, id_libro)
VALUES
(3,'JOSE','SALGADO',1968,2020,'PRINCIPAL',1),
(4,'ANA','SALGADO',1972,NULL,'COAUTOR',1),
(1,'ANDRÉS','ULLOA',1982,NULL,'PRINCIPAL',2),
(2,'SERGIO','MARDONES',1950,2012,'PRINCIPAL',3),
(5,'MARTIN','PORTA',1976,NULL,'PRINCIPAL',4);

-- *********************************** *********************************** --
-- a. Mostrar todos los libros que posean menos de 300 páginas
-- *********************************** *********************************** --

SELECT * FROM libro WHERE pag < 300;

-- *********************************** *********************************** --
-- b. Mostrar todos los autores que hayan nacido después del 01-01-1970
-- *********************************** *********************************** --

SELECT * FROM autor
WHERE f_nacimiento > date_part('year',TIMESTAMP '1970-01-01');

-- *********************************** *********************************** --
-- c. ¿Cuál es el libro más solicitado?
-- *********************************** *********************************** --

SELECT libro.isbn, libro.titulo FROM libro
WHERE id = 
(SELECT id_libro
FROM prestamo_libro
GROUP BY id_libro
ORDER BY COUNT(id_libro) DESC
LIMIT 1)

-- *********************************** *********************************** --
-- d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días
-- *********************************** *********************************** --

SELECT((f_posible_dev - f_real_dev) + 7) * 100 AS multa
FROM prestamo
LIMIT 1





