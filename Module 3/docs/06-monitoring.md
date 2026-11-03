# 06 - System Monitoring

## Objective
Query SAP HANA Cloud monitoring views to observe memory, connections,
performance, storage, and system health on the live tender data loaded
in Module 2.

## Monitoring Views Used

| View | Purpose |
|---|---|
| M_CS_TABLES | Column store table memory |
| M_SERVICE_MEMORY | Service-level heap and total memory |
| M_CONNECTIONS | Active database connections |
| M_EXPENSIVE_STATEMENTS | Statements exceeding duration threshold |
| M_SQL_PLAN_CACHE | Cached query plans and statistics |
| M_SYSTEM_OVERVIEW | System health summary (OK/WARNING/ERROR) |
| M_DISKS | Disk usage per volume |

## Key Findings

### Table Memory (M_CS_TABLES)
- RECENT_AWARDS: 100 rows
- SECTOR_TRENDS: 10 rows
- Both tables are small — under 2 KB each in memory

### Service Memory (M_SERVICE_MEMORY)
- indexserver is the dominant memory consumer
- Total memory used: ~2.65 GB of 15.51 GB physical
- No swap usage — healthy in-memory operation

### Connections (M_CONNECTIONS)
- Active connections: DBADMIN session (Remote)
- Client host shows SAP's tooling service
- No unexpected connections

### System Health (M_SYSTEM_OVERVIEW)
| Section | Status | Value |
|---|---|---|
| CPU | OK | Available 32, Used 2.24 |
| Disk (Data/Log/Trace) | OK | 79.9 GB total, 2.4 GB used, 97% free |
| Memory | OK | Physical 15.51 GB, Used 2.65 GB |
| Services | OK | All Started |

### Disk Usage (M_DISKS)
Four volumes sharing one 80 GB device:
- /hana/mounts/data/ (DATA)
- /hana/mounts/log/ (LOG)
- /hana/mounts/backup/sec/ (ROOTKEY_BACKUP)
- /tmp/... (TRACE)

### Plan Cache (M_SQL_PLAN_CACHE)
- 20+ cached queries from the DBADMIN session
- All IS_VALID = TRUE

### Expensive Statements (M_EXPENSIVE_STATEMENTS)
- Trace enabled via ALTER SYSTEM ALTER CONFIGURATION
- No statements exceeding the 1-second threshold yet

## Case Sensitivity Lesson

**Issue:** WHERE SUPPLIER_NAME LIKE '%a%' returned 0 rows.
**Root cause:** HANA's LIKE operator is case-sensitive by default.
Real-world API data has inconsistent capitalization.
**Fix:** Use UPPER(SUPPLIER_NAME) LIKE '%A%'.
**Result:** 81 matching rows (vs 0 with case-sensitive query).

## Lessons Learned

1. Monitoring views are the database's self-telemetry — they answer
   "what's happening" (runtime state), not "what exists" (configuration).
2. M_SYSTEM_OVERVIEW is the one-query health check.
3. Memory monitoring has two layers: per-table (M_CS_TABLES) and
   per-service (M_SERVICE_MEMORY).
4. SQL views give point-in-time snapshots; GUI Performance Monitor
   gives time-series trends. Both are necessary.
5. Case sensitivity in LIKE predicates is a common real-world trap.
6. The expensive statements trace must be enabled explicitly.
7. The plan cache can be cleared on instance restart.