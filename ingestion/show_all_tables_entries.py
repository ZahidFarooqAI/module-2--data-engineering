import os
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, inspect


def main() -> None:
    load_dotenv()

    db_user = os.getenv("POSTGRES_USER")
    db_password = os.getenv("POSTGRES_PASSWORD")
    db_host = os.getenv("POSTGRES_HOST")
    db_port = os.getenv("POSTGRES_PORT")
    db_name = os.getenv("POSTGRES_DB")

    database_url = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
    engine = create_engine(database_url)

    inspector = inspect(engine)
    tables = inspector.get_table_names(schema="public")

    if not tables:
        print("No tables found in schema: public")
        return

    print("Tables in public schema:")
    for table in tables:
        print(f"- {table}")

    print("\nTable entries:")
    for table in tables:
        print(f"\n=== {table} ===")
        df = pd.read_sql_table(table_name=table, con=engine, schema="public")
        if df.empty:
            print("(no rows)")
        else:
            print(df.to_string(index=False))


if __name__ == "__main__":
    main()
