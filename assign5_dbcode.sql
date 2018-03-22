
/*********************************************** 
** File: Assignment5.sql 
** Desc: Assignment 5
** Author: Manivassakam Mouttayen
** Date: 1st November 2016
************************************************/
SHOW DATABASES;
#select the sakila database where the tables needs to be created
USE sakila;
#shows the list of all tables in the database
SHOW TABLES;

#List the actors (firstName, lastName) who acted in more then 25 movies.
# Note: Also show the count of movies against each actor

SELECT first_name,last_name,COUNT(film_actor.actor_id)from actor 
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.first_name, actor.last_name, actor.actor_id 
HAVING COUNT(film_actor.actor_id) >= '25';

# b) List the actors who have worked in the German language movies.
SELECT first_name,last_name,language.name from actor 
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
INNER JOIN language ON film.language_id = language.language_id
WHERE language.name ='German';

# Note: Please execute the below SQL before answering this question.
SET SQL_SAFE_UPDATES=0;
UPDATE film SET language_id=6 WHERE title LIKE "%ACADEMY%";

# c) List the actors who acted in horror movies.
SELECT first_name,last_name,category.name from actor 
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name ='Horror';

# d) List all customers who rented more than 3 horror movies.
# Note: Show the count of movies against each actor in the result set.
SELECT first_name,last_name,COUNT(*) as cnt from customer
INNER JOIN rental ON customer.customer_id = rental.customer_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = "Horror" 
GROUP BY rental.customer_id HAVING cnt > 3;

# e) List all customers who rented the movie which starred SCARLETT BENING
SELECT customer.first_name,customer.last_name,actor.first_name,actor.last_name from customer
INNER JOIN rental ON customer.customer_id = rental.customer_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN film_actor on film_category.film_id = film_actor.film_id
INNER JOIN actor on film_actor.actor_id = actor.actor_id
where actor.first_name = 'SCARLETT' AND actor.last_name = 'BENING';

# f) Which customers residing at postal code 62703 rented movies that were Documentaries.
SELECT customer.first_name,customer.last_name,address.postal_code,category.name from customer
INNER JOIN rental ON customer.customer_id = rental.customer_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category on film_category.category_id = category.category_id
INNER JOIN address on customer.address_id = address.address_id
where address.postal_code = '62703' AND category.name = 'Documentary';

# g) Find all the addresses where the second address line is not empty (i.e., contains some text), and return these second addresses sorted.
DESCRIBE address;
SELECT * FROM address where address2 != null;

# h) How many films involve a “Crocodile” and a “Shark” based on film description ?
SELECT count(*) FROM film where ( description like '%hark%' AND description like '%rocodile%');




# i) List the actors who played in a film involving a “Crocodile” and a “Shark”, along with the release year of the movie, 
# sorted by the actors’ last names.
SELECT actor.last_name,actor.first_name,film.release_year,film.description FROM film 
INNER JOIN film_actor ON film.film_id = film_actor.film_id
INNER JOIN actor ON film_actor.actor_id = actor.actor_id
where ( description like '%hark%' AND description like '%rocodile%')
order by actor.last_name;

# j) Find all the film categories in which there are between 55 and 65 films. 
#Return the names of categories and the number of films per category, sorted from highest to lowest by the number of films.
SELECT name, count(*) from category 
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
GROUP BY category.category_id
HAVING count(*) >= '55' AND count(*) <= '65';

# k) In which of the film categories is the average difference between the film replacement cost and the rental rate larger than 17$?
SELECT replacement_cost, rental_rate,category.category_id,category.name, (avg(film.replacement_cost) - avg(rental_rate)) as diff FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON  film_category.category_id = category.category_id 
GROUP BY category.category_id
HAVING (avg(film.replacement_cost) - avg(rental_rate)) > '17';


# l) Many DVD stores produce a daily list of overdue rentals so that customers can be contacted and asked to 
#return their overdue DVDs. To create such a list, search the rental table for films with a return date that 
#is NULL and where the rental date is further in the past than the rental duration specified in the film table. 
#If so, the film is overdue and we should produce the name of the film along with the customer name and phone number.

SELECT CONCAT(customer.last_name, ', ', customer.first_name) AS customer,
    address.phone, film.title
    FROM rental INNER JOIN customer ON rental.customer_id = customer.customer_id
    INNER JOIN address ON customer.address_id = address.address_id
    INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
    INNER JOIN film ON inventory.film_id = film.film_id
    WHERE rental.return_date IS NULL
    AND rental_date + INTERVAL film.rental_duration DAY < CURRENT_DATE()
    LIMIT 10;
    

