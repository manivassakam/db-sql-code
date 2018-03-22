
/*********************************************** 
** File: Assignment4.sql 
** Desc: Assignment 4 
** Author: Manivassakam Mouttayen
** Date: 29th October 2016
************************************************/
SHOW DATABASES;
#select the sakila database where the tables needs to be created
USE sakila

#shows the list of all tables in the database
SHOW TABLES;

#provides information on table structure 
DESCRIBE actor;

#Count the no of records in the actor table 
SELECT COUNT(*) FROM actor;

#Select the first name and last name of all actors
SELECT first_name,last_name FROM actor;

# Insert your first name and middle initial ( in the last name column ) into the actors table
INSERT into actor VALUES (201,'MANIVASSAKAM','M','2016-10-19 04:34:33');
SELECT * FROM actor WHERE first_name like 'MANI%'

# Update your middle initial with your last name in the actors table. 
UPDATE actor set last_name='MOUTTAYEN' where last_name='M';
SELECT * FROM actor WHERE first_name like 'MANI%';

#Delete the record from the actor table where the first name matches your first name. 
SET SQL_SAFE_UPDATES = 0;
DELETE FROM actor WHERE first_name='MANIVASSAKAM';
SELECT * FROM actor WHERE first_name like 'MANI%';
# j) Create a table payment_type with the following specifications and appropriate data types 
# Table Name : “Payment_type” 
# Primary Key: "payment_type_id” 
# Column: “Type” 
# Insert following rows in to the table: 1, “Credit Card” ; 2, “Cash”; 3, “Paypal” ; 4 , “Cheque” 
DROP TABLE payment_type;
CREATE TABLE IF NOT EXISTS `sakila`.`payment_type` (
`payment_type_id` INT NOT NULL,
`Type` VARCHAR(45) NULL,
PRIMARY KEY (`payment_type_id`))
ENGINE = InnoDB;
DESCRIBE payment_type;
INSERT INTO payment_type VALUES (1,'Credit Card');
INSERT INTO payment_type VALUES (2,'Cash');
INSERT INTO payment_type VALUES (3,'Paypal');
INSERT INTO payment_type VALUES (4,'Cheque');
SELECT * FROM payment_type;

# k) Rename table payment_type to payment_types. 
RENAME TABLE payment_type to payment_types;

# l) Drop the table payment_types.
DROP TABLE payment_types;

################################## QUESTION 2 ################################ 
# a) List all the movies (title & description) that are rated PG-13 ? 
SELECT title,description,rating FROM FILM WHERE rating = 'PG-13';
# b) List all movies that are either PG OR PG-13 using IN operator? 
SELECT title,description,rating FROM film WHERE rating in('PG-13','PG');
#c) Report all payments greater than and equal to 2$ and Less than equal to 7$ ? 
# Note : write 2 separate queries conditional operator and BETWEEN keyword 
SELECT * FROM payment WHERE amount BETWEEN 2 and 7 LIMIT 5;
# Using conditional operator
SELECT * FROM payment WHERE amount >= 2 and amount<= 7;

# d) List all addresses that have phone number that contain digits 589, start with 140 or end with 589 # 
#Note : write 3 different queries 
SELECT * FROM address WHERE phone like '%589%';
#start with 140
SELECT * FROM address WHERE phone like '140%';
#End with 589
SELECT * FROM address WHERE phone like '%589';
# e) List all staff members ( first name, last name, email ) whose password is NULL ? 
SELECT first_name, last_name, email FROM staff WHERE password is
NULL;
# f) Select all films that have title names like ZOO and rental duration greater than or equal to 4 
SELECT title,rental_duration
 FROM film WHERE title like '%ZOO%' AND rental_duration >= 4;
# g) Display addresses as N/A when the address2 field is NULL # Note : use IF and CASE statements 
SELECT
IF (address2 is null, 'N/A', address) AS address
FROM address LIMIT 10;

# Using CASE Statement

SELECT
(CASE
WHEN ADDRESS2 IS NULL
THEN
'N/A'
ELSE
address
END) AS address from address LIMIT 10;

# h) What is the cost of renting the movie ACADEMY DINOSAUR for 2 weeks ? # Note : use of column alias 
SELECT title, 14*rental_rate AS 'Two Weeks Renting Cost' FROM film WHERE title='ACADEMY DINOSAUR';
# i) List all unique districts where the customers, staff, and stores are located # Note : check for NOT NULL values 
SELECT distinct(district) FROM sakila.address WHERE district IS
NOT NULL order by district;
# j) List the top 10 newest customers across all stores
SELECT * FROM customer ORDER BY create_date DESC LIMIT 10;

################################## QUESTION 3 ################################ 
# a) Show total number of movies 
SELECT COUNT(*) AS TOTAL_NO_OF_MOVIES FROM film;
# b) What is the minimum payment received and max payment received across all transactions ? 
SELECT min(amount) AS 'MINIMUM_PAYMENT', max(amount) AS 'MAXIMUM_PAYMENT' from payment;

# c) Number of customers that rented movies between Feb-2005 and May-2005 ( based on payment date ). 
SELECT count(*) AS NO_OF_CUSTOMERS FROM payment WHERE payment_date BETWEEN '20050201' AND '20050531';

# d) List all movies where replacement_cost is greater than 15$ or rental_duration is between 6 and 10 days 
SELECT title,replacement_cost,rental_duration FROM film where replacement_cost > 15 OR 
rental_duration between '6' AND '10';

# e) What is the total amount spent by customers for movies in the year 2005 ? 
SELECT sum(rental_rate) FROM film WHERE release_year='2005';

# f) What is the average replacement cost across all movies ? 
SELECT AVG(replacement_cost) FROM film;

# g) What is the standard deviation of rental rate across all movies ? Assignment 4 
SELECT STD(rental_rate) as 'Standard Deviation' from film;

# h) What is the midrange of the rental duration for all movies
SELECT AVG(rental_duration) FROM film;


################################## QUESTION 4 ################################ 
# a) Customers sorted by first Name and last name in ascending order. 
SELECT first_name, last_name FROM customer order by first_name ASC,last_name ASC;
# b) Group distinct addresses by district. 
SELECT distinct address FROM sakila.address group by district;
# c) Count of movies that are either G/NC-17/PG-13/PG/R grouped by rating. 
SELECT count(*) FROM film WHERE rating in ('G','NC-17','PG-13','PG','R');
# d) Number of addresses in each district. 
SELECT district, count(address) FROM address GROUP BY district;

# e) Find the movies where rental rate is greater than 1$ and order result set by descending order.
SELECT title,rental_rate FROM film WHERE rental_rate > '1' order by title DESC; 

# f) Top 2 movies that are rated R with the highest replacement cost ? 
SELECT title,rating,replacement_cost FROM film WHERE rating = 'R' order by replacement_cost DESC LIMIT 2; 

# g) Find the most frequently occurring (mode) rental rate across products. 

SELECT rental_rate, COUNT(*) FROM film GROUP BY rental_rate ORDER BY COUNT(rental_rate) DESC LIMIT 1;

# h) Find the top 2 movies with movie length greater than 50mins and which has commentaries as a special features. 

SELECT title,length,special_features FROM film WHERE length > 50 AND special_features LIKE
'%ommentaries%' ORDER BY length DESC LIMIT 2;

# i) List the years with more than 2 movies released.
SELECT release_year, title FROM film; 
SELECT distinct(release_year), count(*) FROM film GROUP BY release_year HAVING COUNT(*) > 2;

