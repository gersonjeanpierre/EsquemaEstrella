from src.db_connection import DatabaseConnection

TABLES = ['DimProduct','DimEmployee','DimCustomer','DimSupplier','DimDate','DimShipper','FactSales']

class Load:
    def __init__(self, data):
        self.db_engine = DatabaseConnection("DB_NAME_LOAD").get_engine()
        self.data = data
        
    def load_data(self):
      for i, dataframe in enumerate(self.data):
          dataframe.to_sql(TABLES[i], self.db_engine, if_exists='append', index=False)
          print(f"$$$$$$$$$$$$$$$$$ {table_names(TABLES[i])}  data loaded successfully $$$$$$$$$$$$$$$$$")
      DatabaseConnection().close_connection()
      print("ETL process completed successfully")
      
def table_names(name):
    wrapper = [" "]*11
    name = list(name)
    for i in range(len(name)):
        wrapper[i] = name[i]
    return "".join(wrapper)