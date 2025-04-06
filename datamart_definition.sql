CREATE TABLE Tbl_alquiler (
    rental_id INTEGER PRIMARY KEY,
    customer_id SMALLINT REFERENCES TblDim_Cliente(customer_id),
    film_id SMALLINT REFERENCES TblDim_Pelicula(film_id),
    payment_id SMALLINT REFERENCES TblDim_Pagos(payment_id),
    rental_date DATE,
    return_date DATE,
    payment_amount FLOAT,
    rental_duration SMALLINT
);

CREATE TABLE TblDim_Cliente (
    customer_id SMALLINT PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    country VARCHAR(50)
);

CREATE TABLE TblDim_Pelicula (
    film_id SMALLINT PRIMARY KEY,
    title VARCHAR(255),
    release_year INTEGER
);

CREATE TABLE TblDim_Pagos (
    payment_id SMALLINT PRIMARY KEY,
    amount FLOAT,
    payment_date DATETIME,
    last_update TIMESTAMP
);

CREATE TABLE TblDim_Actores (
    actor_id SMALLINT,
    film_id SMALLINT REFERENCES TblDim_Pelicula,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    
    PRIMARY KEY (actor_id, film_id)
);

-- Queries

-- a. Top 10 de las películas que más se rentan
SELECT 
    f.title AS film_title,
    COUNT(r.rental_id) AS rental_count
FROM 
    Tbl_alquiler r
JOIN 
    TblDim_Pelicula f ON r.film_id = f.film_id
GROUP BY 
    f.title
ORDER BY 
    rental_count DESC
LIMIT 10
;

-- b. País donde más se rentan películas
SELECT 
    c.country,
    COUNT(r.rental_id) AS rental_count
FROM 
    Tbl_alquiler r
JOIN 
    TblDim_Cliente c ON r.customer_id = c.customer_id
GROUP BY 
    c.country
ORDER BY 
    rental_count DESC
LIMIT 1
;

-- c. Montos totales pagados por todos los clientes
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_payments
FROM 
    Tbl_alquiler r
JOIN 
    TblDim_Cliente c ON r.customer_id = c.customer_id
JOIN 
    TblDim_Pagos p ON r.payment_id = p.payment_id
GROUP BY 
    c.customer_id, customer_name
ORDER BY 
    total_payments DESC
;

-- d. Actor que más rentas ha registrado
SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    COUNT(r.rental_id) AS rental_count
FROM 
    Tbl_alquiler r
JOIN 
    TblDim_Actores a ON r.film_id = a.film_id
GROUP BY 
    a.actor_id, actor_name
ORDER BY 
    rental_count DESC
LIMIT 1
;

SELECT 
	payment_amount,
	payment_date
FROM
	Tbl_Alquiler r
JOIN
	TblDim_Pagos p ON r.payment_id = p.payment_id
ORDER BY
	payment_date ASC
;