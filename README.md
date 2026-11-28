Scenario: S4 — Event Ticketing



# CMPE 351 — PostgreSQL Database Project

## Project Overview

This project implements a PostgreSQL database for an
Event Ticketing system that manages events, venues,
performances, seats, bookings, tickets and check-ins.

## Technologies

- PostgreSQL 18
- pgAdmin 4
- GitHub
- Draw.io

## M1 — Requirements and Database Design

### Documentation

- [Requirements](docs/requirements.md)
- [ER Design](docs/er_design.md)
- [ER Diagram](docs/ER_Diagram_v1.png)
- [Editable ER Diagram](docs/ER_Diagram_v1.drawio)
- [B2 Normalization](docs/normalization_b2.md)
- [B3 Normalization](docs/normalization_b3.md)

### SQL Verification

- [B2 Verification Script](sql/b2_verification.sql)

To verify B2, open the SQL script in the PostgreSQL
Query Tool and execute it.

Verification results:

- Original rows: 5
- Reconstructed rows: 5
- Missing rows: 0
- Additional rows: 0
- Result: PASS

## Project Milestones

| Milestone | Deadline | Tag |
|---|---|---|
| M1 | November 29, 2026 | m1 |
| M2 | December 13, 2026 | m2 |
| Final | December 27, 2026 | v1.0 |

## Current Status

The M1 requirements, ER design and normalization
exercises have been prepared.

The B2 SQL verification has passed.

The normalization examples use independently
constructed sample data and documented assumptions.

Database implementation will continue in M2.
