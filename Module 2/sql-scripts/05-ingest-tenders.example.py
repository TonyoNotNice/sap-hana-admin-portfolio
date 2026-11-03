"""
05-ingest-tenders.example.py
TEMPLATE FILE - safe to commit to GitHub.
Replace placeholders with your own values and save as 05-ingest-tenders.py.
"""

import requests
from hdbcli import dbapi
from datetime import datetime

HANA_HOST = "YOUR_HANA_HOST"
HANA_PORT = 443
HANA_USER = "DBADMIN"
HANA_PASSWORD = "YOUR_DBADMIN_PASSWORD"

SECTOR_URL = "https://www.tenders-sa.org/api/widgets/sector-trends?limit=10"
AWARDS_URL = "https://www.tenders-sa.org/api/widgets/winners-feed"


def fetch_json(url):
    resp = requests.get(url, timeout=30)
    resp.raise_for_status()
    return resp.json()


def ingest_sector_trends(cursor, payload):
    rows = payload.get("data", [])
    for r in rows:
        cursor.execute(
            "INSERT INTO TENDER_MONITOR.SECTOR_TRENDS "
            "(SECTOR, TENDER_COUNT, TOTAL_VALUE, TREND) VALUES (?, ?, ?, ?)",
            (r.get("sector"), r.get("tenderCount"),
             r.get("totalValue"), r.get("trend"))
        )
    return len(rows)


def ingest_awards(cursor, payload):
    rows = payload.get("data", [])
    for r in rows:
        cursor.execute(
            "INSERT INTO TENDER_MONITOR.RECENT_AWARDS "
            "(AWARD_ID, SUPPLIER_NAME, AMOUNT, AWARD_DATE, ORG_NAME, PROVINCE) "
            "VALUES (?, ?, ?, ?, ?, ?)",
            (r.get("id"), r.get("supplierName"), r.get("amount"),
             r.get("date"), r.get("orgName"), r.get("province"))
        )
    return len(rows)


def main():
    print(f"[{datetime.now()}] Starting ingestion...")
    sector_payload = fetch_json(SECTOR_URL)
    awards_payload = fetch_json(AWARDS_URL)
    conn = dbapi.connect(
        address=HANA_HOST, port=HANA_PORT,
        user=HANA_USER, password=HANA_PASSWORD
    )
    cursor = conn.cursor()
    try:
        n_sectors = ingest_sector_trends(cursor, sector_payload)
        n_awards = ingest_awards(cursor, awards_payload)
        conn.commit()
        print(f"Inserted {n_sectors} sector rows")
        print(f"Inserted {n_awards} award rows")
        print(f"[{datetime.now()}] Done.")
    except Exception as e:
        conn.rollback()
        print(f"ERROR: {e}")
        raise
    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    main()