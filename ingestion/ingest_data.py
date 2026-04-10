import os
import time
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine

# Load environment variables from .env if present
load_dotenv()

# Wait for PostgreSQL to be ready
time.sleep(10)

# Load environment variables
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")
DB_HOST = os.getenv("POSTGRES_HOST")
DB_PORT = os.getenv("POSTGRES_PORT")
DB_NAME = os.getenv("POSTGRES_DB")

# Create database connection
DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(DATABASE_URL)

# File path
file_path = "data/raw/processed/sample_data.csv"

try:
    print("Reading CSV file...")
    df = pd.read_csv(file_path)

    print("Loading data into PostgreSQL...")
    df.to_sql("sales", engine, if_exists="replace", index=False)

    print("✅ Data successfully loaded into PostgreSQL!")

except Exception as e:
    print("❌ Error:", e)
