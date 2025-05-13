-- question 1

-- Assume table Orders with same data

WITH RECURSIVE SplitProducts AS (
  SELECT 
    OrderID,
    CustomerName,
    SUBSTRING_INDEX(Products, ',', 1) AS Product,
    SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS Rest
  FROM Orders

  UNION ALL

  SELECT
    OrderID,
    CustomerName,
    SUBSTRING_INDEX(Rest, ',', 1),
    SUBSTRING(Rest, LENGTH(SUBSTRING_INDEX(Rest, ',', 1)) + 2)
  FROM SplitProducts
  WHERE Rest != ''
)

SELECT OrderID, CustomerName, TRIM(Product) AS Product
FROM SplitProducts;

-- question 2
-- Orders table (OrderID is the primary key)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert distinct orders
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OriginalTable;
-- OrderDetails table (composite primary key: OrderID + Product)
CREATE TABLE OrderDetails (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert detailed product info
INSERT INTO OrderDetails (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OriginalTable;
