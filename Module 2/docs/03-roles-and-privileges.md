# 03 - Roles and Privileges

## Objective
Design and enforce least-privilege access using a custom role and a non-admin user, applied to real-time data loaded from a live API.

## Data Source
Real-time data ingested from the Tenders-SA public widget API:
- /api/widgets/sector-trends  ->  TENDER_MONITOR.SECTOR_TRENDS
- /api/widgets/winners-feed   ->  TENDER_MONITOR.RECENT_AWARDS

## Schema and Tables

CREATE SCHEMA TENDER_MONITOR;

CREATE TABLE TENDER_MONITOR.SECTOR_TRENDS (
    SECTOR        NVARCHAR(200),
    TENDER_COUNT  INTEGER,
    TOTAL_VALUE   DECIMAL(20,2),
    TREND         NVARCHAR(20),
    LOADED_AT     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE TENDER_MONITOR.RECENT_AWARDS (
    AWARD_ID       NVARCHAR(100),
    SUPPLIER_NAME  NVARCHAR(300),
    AMOUNT         DECIMAL(20,2),
    AWARD_DATE     NVARCHAR(50),
    ORG_NAME       NVARCHAR(300),
    PROVINCE       NVARCHAR(100),
    LOADED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

## Data Ingestion Pipeline

Architecture:
Tenders-SA Public API -> Python (requests + hdbcli) -> SAP HANA Cloud

Script: 05-ingest-tenders.py

Ingestion result:
- 10 sector trend rows loaded
- 100 recent award rows loaded
- Total: 110 real SA tender records

Key design points:
- Parameterized INSERT statements prevent SQL injection
- conn.commit() on success, conn.rollback() on error - transaction safety
- LOADED_AT DEFAULT CURRENT_TIMESTAMP auto-records ingestion time

## Role Design

Role: TENDER_ANALYST

CREATE ROLE TENDER_ANALYST;
GRANT SELECT ON SCHEMA TENDER_MONITOR TO TENDER_ANALYST;

Privileges granted: SELECT on schema TENDER_MONITOR (all current and future objects)

Why schema-level: All objects in TENDER_MONITOR are analyst-facing tender data. No sensitive tables are mixed in. In a mixed schema, SAP guidance recommends granting per-table instead.

## User Design

User: TENDER_VIEWER

CREATE USER TENDER_VIEWER
    PASSWORD "..."
    NO FORCE_FIRST_PASSWORD_CHANGE
    SET USERGROUP DEFAULT;

GRANT TENDER_ANALYST TO TENDER_VIEWER;

- No admin privileges
- No write privileges
- No access to other schemas
- Lives in the DEFAULT user group

## Least-Privilege Verification

| Test | Expected | Actual | Evidence |
|---|---|---|---|
| SELECT on SECTOR_TRENDS | Succeeds | 10 rows returned | 09-viewer-can-read-data.png |
| SELECT on RECENT_AWARDS | Succeeds | 100 rows returned | 09-viewer-can-read-data.png |
| INSERT into SECTOR_TRENDS | Blocked | Blocked (error 258) | 10-viewer-cannot-insert.png |
| DELETE from SECTOR_TRENDS | Blocked | Blocked (error 258) | - |
| UPDATE on SECTOR_TRENDS | Blocked | Blocked (error 258) | - |
| DROP TABLE | Blocked | Blocked (error 258) | - |
| SELECT from SYS.USERS | Blocked | Blocked (error 258) | - |

Enforcement: Privilege boundaries are enforced by the HANA engine, not the application layer. Identical SQL statements succeed for DBADMIN and fail for TENDER_VIEWER.

## Key Learning

The principle of least privilege means giving users the smallest possible set of privileges for their actual job. A reporting analyst needs SELECT, not INSERT, UPDATE, or DELETE. If their account is compromised, an attacker cannot modify or delete data.

Role-based access control (RBAC) is the mechanism:
- Privileges attach to roles (not users directly)
- Users are granted roles based on their job function
- Change the role once - every user with it is updated

## See Also
- Module 2/sql-scripts/02-create-roles.sql
- Module 2/sql-scripts/05-ingest-tenders.py
- Module 1/docs/04-troubleshooting-incidents.md