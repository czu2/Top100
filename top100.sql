-- Crear base de datos llamada películas
CREATE DATABASE peliculas;

-- Conectar BD
\c peliculas;

-- Cargar ambos archivos a su tabla correspondiente

-- Crea Tabla Películas
CREATE TABLE peliculas(
    id INT NOT NULL PRIMARY KEY,
    pelicula VARCHAR(100) NOT NULL,
    ano_estreno INT NOT NULL,
    director VARCHAR(100) NOT NULL,
);

-- Crea Tabla Reparto
CREATE TABLE reparto(
    id_pelicula INT NOT NULL REFERENCES peliculas(id),
    nombre_actor VARCHAR(100),
);

-- Copia contenido a la tabla peliculas
\copy peliculas FROM 'apoyo_top100/peliculas.csv' csv header;

-- Copia contenido a la tabla reparto
\copy reparto FROM 'apoyo_top100/reparto.csv' csv;

-- Consultas

--Listar todos los actores que aparecen en la película "Titanic", indicando el título de la película, año de estreno, director y todo el reparto. 
SELECT p.pelicula, p.ano_estreno, p.director, r.nombre_actor
FROM reparto r INNER JOIN peliculas p
ON r.id_pelicula = p.id
WHERE p.pelicula = 'Titanic';

-- Listar los titulos de las películas donde actúe Harrison Ford.(0.5 puntos)
SELECT pelicula
FROM peliculas p INNER JOIN reparto r
ON p.id = r.id_pelicula
WHERE nombre_actor = 'Harrison Ford';

-- Listar los 10 directores mas populares, indicando su nombre y cuántas películas aparecen en el top 100.
SELECT director, COUNT(director) AS total_peliculas
FROM peliculas
GROUP BY director
ORDER BY total_peliculas DESC
LIMIT 10;

-- Indicar cuantos actores distintos hay
SELECT COUNT(DISTINCT(nombre_actor)) total_actores
FROM reparto;

-- Indicar las películas estrenadas entre los años 1990 y 1999 (ambos incluidos) ordenadas por título de manera ascendente
SELECT pelicula, ano_estreno
FROM peliculas
WHERE ano_estreno BETWEEN 1990 and 1999
ORDER BY pelicula ASC;

--  Listar el reparto de las películas lanzadas el año 2001
SELECT r.nombre_actor, p.pelicula, p.ano_estreno
FROM peliculas p INNER JOIN reparto r
ON p.id = r.id_pelicula
WHERE ano_estreno = 2001;

-- Listar los actores de la película más nueva
SELECT r.nombre_actor, p.pelicula, p.ano_estreno
FROM peliculas p INNER JOIN reparto r
ON p.id = r.id_pelicula
WHERE p.ano_estreno IN (
    SELECT MAX(ano_estreno)
    FROM peliculas
);
