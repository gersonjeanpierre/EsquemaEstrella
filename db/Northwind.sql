USE Northwind
GO

--D I M   P R O D U C T S
SELECT ProductID, ProductName, CA.CategoryName, UnitPrice, UnitsInStock 
FROM Products P
INNER JOIN Categories CA
ON P.CategoryID = CA.CategoryID

-- D I M   E M P L O Y E E S
SELECT E.EmployeeID,
CONCAT(LastName,' ',FirstName) as EmployeeName, 
Title, R.RegionDescription 
FROM Employees E
INNER JOIN EmployeeTerritories ET
ON E.EmployeeID = ET.EmployeeID
INNER JOIN Territories T
ON ET.TerritoryID = T.TerritoryID
INNER JOIN Region R
ON T.RegionID = R.RegionID
GROUP BY E.EmployeeID, LastName, FirstName, Title, R.RegionDescription

-- D I M   C U S T O M E R S
SELECT CustomerID,CompanyName, ContactName,ContactTitle,City,Country
FROM Customers

-- D I M   S U P P L I E R S
SELECT SupplierID,CompanyName, ContactName,ContactTitle,City,Country
FROM Suppliers

-- D I M   D A T E
SELECT D.DateID,
OrderDate, 
DATEPART(yy,OrderDate) AS Year ,
DATEPART(mm,OrderDate) AS Month,
DATEPART(dd,OrderDate) AS Day,
DATEPART(qq,OrderDate) AS Quarter
FROM Orders O
INNER JOIN 
    (SELECT 
        OrderID, 
        DATEPART(yy, OrderDate) * 10000 + DATEPART(mm, OrderDate) * 100 + DATEPART(dd, OrderDate) AS DateID
    FROM 
        Orders) D ON O.OrderID = D.OrderID
GROUP BY D.DateID, OrderDate


SELECT D.DateID, OrderDate,
                        DATEPART(yy,OrderDate) AS Year ,
                        DATEPART(mm,OrderDate) AS Month,
                        DATEPART(dd,OrderDate) AS Day,
                        DATEPART(qq,OrderDate) AS Quarter
                        FROM Orders O
                        INNER JOIN (SELECT OrderID, 
                        DATEPART(yy, OrderDate) * 10000 + 
                        DATEPART(mm, OrderDate) * 100 + 
                        DATEPART(dd, OrderDate) AS DateID
                        FROM Orders) D ON O.OrderID = D.OrderID
                        GROUP BY D.DateID, OrderDate

-- D I M   S H I P P E R 
SELECT ShipperID,CompanyName
FROM Shippers


-- F A C T   S A L E S
SELECT DISTINCT
    O.OrderID,
    P.ProductID,
    O.CustomerID,
    E.EmployeeID,
    S.SupplierID,
    SH.ShipperID,
    D.DateID,
    OD.UnitPrice,
    OD.Quantity,
    ROUND(OD.Discount,2) AS Discount,
    ROUND((OD.UnitPrice * OD.Quantity * (1 - OD.Discount)),2) AS TotalPrice
FROM Orders O
INNER JOIN [Order Details] OD 
ON O.OrderID = OD.OrderID
INNER JOIN Products P 
ON OD.ProductID = P.ProductID
INNER JOIN Employees E 
ON O.EmployeeID = E.EmployeeID
INNER JOIN EmployeeTerritories ET 
ON E.EmployeeID = ET.EmployeeID
INNER JOIN Territories T 
ON ET.TerritoryID = T.TerritoryID
INNER JOIN Region R 
ON T.RegionID = R.RegionID
INNER JOIN Suppliers S 
ON P.SupplierID = S.SupplierID
INNER JOIN Shippers SH
ON O.ShipVia = SH.ShipperID
INNER JOIN (SELECT OrderID, 
DATEPART(yy, OrderDate) * 10000 + 
DATEPART(mm, OrderDate) * 100 + 
DATEPART(dd, OrderDate) AS DateID
FROM Orders) D 
ON O.OrderID = D.OrderID