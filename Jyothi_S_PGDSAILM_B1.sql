USE northwind;


-- confirm the database & tables
SELECT DATABASE();
SHOW TABLES;


-- Question 1: Template -> CustomerName
DESCRIBE customers;
SELECT * FROM customers LIMIT 5;
SELECT c.CustomerName AS CustomerName
FROM customers AS c;


-- Question 2: Template -> ProductName, Price (products that cost < $15)
DESCRIBE products;
SELECT * FROM products LIMIT 5;
SELECT p.ProductName AS ProductName,
       p.Price       AS Price
FROM products AS p
WHERE p.Price < 15;


-- Question 3: Template -> FirstName, LastName
SELECT e.FirstName AS FirstName,
       e.LastName  AS LastName
FROM employees AS e;


-- Question 4: Template -> OrderID, OrderDate (orders placed in 1997)
SELECT o.OrderID   AS OrderID,
       o.OrderDate AS OrderDate
FROM orders AS o
WHERE YEAR(o.OrderDate) = 1997;


-- Question 5: Template -> ProductName, Price (products currently in stock UnitsInStock > 0)
SELECT p.ProductName AS ProductName,
       p.Price       AS Price
FROM products AS p
WHERE p.Price > 50;


-- Question 6: Template -> CustomerName, FirstName, LastName (customers and the employee who handled their orders)
SELECT c.CustomerName AS CustomerName,
       e.FirstName    AS FirstName,
       e.LastName     AS LastName
FROM orders AS o
JOIN customers AS c ON c.CustomerID = o.CustomerID
JOIN employees AS e ON e.EmployeeID = o.EmployeeID;


-- Question 7: Template -> Country, CustomerCount
SELECT c.Country  AS Country,
       COUNT(*)   AS CustomerCount
FROM customers AS c
GROUP BY c.Country;


-- Question 8: Template -> CategoryName, AvgPrice
SELECT cat.CategoryName      AS CategoryName,
       ROUND(AVG(p.Price),2) AS AvgPrice
FROM products AS p
JOIN categories AS cat ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName;


-- Question 9: Template -> EmployeeID, OrderCount
SELECT o.EmployeeID AS EmployeeID,
       COUNT(*)     AS OrderCount
FROM orders AS o
GROUP BY o.EmployeeID;


-- Question 10: Template -> ProductName (products supplied by "Exotic Liquid")
DESCRIBE suppliers;
SELECT * FROM suppliers LIMIT 5;
SELECT p.ProductName AS ProductName
FROM products AS p
JOIN suppliers AS s ON s.SupplierID = p.SupplierID
WHERE s.SupplierName = 'Exotic Liquid';


-- Question 11: Template -> ProductID, TotalOrdered (top 3 most ordered by quantity)
DESCRIBE OrderDetails;
SELECT * FROM OrderDetails LIMIT 5;
SELECT od.ProductID     AS ProductID,
       SUM(od.Quantity) AS TotalOrdered
FROM orderdetails AS od
GROUP BY od.ProductID
ORDER BY TotalOrdered DESC
LIMIT 3;


-- Question 12: Template -> CustomerName, TotalSpent (customers with total orders > $10,000)
DESCRIBE orders;
SELECT * FROM orders LIMIT 5;
SELECT
  c.CustomerName AS CustomerName,
  ROUND(SUM(od.Quantity * p.Price), 2) AS TotalSpent
FROM customers AS c
JOIN orders AS o           ON o.CustomerID = c.CustomerID
JOIN orderdetails AS od    ON od.OrderID   = o.OrderID
JOIN products AS p         ON p.ProductID  = od.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING TotalSpent > 10000
ORDER BY TotalSpent DESC, CustomerName;


-- Question 13: Template -> OrderID, OrderValue (orders with total value > $2,000)
SELECT
  o.OrderID AS OrderID,
  ROUND(SUM(od.Quantity * p.Price), 2) AS OrderValue
FROM orders AS o
JOIN orderdetails AS od ON od.OrderID = o.OrderID
JOIN products AS p      ON p.ProductID = od.ProductID
GROUP BY o.OrderID
HAVING OrderValue > 2000
ORDER BY OrderValue DESC, o.OrderID;


-- Question 14: Template -> CustomerName, OrderID, TotalValue (customer(s) with largest single order)
SELECT
  c.CustomerName AS CustomerName,
  t.OrderID      AS OrderID,
  ROUND(t.TotalValue, 2) AS TotalValue
FROM (
  SELECT
    o.OrderID,
    o.CustomerID,
    SUM(od.Quantity * p.Price) AS TotalValue
  FROM orders o
  JOIN orderdetails od ON od.OrderID = o.OrderID
  JOIN products p      ON p.ProductID = od.ProductID
  GROUP BY o.OrderID, o.CustomerID
) AS t
JOIN customers c ON c.CustomerID = t.CustomerID
WHERE t.TotalValue = (
  SELECT MAX(x.TotalValue) FROM (
    SELECT SUM(od2.Quantity * p2.Price) AS TotalValue
    FROM orders o2
    JOIN orderdetails od2 ON od2.OrderID = o2.OrderID
    JOIN products p2      ON p2.ProductID = od2.ProductID
    GROUP BY o2.OrderID
  ) AS x
)
ORDER BY CustomerName, OrderID;


-- Question 15: Template -> ProductName (products never ordered)
DESCRIBE shippers;
SELECT * FROM shippers LIMIT 5;
SELECT
  p.ProductName AS ProductName
FROM products AS p
LEFT JOIN orderdetails AS od ON od.ProductID = p.ProductID
WHERE od.ProductID IS NULL
ORDER BY p.ProductName;