from src.db_connection import DatabaseConnection

class Transform:
    def __init__(self, extractor):
        self.extractor = extractor

    def transform_sales_data(self):
      
        products_df = self.extractor.fetch_products()
        employees_df = self.extractor.fetch_employees()
        customers_df = self.extractor.fetch_customers()
        suppliers_df = self.extractor.fetch_suppliers()
        date_df = self.extractor.fetch_date()
        shipping_df = self.extractor.fetch_shippers()
        fact_sales_df = self.extractor.fetch_fact_sales()

        DatabaseConnection().close_connection()
        return products_df, employees_df, customers_df, suppliers_df, date_df, shipping_df , fact_sales_df
