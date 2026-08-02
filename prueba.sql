-- Active: 1783129220798@@127.0.0.1@5432@prueba_sql
CREATE DATABASE prueba_sql;

--1. Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves primarias, foráneas y tipos de datos.
CREATE TABLE peliculas (
    id INT PRIMARY KEY,
    nombre VARCHAR(255),
    anno INT
);

CREATE TABLE tags (
    id INT PRIMARY KEY,
    tag VARCHAR(32)
);

CREATE TABLE pelicula_tag (
    pelicula_id INT,
    tag_id INT,
    PRIMARY KEY (pelicula_id, tag_id),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

--2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la segunda película debe tener 2 tags asociados.
INSERT INTO peliculas VALUES
(1,'Titanic',1997),
(2,'Matrix',1999),
(3,'Avatar',2009),
(4,'Gladiador',2000),
(5,'Shrek',2001);

INSERT INTO tags VALUES
(1,'Drama'),
(2,'Romance'),
(3,'Acción'),
(4,'Ciencia Ficción'),
(5,'Animación');

INSERT INTO pelicula_tag VALUES
(1,1),
(1,2),
(1,3),
(2,3),
(2,4);

--3. Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves primarias, foráneas y tipos de datos.
SELECT
    p.nombre,
    COUNT(pt.tag_id) AS cantidad_tags
FROM peliculas p
LEFT JOIN pelicula_tag pt
ON p.id = pt.pelicula_id
GROUP BY p.id, p.nombre
ORDER BY p.id;

--4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y foráneas y tipos de datos.
CREATE TABLE usuarios(
    id INT PRIMARY KEY,
    nombre VARCHAR(255),
    edad INT
);

CREATE TABLE preguntas(
    id INT PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR(255)
);

CREATE TABLE respuestas(
    id INT PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INT,
    pregunta_id INT,
    FOREIGN KEY(usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY(pregunta_id) REFERENCES preguntas(id)
);

--5. Agrega 5 usuarios y 5 preguntas.
INSERT INTO usuarios VALUES
(1,'Ana',22),
(2,'Pedro',25),
(3,'María',30),
(4,'Juan',28),
(5,'Camila',19);

INSERT INTO preguntas VALUES
(1,'Capital de Chile','Santiago'),
(2,'2 + 2','4'),
(3,'Color del cielo','Azul'),
(4,'Planeta rojo','Marte'),
(5,'Lenguaje de esta prueba','SQL');

--a. La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes
INSERT INTO respuestas VALUES
(1,'Santiago',1,1),
(2,'Santiago',2,1),
--b. La segunda pregunta debe estar contestada correctamente solo por un usuario.
(3,'4',3,2),
--c. Las otras dos preguntas deben tener respuestas incorrectas.
(4,'Rojo',4,3),
(5,'Jupiter',5,4);

--6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).
SELECT
    u.nombre,
    COUNT(r.id) AS respuestas_correctas
FROM usuarios u
LEFT JOIN respuestas r
    ON u.id = r.usuario_id
LEFT JOIN preguntas p
    ON r.pregunta_id = p.id
   AND r.respuesta = p.respuesta_correcta
WHERE p.id IS NOT NULL
GROUP BY u.id, u.nombre
ORDER BY u.id;

-- 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente.
SELECT
    p.pregunta,
    COUNT(r.id) AS usuarios_correctos
FROM preguntas p
LEFT JOIN respuestas r
    ON p.id = r.pregunta_id
   AND r.respuesta = p.respuesta_correcta
GROUP BY p.id, p.pregunta
ORDER BY p.id;

-- 8. Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la implementación borrando el primer usuario.
-- Primero modificar la llave foránea
ALTER TABLE respuestas
DROP CONSTRAINT respuestas_usuario_id_fkey;
-- Agregar la llave foránea con borrado en cascada
ALTER TABLE respuestas
ADD CONSTRAINT respuestas_usuario_id_fkey
FOREIGN KEY(usuario_id)
REFERENCES usuarios(id)
ON DELETE CASCADE;
--Probar
DELETE FROM usuarios
WHERE id = 1;
--Verificar que las respuestas del usuario 1 se borraron
SELECT * FROM respuestas;

--9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
ALTER TABLE usuarios
ADD CONSTRAINT chk_edad
CHECK (edad >= 18);
--Probar la restricción
INSERT INTO usuarios VALUES
(6,'Pepe',15);

--10. Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único.
ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255);

ALTER TABLE usuarios
ADD CONSTRAINT email_unico
UNIQUE(email);

--Probar la restricción
UPDATE usuarios
SET email='ana@gmail.com'
WHERE id=2;

UPDATE usuarios
SET email='ana@gmail.com'
WHERE id=3;