import urllib
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os

load_dotenv()

class DatabaseConnection:
    def __init__(self, DB_NAME="DB_NAME"):
        driver = os.getenv("DB_DRIVER")
        server = os.getenv("DB_SERVER")
        database = os.getenv(DB_NAME)
        user = os.getenv("DB_USER")
        password = os.getenv("DB_PASSWORD")

        conn = f"""Driver={driver};
                  Server=tcp:{server},1433;
                  Database={database};
                  Uid={user};Pwd={password};
                  Encrypt=yes;TrustServerCertificate=yes;Connection Timeout=30;"""
        params = urllib.parse.quote_plus(conn)
        self.conn_str = f'mssql+pyodbc:///?autocommit=true&odbc_connect={params}'
        self.engine = create_engine(self.conn_str, echo=False)
        
    def get_engine(self):
        print("########### Connection established ###########")
        return self.engine
      
    def close_connection(self):
        self.engine.dispose()
        print("########### Connection closed ################")
