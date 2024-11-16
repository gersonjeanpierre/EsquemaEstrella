import pandas as pd
from src.db_connection import DatabaseConnection

class Extract:
    def __init__(self):
        self.db_engine = DatabaseConnection().get_engine()

    def fetch_data(self, query):
        return pd.read_sql(query, self.db_engine)

    def fetch_products(self):
        PRODUCTS_QUERY  = """SELECT ProductID, ProductName,
                            CA.CategoryName, UnitPrice, UnitsInStock 
                            FROM Products P
                            INNER JOIN Categories CA
                            ON P.CategoryID = CA.CategoryID
                          """
        return self.fetch_data(PRODUCTS_QUERY)

    def fetch_employees(self):
        EMPLOYEES_QUERY = """SELECT E.EmployeeID,
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
                            """
        return self.fetch_data(EMPLOYEES_QUERY)
    
    def fetch_customers(self):
        CUSTOMERS_QUERY = """SELECT CustomerID, CompanyName, ContactName,
                          ContactTitle, City, Country
                          FROM Customers"""
        return self.fetch_data(CUSTOMERS_QUERY)
      
    def fetch_suppliers(self):
        SUPPLIERS_QUERY = """SELECT SupplierID, CompanyName,
                          ContactName, ContactTitle, City, Country
                          FROM Suppliers"""
        return self.fetch_data(SUPPLIERS_QUERY)
    
    def fetch_date(self):
        DATE_QUERY = """SELECT D.DateID, OrderDate,
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
                      """
        return self.fetch_data(DATE_QUERY)
    
    def fetch_shippers(self):
        SHIPPERS_QUERY = """SELECT ShipperID, CompanyName
                          FROM Shippers"""
        return self.fetch_data(SHIPPERS_QUERY)
      
    def fetch_fact_sales(self):
        FACT_SALES_QUERY = """SELECT DISTINCT
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
                            """
        return self.fetch_data(FACT_SALES_QUERY)