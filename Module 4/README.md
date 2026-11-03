# Module 4 — Performance Investigation

Diagnose and understand query performance in SAP HANA Cloud — building a large table, measuring baseline performance, examining the Explain Plan, and learning why the optimizer sometimes chooses a table scan over an index.

## Objectives

- Build a realistic performance test: 1,000,000 rows
- Measure baseline query performance via the plan cache
- Read an Explain Plan to understand the optimizer's choices
- Create a composite index and gather statistics
- Understand why column store tables don't always benefit from B-tree indexes
- Document the cold vs warm execution difference

## The Scenario

A realistic query on a large table:

SELECT COUNT(*) AS MATCHING_ROWS,
       SUM(AMOUNT) AS TOTAL_VALUE
FROM TENDER_MONITOR.AWARD_HISTORY
WHERE SUPPLIER_NAME = 'SUPPLIER_025000'
  AND PROVINCE = 'Gauteng';

Table: 1,000,000 rows of synthetic tender award data.

## Diagnostic Tools Used

| Tool | Purpose |
|---|---|
| M_SQL_PLAN_CACHE | Before/after execution times |
| EXPLAIN PLAN | Compiled operator tree — shows the chosen access path |
| INDEXES | Confirms index existence |
| M_DATA_STATISTICS | Confirms statistics objects exist |

## Key Findings

### The Optimizer Chose TABLE SCAN

Even after creating a composite B-tree index on (SUPPLIER_NAME, PROVINCE), the optimizer still chose a full table scan.

Why this is correct behavior: HANA uses column store storage by default. In column store:
- Each column is stored contiguously
- HANA builds automatic min-max segment indexes on every column
- Reading a full column is very fast (sequential, compressed)
- For aggregation queries (COUNT, SUM), a column scan often beats B-tree lookups

The index would help for:
- Row store tables
- Point lookups returning a single row
- Joins between large tables
- ORDER BY operations

### Cold vs Warm Execution

| Measurement | Value |
|---|---|
| First execution (cold) | ~1531 ms |
| Subsequent executions (warm) | ~14.8 ms |

What "cold" means: First execution of a query includes:
- SQL compilation and plan generation
- Loading the table's columns into memory
- Building query-specific caches

What "warm" means: Subsequent executions reuse the plan and the loaded columns, so only the actual query work remains.

The lesson: Never judge performance from a single run. Measure the same query multiple times.

### Statistics Gathering — HANA Cloud vs On-Prem

HANA Cloud uses a different statistics model than on-prem HANA:

| Task | On-Prem HANA | HANA Cloud |
|---|---|---|
| Create statistics | UPDATE STATISTICS COLUMN ... FOR ... | CREATE STATISTICS ON <table> (<cols>) |
| Refresh existing | UPDATE STATISTICS ... | REFRESH STATISTICS ON <table> |

Statistics are managed as data statistics objects in HANA Cloud.

## The Method Applied

1. Reproduce — created a 1M row table and a slow query
2. Measure baseline — captured AVG_MS from the plan cache
3. Gather evidence — ran EXPLAIN PLAN and read the operator tree
4. Hypothesize — missing index was the suspected cause
5. Change one variable — created the composite index
6. Re-measure — checked the plan cache again
7. Verify — re-ran EXPLAIN PLAN (operator unchanged — optimizer still chose TABLE SCAN)
8. Document — this README and the full docs

## Honest Conclusion

The index did not speed up this particular query — and that's the correct outcome. Column store tables are optimized for exactly this kind of aggregation scan. The B-tree index exists, is valid, and would be used for other query patterns.

The real skill demonstrated: understanding when an index will help and when it won't — rather than assuming "index = faster."

## Files in This Module

Module 4/
├── README.md                          <- this file
├── docs/
│   └── 07-performance-investigation.md    <- full documentation
├── evidence/
│   └── screenshots/                   <- PNG evidence
└── sql-scripts/
    └── 07-performance-tuning.sql      <- all SQL for this module

## Tools Used

- SAP HANA Database Explorer — SQL execution
- EXPLAIN PLAN — operator tree analysis
- M_SQL_PLAN_CACHE — before/after performance metrics
- M_DATA_STATISTICS — statistics object confirmation

## Module Status

Complete — 2026-09-15

## See Also

- Module 1 — Provisioning & User Administration
- Module 2 — Least-Privilege Roles & Real-Time Data
- Module 3 — System Monitoring
- Project Root — Full project README