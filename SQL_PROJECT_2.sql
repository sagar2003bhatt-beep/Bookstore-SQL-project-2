0-- CREATE DATABASE 
CREATE DATABASE OnlineBookstore;

-- CREATE TABLES

DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
SELECT * FROM Books ;

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone INT,
    City VARCHAR(50),
    Country VARCHAR(150)
);
SELECT * FROM Customers;

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Orders;




--1) Retrieve all books in the 'Fiction' genre:

SELECT * FROM BOOKS 
WHERE Genre = 'Fiction';

--2) Find books published after the year 1950:

SELECT * FROM Books 
WHERE published_year > '1950' ;

--3) List all customers from the Canada:

SELECT * FROM Customers
WHERE Country = 'Canada';

--4) Show order placed in November 2023:

SELECT * FROM Orders 
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total stock of books available:
SELECT SUM(stock) as total_stock
FROM Books ;

--6) Find the details of the most expensive book:

SELECT * FROM Books 
ORDER BY price DESC 
LIMIT 1 ;

--7) Show all customers who ordered more than 1 quantity of a book:

SELECT * FROM Orders 
WHERE quantity > 1 ;

--8) Retrieve all orders where the total amount exceeds $20:

SELECT * FROM Orders 
WHERE total_amount > 20 ;

--9) List all the genre available in the Books table:

SELECT  DISTINCT genre FROM Books ;

--10) Find the book with the lowest stock:

SELECT * FROM Books 
ORDER BY Stock ASC
LIMIT 1 ; 

--11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS total_revenue
FROM Orders ;

-- ADVANCE QUESTIONS

--12) Retrieve the total number of books sold for each genre:

SELECT b.Genre, SUM(o.Quantity) AS total_boks_sold
FROM Orders as o
JOIN Books as b
ON b.book_id = o.book_id 
GROUP BY b.Genre ;

--13) Find the average price of books in the "Fantasy genre":

SELECT AVG(price) AS avg_price
FROM Books
WHERE Genre = 'Fantasy' ;

--14) List customers who have placed at least 2 orders:
SELECT customer_id,COUNT(order_id) AS oeder_count 
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id) >= 2 ;

--15) Find the most frequently ordered book:

SELECT b.book_id,
		b.title,
		COUNT(o.order_id) AS most_order 
		FROM Books b
		JOIN Orders o
	ON b.book_id = o.book_Id
	GROUP BY  b.book_id,b.title 
	ORDER BY most_order DESC
	LIMIT 1 ;

--16) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC 
LIMIT 3 ;

--17) Retrieve the total quantity of books sold by each author:
SELECT b.author,SUM(o.quantity) AS total_quantity
FROM Books b
JOIN Orders o
ON b.book_id = o.book_id 
GROUP BY b.author
ORDER BY total_quantity DESC;


--18) List the cities where customers who spent over $30 are located:
SELECT DISTINCT
    c.City
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.City
HAVING SUM(o.Total_Amount) > 30;

--19)Find the customer who spent the most on orders:

SELECT c.Customer_ID,
       c.Name,
       SUM(o.Total_Amount) AS Total_Spent
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;



--20) Calculate the stock remaining after fulfilling all orders:
SELECT b.Book_ID,
       b.Title,
       b.Stock AS Original_Stock,
       COALESCE(SUM(o.Quantity), 0) AS Total_Ordered,
       b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock;






