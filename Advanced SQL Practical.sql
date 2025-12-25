/* SQL Script for Advanced SQL Assignment 
   Includes Schema Setup (Q6-Q9 Dataset) and Solutions
*/

-- DATASET SETUP --
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(1, 'Keyboard', 'Electronics', 1200),
(2, 'Mouse', 'Electronics', 800),
(3, 'Chair', 'Furniture', 2500),
(4, 'Desk', 'Furniture', 5500);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);

INSERT INTO Sales VALUES
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'),
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11');

---------------------------------------------------------
-- Q6: CTE for Total Revenue > 3000
---------------------------------------------------------
WITH ProductRevenue AS (
    SELECT 
        p.ProductName,
        (p.Price * s.Quantity) AS TotalRevenue
    FROM Products p
    JOIN Sales s ON p.ProductID = s.ProductID
)
SELECT * FROM ProductRevenue 
WHERE TotalRevenue > 3000;

---------------------------------------------------------
-- Q7: View for Category Summary
---------------------------------------------------------
CREATE VIEW vw_CategorySummary AS
SELECT 
    Category,
    COUNT(ProductID) AS TotalProducts,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

-- To test: SELECT * FROM vw_CategorySummary;

---------------------------------------------------------
-- Q8: Updatable View and Price Update
---------------------------------------------------------
-- Creating the view
CREATE VIEW vw_ProductPricing AS
SELECT ProductID, ProductName, Price
FROM Products;

-- Updating the price using the view
UPDATE vw_ProductPricing
SET Price = 1300.00 -- Example update value
WHERE ProductID = 1;

---------------------------------------------------------
-- Q9: Stored Procedure for Category Search
---------------------------------------------------------
DELIMITER //
CREATE PROCEDURE GetProductsByCategory(IN catName VARCHAR(50))
BEGIN
    SELECT * FROM Products 
    WHERE Category = catName;
END //
DELIMITER ;

-- To test: CALL GetProductsByCategory('Electronics');

-- Q10: AFTER DELETE Trigger for Archiving

-- 1. Create the Archive Table first
CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create the Trigger
DELIMITER //
CREATE TRIGGER trg_AfterProductDelete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive (ProductID, ProductName, Category, Price)
    VALUES (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price);
END //
DELIMITER ;

-- To test: DELETE FROM Products WHERE ProductID = 2;
-- Check archive: SELECT * FROM ProductArchive;