# m) Find the list of all customers and staff given a store id
# Using Union Operator

select first_name, last_name from staff 
union all
select first_name, last_name from customer 
where store_id=2;




# Note : use a set operator, do not remove duplicates
########################## QUESTION 2 ##########################
# a) List actors and customers whose first name is the same as the first name of the actor with ID 8.
select 
CONCAT(customer.last_name, ', ', customer.first_name) AS customers, 
CONCAT(actor.last_name, ', ', actor.first_name) AS actors
from customer
inner join actor on
customer.first_name=actor.first_name 
where actor.actor_id=8;


# b) List customers and payment amounts, with payments greater than average the payment amount
select customer.customer_id,customer.first_name,payment.amount as paymentamt from customer
INNER JOIN payment on customer.customer_id = payment.customer_id
group by customer.customer_id
having  payment.amount > avg(payment.amount) ;

# c) List customers who have rented movies atleast once
# Note: use IN clause

select CONCAT(customer.last_name, ', ', customer.first_name) AS CUSTOMERS,customer.customer_id AS RENTAL_CUSTOMER_ID
 from customer where customer_id in (select customer_id from rental)
 order by RENTAL_CUSTOMER_ID

# d) Find the floor of the maximum, minimum and average payment amount
select FLOOR(min(amount)) as minimum, FLOOR(max(amount)) as maximum , floor(avg(amount)) as average from payment;

########################## QUESTION 3 ##########################
# a) Create a view called actors_portfolio which contains information about actors and films ( including titles and category).
DROP VIEW actors_portfolio;
create view actors_portfolio as
select film.film_id,actor.actor_id,film.title,category.name, CONCAT(actor.first_name, ' ', actor.last_name) AS ActorsName from actor
left join film_actor on actor.actor_id=film_actor.actor_id
left join film on film_actor.film_id=film.film_id
left join film_category on film.film_id=film_category.film_id
left join category on film_category.category_id=category.category_id;

# b) Describe the structure of the view and query the view to get information on the actor ADAM GRANT
describe actors_portfolio;
select * from actors_portfolio where ActorsName= 'ADAM GRANT';


# c) Insert a new movie titled Data Hero in Sci-Fi Category starring ADAM GRANT
# We cannot insert data into the View. We can only update the table

########################## QUESTION 4 ##########################
# a) Extract the street number ( characters 1 through 4 ) from customer addressLine1
SELECT LEFT(address,LOCATE(' ',address) - 1) as StreetNumber from address LIMIT 10;








# b) Find out actors whose last name starts with character A, B or C.
select CONCAT(actor.first_name, ' ', actor.last_name) AS ActorNames 
from actor where last_name like 'A%' or last_name like 'B%' or last_name like 'C%' 
order by last_name 
LIMIT 10;







# c) Find film titles that contains exactly 10 characters
select title as 10CharTitle from film 
where length(title)=10 
order by title 
LIMIT 10;




# d) Format a payment_date using the following format e.g "22/1/2016"
select DATE_FORMAT(payment_date,'%d/%m/%Y') as PaymentDate 
from payment 
LIMIT 10;







# e) Find the number of days between two date values rental_date & return_date
select DATE_FORMAT(rental_date,'%Y-%m-%d') as rental_date, 
       DATE_FORMAT(return_date,'%Y-%m-%d') as return_date, 
       datediff(return_date, rental_date) as NumberOfDaysBetween from rental 
       order by NumberOfDaysBetween 
       DESC LIMIT 10;
       
########################## QUESTION 5 ##########################
# Provide five additional queries (not already in the assignment) along with the specific business cases they address.

# Business Case 1 : Find out what types of Movie receive the higher rating for a specific year.
select count(*) as FilmsByRating, rating from film
 where release_year = 2006
 group by rating
 order by FilmsByRating DESC;
 
 # Actor most seen in child friend movies.
 
select CONCAT(actor.first_name, ' ', actor.last_name) AS ActorNames from actor
where actor_id in (
select actor_id from film_actor where film_id in (
select film_id from film where rating not in ('R','PG-13','NC-17'))) order by ActorNames

# Movies most sought After
select title, rental_duration from film order by rental_duration DESC LIMIT 20



# Least rented movies AND WHAT CONTRIBUTES TO IT long length movie or is it because of its rating

select title, rating, length, rental_duration from film
group by title, rating, length, rental_duration
order by rental_duration LIMIT 20






 # Rental Duration vs Rating
 
select rating, avg(rental_duration) as AverageRentalDuration from film
group by rating
order by AverageRentalDuration 


 
 

