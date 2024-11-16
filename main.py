from src.extract import Extract
from src.transform import Transform
from src.load import Load

def main():
    extractor = Extract()
    transformer = Transform(extractor)
    loader = Load(transformer.transform_sales_data())
    loader.load_data()

if __name__ == "__main__":
    main()