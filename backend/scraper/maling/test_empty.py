import psycopg2 as pg
import os
import sys
def main():
    conn = pg.connect(dbname='postgres', host='database',\
            user='postgres', password=os.environ['POSTGRES_PASSWORD'])
    with conn.cursor() as cur:
        # if table Paints is empty
        cur.execute('SELECT COUNT(*) FROM Paints;')
        if cur.fetchone()[0] != 0:
            print("Table Paints is non-empty. Returning")
            conn.close()
            sys.exit(1) # Paints is non-empty
        else:
            print("Table Paints is empty. Updating table")
            conn.close
            sys.exit(0) # Paints is empty
if __name__ == "__main__":
    main()
