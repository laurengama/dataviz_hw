USE sakila;

-- 1a
SELECT first_name, last_name FROM actor;

-- 1b
ALTER TABLE actor
ADD COLUMN actor_name VARCHAR(100);

UPDATE actor
SET actor_name = UPPER(CONCAT(first_name, ' ', last_name));

SELECT actor_name FROM actor;



-- 2a
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

-- 2b
SELECT * FROM actor WHERE last_name LIKE '%GEN%';

-- 2c
SELECT * FROM actor WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');



-- 3a 
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b
ALTER TABLE actor
DROP COLUMN description;



-- 4a
SELECT last_name, COUNT(last_name) AS 'Last_Name_Count'
FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name) AS 'Last_Name_Count'
FROM actor
GROUP BY last_name
HAVING Last_Name_Count >1;

-- 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name= 'WILLIAMS';

-- 4d
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name= 'WILLIAMS';



-- 5a
SHOW CREATE TABLE address;

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;



-- 6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address
ON (address.address_id = staff.address_id);

-- 6b
SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS 'AugTotal'
FROM staff
JOIN payment
ON (payment.staff_id = staff.staff_id)
WHERE payment.payment_date >= '2005-08-01 00:00:00' AND payment.payment_date < '2005-09-01 00:00:00'
GROUP BY staff.staff_id;

-- 6c
SELECT film.title, COUNT(film_actor.actor_id) AS 'NumActors'
FROM film
INNER JOIN film_actor 
ON (film_actor.film_id = film.film_id)
GROUP BY film.title;

-- 6d
SELECT COUNT(inventory_id) AS 'Hunchback Impossible Copies'
FROM inventory
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = 'HUNCHBACK IMPOSSIBLE'
);

-- 6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'Total Amount Paid'
FROM customer
JOIN payment 
ON (payment.customer_id = customer.customer_id)
GROUP BY customer.customer_id
ORDER BY customer.last_name ASC;



-- 7a
SELECT title
FROM film
WHERE language_id IN
(
SELECT language_id
FROM language
WHERE name = 'English'
)
AND (title LIKE 'K%' OR title LIKE 'Q%');

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
   SELECT film_id
   FROM film
   WHERE title = 'ALONE TRIP'
  )
);

-- 7c
SELECT customer.first_name, customer.last_name, customer.email 
FROM customer 
JOIN address ON address.address_id = customer.address_id
JOIN city ON city.city_id = address.city_id
JOIN country on country.country_id = city.country_id
WHERE country.country = 'Canada';

-- 7d
SELECT title AS 'Family Films'
FROM film
WHERE film_id IN
(
  SELECT film_id
  FROM film_category
  WHERE category_id IN
  (
   SELECT category_id
   FROM category
   WHERE name = 'Family'
  )
);

-- 7e
SELECT film.title, COUNT(rental.inventory_id) AS 'Frequency'
FROM film
JOIN inventory
ON (film.film_id = inventory.film_id)
JOIN rental
ON (rental.inventory_id = inventory.inventory_id)
GROUP BY film.title
ORDER BY Frequency DESC;

-- 7f
SELECT store.store_id, SUM(amount) AS 'Total Sales'
FROM payment
JOIN rental
ON (payment.rental_id = rental.rental_id)
JOIN inventory
ON (inventory.inventory_id = rental.inventory_id)
JOIN store
ON (store.store_id = inventory.store_id)
GROUP BY store.store_id;

-- 7g
SELECT store.store_id, city.city, country.country
FROM store
JOIN address 
ON (address.address_id = store.address_id)
JOIN city 
ON (city.city_id = address.city_id)
JOIN country 
ON (country.country_id = city.country_id);

-- 7h
SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Gross_Revenue'
FROM category
JOIN film_category 
ON (film_category.category_id = category.category_id)
JOIN inventory 
ON (inventory.film_id = film_category.film_id)
JOIN rental 
ON (rental.inventory_id = inventory.inventory_id)
JOIN payment 
ON (payment.rental_id = rental.rental_id)
GROUP BY Genre
ORDER BY Gross_Revenue DESC
LIMIT 5;

-- 8a
CREATE VIEW top_five_genres AS
SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Gross_Revenue'
FROM category
JOIN film_category 
ON (film_category.category_id = category.category_id)
JOIN inventory 
ON (inventory.film_id = film_category.film_id)
JOIN rental 
ON (rental.inventory_id = inventory.inventory_id)
JOIN payment 
ON (payment.rental_id = rental.rental_id)
GROUP BY Genre
ORDER BY Gross_Revenue DESC
LIMIT 5;

-- 8b
SELECT * FROM top_five_genres;

-- 8c
DROP VIEW top_five_genres;
