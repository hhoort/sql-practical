--create database
create database practical
--create table customers
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  FirstName VARCHAR(255),
  LastName VARCHAR(255),
  Email VARCHAR(255),
  PhoneNumber VARCHAR(255)
);
--create table orders
CREATE TABLE Orders (
  OrderID INT primary key,
  CustomerID INT ,
  OrderDate DATE ,
  TotalAmount DECIMAL(10),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
--create table products
CREATE TABLE Products (
  ProductID INT PRIMARY KEy,
  ProductName VARCHAR(255),
  UnitPrice DECIMAL(10),
  InStockQuantity INT
);
--create table orderDetails
CREATE TABLE OrderDetails (
  OrderDetailID INT,
  OrderID INT primary key,
  ProductID INT,
  Quantity INT,
  UnitPrice DECIMAL(10),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
-- Insert data into Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, PhoneNumber)
VALUES
    (1, 'John', 'Doe', 'john.doe@example.com', '123-456-7890'),
    (2, 'Jane', 'Smith', 'jane.smith@example.com', '987-654-3210'),
    (3, 'Alice', 'Johnson', 'alice.johnson@example.com', '555-123-4567'),
	 (4, 'hoor', 'lu zhao shi', 'louzhaoshi@gmail.com', '555-123-4567'),
	  (5, 'muskan', 'hanif', 'muskan@gmail.com', '555-123-4567');

-- Insert data into Products table
INSERT INTO Products (ProductID, ProductName, UnitPrice, InStockQuantity)
VALUES
    (101, 'Product A', 19.99, 50),
    (102, 'Product B', 29.99, 30),
    (103, 'Product C', 39.99, 20);

-- Insert data into Orders table
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
    (1001, 1, '2024-02-07', 59.97),
    (1002, 2, '2024-02-08', 89.98);

-- Insert data into OrderDetails table
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES
    (5001, 1001, 101, 2, 19.99),
    (5002, 1003, 102, 1, 29.99),
    (5003, 1002, 103, 3, 39.99);

--Create a new user named Order_Clerk with permission to insert new
--orders and update order details in the Orders and OrderDetails tables.


CREATE LOGIN Order_Clerk WITH PASSWORD = 'your_password';

CREATE USER Order_Clerk FOR LOGIN Order_Clerk;

GRANT INSERT ON Orders TO Order_Clerk;
GRANT INSERT, UPDATE ON OrderDetails TO Order_Clerk;

--Create a trigger named Update_Stock_Audit that logs any updates made to the 
--InStockQuantity column of the Products table into a Stock_Update_Audit table.

CREATE TABLE Stock_Update_Audit (
    AuditID INT PRIMARY KEY,
    ProductID INT,
    OldStockQuantity INT,
    NewStockQuantity INT,
    UpdateTimestamp TIMESTAMP 
);
CREATE TRIGGER Update_Stock_Audit
ON ProductID int
as
BEGIN
  INSERT INTO Stock_Update_Audit (ProductID)
END

--Write a SQL query that retrieves the FirstName, LastName, OrderDate, and TotalAmount of 
--orders along with the customer details by joining the Customers and Orders tables.


SELECT  Customers.FirstName,Customers.LastName, Orders.OrderDate, Orders.TotalAmount FROM Customers JOIN Orders ON Customers.CustomerID = Orders.CustomerID;


--Write a SQL query that retrieves the ProductName, Quantity, and TotalPrice of products ordered in orders 
--with a total amount greater than the average total amount of all orders.

SELECT ProductName,Quantity,Quantity * OrderDetails.UnitPrice AS TotalPrice FROM Orders JOIN
OrderDetails ON Orders.OrderID = OrderDetails.OrderID JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);

--Create a stored procedure named GetOrdersByCustomer that takes a CustomerID 
--as input and returns all orders placed by that customer along with their details.

CREATE PROCEDURE GetOrdersByCustomer
 @InputCustomerID INT
AS
BEGIN
SELECT orders.OrderID,OrderDate,TotalAmount,OrderDetailID,ProductName,Quantity,
OrderDetails.UnitPrice FROM Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID  JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Orders.CustomerID = @InputCustomerID;
END;

EXEC GetOrdersByCustomer @InputCustomerID = 2;

--Write a SQL query to create a view named OrderSummary that displays the OrderID, OrderDate,
--CustomerID, and TotalAmount from the Orders table.

CREATE VIEW OrderSummary
AS
SELECT OrderID,OrderDate,CustomerID, TotalAmount FROM Orders;

SELECT * FROM OrderSummary;

--Create a view named ProductInventory that shows the ProductName and InStockQuantity from the Products table.

CREATE VIEW ProductInventory 
AS
SELECT ProductName,InStockQuantity FROM Products;

SELECT * FROM ProductInventory;

-- Write a SQL query that joins the OrderSummary view with the Customers table to retrieve the 
--customer's first name and last name along with their order details

SELECT OS.OrderID,OS.OrderDate,C.FirstName,C.LastName,OS.TotalAmount FROM OrderSummary OS JOIN Customers C
ON OS.CustomerID = C.CustomerID;

