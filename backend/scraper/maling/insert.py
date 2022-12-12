import psycopg2 as pg
import json
import os
import sys

def main():
    conn = pg.connect(dbname='postgres', host='localhost',\
            user='postgres', password=os.environ['POSTGRES_PASSWORD'])
    with conn.cursor() as cur:
        data = json.load(sys.stdin)

        cur.executemany("""
        INSERT INTO Paints (name, productID, surfaceDry,
        recoatDry, curingTime, url, ImgURL)
        VALUES (%(navn)s, %(varenummer)s,
        %(støvtør)s, %(Genbehandlingstør)s,
        %(Gennemhærdet)s, %(url)s, %(img)s);
        """, data)

        conn.commit()
        conn.close()
    # insert everything from json file in stdin
if __name__ == "__main__":
    main()
