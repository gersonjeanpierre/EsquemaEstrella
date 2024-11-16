USE master
GO
DROP DATABASE IF EXISTS DMNorthwind
GO
CREATE DATABASE DMNorthwind
GO
USE DMNorthwind
GO
--------  T A B L E S  ------------
-- D I M    P R O D U C T
DROP TABLE IF EXISTS DimProduct
CREATE TABLE DimProduct (
  ProductID     INT             PRIMARY KEY,
  ProductName   NVARCHAR(40)    NOT NULL,
  CategoryName  NVARCHAR(40)    NOT NULL,
  UnitPrice     DECIMAL(10, 2)  NOT NULL,
  UnitsInStock  INT             NOT NULL,
)
GO
-- D I M    C U S T O M E R
DROP TABLE IF EXISTS DimCustomer
CREATE TABLE DimCustomer (
  CustomerID    NVARCHAR(5)  PRIMARY KEY,
  CompanyName   NVARCHAR(40) NOT NULL,
  ContactName   NVARCHAR(40) NOT NULL,
  ContactTitle  NVARCHAR(40) NOT NULL,
  City          NVARCHAR(30) NOT NULL,
  Country       NVARCHAR(30) NOT NULL,
)
GO
-- D I M    E M P L O Y E E
DROP TABLE IF EXISTS DimEmployee
CREATE TABLE DimEmployee (
  EmployeeID            INT           PRIMARY KEY,
  EmployeeName          NVARCHAR(40)  NOT NULL,
  Title                 NVARCHAR(40)  NOT NULL,
  RegionDescription     NVARCHAR(30)  NOT NULL,
)
GO
-- D I M    S U P P L I E R
DROP TABLE IF EXISTS DimSupplier
CREATE TABLE DimSupplier (
  SupplierID    INT          PRIMARY KEY,
  CompanyName   NVARCHAR(40) NOT NULL,
  ContactName   NVARCHAR(40) NOT NULL,
  ContactTitle  NVARCHAR(40) NOT NULL,
  City          NVARCHAR(30) NOT NULL,
  Country       NVARCHAR(30) NOT NULL,
)
GO
-- D I M    D A T E
DROP TABLE IF EXISTS DimDate
CREATE TABLE DimDate (
  DateID      INT   PRIMARY KEY,
  OrderDate   DATE  NOT NULL,
  Year        INT   NOT NULL,
  Month       INT   NOT NULL,
  Day         INT   NOT NULL,
  Quarter     INT   NOT NULL,
)
GO
-- D I M    S H I P P E R
DROP TABLE IF EXISTS DimShipper
CREATE TABLE DimShipper (
  ShipperID    INT          PRIMARY KEY,
  CompanyName  NVARCHAR(40) NOT NULL,
)
GO

-- F A C T    S A L E S
DROP TABLE IF EXISTS FactSales
CREATE TABLE FactSales (
  SalesID     INT             IDENTITY(1,1) PRIMARY KEY,
  OrderID     INT             NOT NULL,
  ProductID   INT             NOT NULL,
  CustomerID  NVARCHAR(5)     NOT NULL,
  EmployeeID  INT             NOT NULL,
  SupplierID  INT             NOT NULL,
  ShipperID   INT             NOT NULL,
  DateID      INT             NOT NULL,
  UnitPrice   DECIMAL(10, 2)  NOT NULL,
  Quantity    INT             NOT NULL,
  Discount    DECIMAL(5, 2)   NOT NULL,
  TotalPrice  DECIMAL(10, 2)  NOT NULL,
)
GO

-- F K   C O N S T R A I N T S
ALTER TABLE FactSales
ADD CONSTRAINT FK_FactSales_ProductID
FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID)
GO
ALTER TABLE FactSales
ADD CONSTRAINT FK_FactSales_CustomerID
FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID)
GO
ALTER TABLE FactSales ADD CONSTRAINT FK_FactSales_EmployeeID
FOREIGN KEY (EmployeeID) 
REFERENCES DimEmployee(EmployeeID);
GO
ALTER TABLE FactSales
ADD CONSTRAINT FK_FactSales_SupplierID
FOREIGN KEY (SupplierID) REFERENCES DimSupplier(SupplierID)
GO
ALTER TABLE FactSales
ADD CONSTRAINT FK_FactSales_DateID
FOREIGN KEY (DateID) REFERENCES DimDate(DateID)
GO
ALTER TABLE FactSales
ADD CONSTRAINT FK_FactSales_ShipperID
FOREIGN KEY (ShipperID) REFERENCES DimShipper(ShipperID)