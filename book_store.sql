-- CREATE TABLE BOOKS

DROP TABLE IF EXISTS BOOKS;
CREATE TABLE BOOKS (
Book_ID	SERIAL PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_Year INT,
Price NUMERIC(10,2),
Stock INT
);

-- CREATE TABLE CUSTOMERS

DROP TABLE IF EXISTS CUSTOMERS;
CREATE TABLE CUSTOMERS (
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(50),
Phone VARCHAR(15),
City VARCHAR(30),
Country VARCHAR(30)
);

ALTER TABLE CUSTOMERS
ALTER COLUMN City TYPE VARCHAR(50),
ALTER COLUMN Country TYPE VARCHAR(150);

-- CREATE TABLE ORDERS
/*
DROP TABLE IF EXISTS ORDERS;
CREATE TABLE ORDERS (
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES CUSTOMERS(CUSTOMER_ID),
Book_ID	INT REFERENCES BOOKS(BOOK_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)
); */

SELECT * FROM BOOKS;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;

-- IMPORT CSV FILES

COPY BOOKS (Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'G:\Data Analysis\MySQL\Projects\Project 1\Books.CSV'
DELIMITER ','
CSV HEADER

COPY CUSTOMERS (Customer_ID,Name, Email, Phone, City, Country)
FROM 'G:\Data Analysis\MySQL\Projects\Project 1\Customers.CSV'
DELIMITER ','
CSV HEADER

COPY ORDERS (Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'G:\Data Analysis\MySQL\Projects\Project 1\Orders.CSV'
DELIMITER ','
CSV HEADER

-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM BOOKS
WHERE GENRE = 'Fiction';

-- 2) Find books published after the year 1950:

SELECT * FROM BOOKS
WHERE PUBLISHED_YEAR > 1950;

-- 3) List all customers from the Canada:

SELECT * FROM CUSTOMERS
WHERE COUNTRY = 'Canada';

-- 4) Show orders placed in November 2023:

SELECT * FROM ORDERS
WHERE ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:

SELECT SUM(STOCK) AS TOTAL_STOCK FROM BOOKS;

-- 6) Find the details of the most expensive book:

SELECT * FROM BOOKS
ORDER BY PRICE DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT C.CUSTOMER_ID, C.NAME, O.QUANTITY FROM CUSTOMERS C
JOIN ORDERS O ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE QUANTITY > 1
ORDER BY QUANTITY;

-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT * FROM ORDERS
WHERE TOTAL_AMOUNT > 20;

-- 9) List all genres available in the Books table:

SELECT DISTINCT GENRE FROM BOOKS;

-- 10) Find the book with the lowest stock:

SELECT BOOK_ID, TITLE, STOCK FROM BOOKS
ORDER BY STOCK
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:

SELECT SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE FROM ORDERS;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT GENRE, SUM(QUANTITY) AS BOOKS_SOLD FROM BOOKS
JOIN ORDERS ON BOOKS.BOOK_ID = ORDERS.BOOK_ID
GROUP BY GENRE
ORDER BY BOOKS_SOLD DESC;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT AVG(PRICE) AS AVERAGE_PRICE FROM BOOKS
WHERE GENRE = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:

SELECT C.CUSTOMER_ID, C.NAME, O.QUANTITY FROM CUSTOMERS C
JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE O.QUANTITY >= 2
ORDER BY O.QUANTITY DESC;

-- 4) Find the most frequently ordered book:

SELECT O.BOOK_ID, B.TITLE, COUNT(O.ORDER_ID) AS QUANTITY FROM BOOKS B
JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY O.BOOK_ID, B.TITLE
ORDER BY QUANTITY DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT * FROM BOOKS
WHERE GENRE = 'Fantasy'
ORDER BY PRICE DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:

SELECT B.AUTHOR, SUM(O.QUANTITY) AS TOTAL_BOOKS_SOLD FROM BOOKS B
JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.AUTHOR
ORDER BY TOTAL_BOOKS_SOLD DESC;

-- 7) List the cities where customers who spent over $30 are located:
SELECT * FROM ORDERS

SELECT DISTINCT C.CITY, O.TOTAL_AMOUNT FROM CUSTOMERS C
JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE O.TOTAL_AMOUNT > 30;

-- 8) Find the customer who spent the most on orders:

SELECT * FROM CUSTOMERS

SELECT C.CUSTOMER_ID, C.NAME, SUM(O.TOTAL_AMOUNT) AS TOTAL FROM CUSTOMERS C
JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME
ORDER BY TOTAL DESC
LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT B.BOOK_ID, B.TITLE, B.STOCK, COALESCE(SUM(O.QUANTITY),0) AS ORDER_QUANTITY,
(B.STOCK - COALESCE(SUM(O.QUANTITY),0)) AS REMAINING_QUANTITY FROM BOOKS B
LEFT JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.BOOK_ID, B.TITLE, B.STOCK
ORDER BY B.BOOK_ID;
