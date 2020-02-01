use sakila; 
-- # 1 -- 
-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(first_name, ' ',last_name) AS ActorName FROM actor; 


-- # 2 --
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT * from actor 
where first_name = 'Joe'; 

-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT * from actor 
where last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT * from actor 
where last_name LIKE '%LI%'
ORDER BY last_name, first_name; 

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country from country
where country IN ('Afghanistan', 'Bangladesh','China'); 


-- # 3 -- 
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
	ADD COLUMN description BLOB; 
SELECT * from actor; 

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor DROP COLUMN description;


-- #4 -- 
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) as last_name_count FROM actor GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) as last_name_count FROM actor 
GROUP BY last_name
HAVING COUNT(*) > 1;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS'; 
select * from actor WHERE actor_id = 172; 

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! 
-- In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS'; 
SELECT * from actor WHERE actor_id = 172; 


-- #5 -- 
-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address; 


-- #6 --  
-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT s.first_name, s.last_name, s.address_id, a.address_id, a.address 
FROM staff s
JOIN address a ON 
s.address_id = a.address_id; 

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) as Total_RungUp_Amount
FROM payment p 
JOIN staff s ON
s.staff_id = p.staff_id 
GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT f.film_id, f.title, COUNT(a.actor_id) as NumberOfActors
FROM film f 
INNER JOIN film_actor a ON
f.film_id = a.film_id
GROUP BY f.film_id;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT * FROM film 
WHERE title = 'Hunchback Impossible'; 

SELECT film_id, COUNT(*) AS HunchbackCopies FROM inventory 
WHERE film_id = 439;

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS TotalPaid
FROM customer c
JOIN payment p ON
c.customer_id = p.customer_id
GROUP BY customer_id; 


-- #7 -- 
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
-- films starting with the letters `K` and `Q` have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title FROM film 
WHERE title IN
(    
SELECT title
FROM film
WHERE title LIKE "K%" OR title LIKE "Q%"
);  

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name, last_name, actor_id
FROM actor 
WHERE actor_id IN
	(
	SELECT actor_id 
	FROM film_actor
	WHERE film_id IN
		(
		SELECT film_id 
		FROM film
		WHERE title = 'Alone Trip'
		)
	); 

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email, country.country 
FROM customer 
JOIN address ON customer.address_id = address.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
WHERE country = 'Canada'; 
                                
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT * FROM film 
WHERE film_id IN
	(
	SELECT film_id 
	FROM film_category 
	WHERE category_id IN 
		(
        SELECT category_id FROM category
        WHERE name = "Family"
		)
	); 
    
-- 7e. Display the most frequently rented movies in descending order.
SELECT inventory.inventory_id,film.film_id, film.title, COUNT(*) AS rents 
FROM rental
JOIN inventory ON inventory.inventory_id = rental.inventory_id 
JOIN film ON  film.film_id = inventory.inventory_id
GROUP BY inventory_id
ORDER BY rents DESC; 

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(p.amount) as TotalSales 
FROM payment p 
JOIN staff ON staff.staff_id = p.staff_id 
JOIN store ON store.store_id = staff.store_id 
GROUP BY store.store_id; 

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, city.city, country.country 
FROM store s
JOIN address a ON s.address_id = a.address_id 
JOIN city ON city.city_id = a.city_id
JOIN country ON country.country_id = city.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
CREATE VIEW TopGrossGenres AS SELECT category.name, SUM(payment.amount) AS sales 
FROM payment
JOIN rental ON rental.rental_id = payment.rental_id 
JOIN inventory ON inventory.inventory_id = rental.inventory_id 
JOIN film ON  film.film_id = inventory.film_id
JOIN film_category ON film_category.film_id = film.film_id 
JOIN category ON category.category_id = film_category.category_id 
GROUP BY category.name
ORDER BY sales DESC ;


-- #8 -- 
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
		## see 7h ##
        
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM topgrossgenres; 

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW topgrossgenres; 
