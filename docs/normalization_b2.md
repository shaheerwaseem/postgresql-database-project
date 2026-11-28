
# B2 — Legacy Export Normalization

## 1. Introduction

This document demonstrates the normalization of a legacy
Event Ticketing export from unnormalized form to BCNF.

The sample data and functional dependencies are based on
the assumptions of the S4 Event Ticketing database design.

## 2. Unnormalized Form (UNF)

The legacy system stores booking information together with
customer, event, performance, venue and ticket information.

A single booking may contain multiple seats and ticket prices.

Example:

| Booking ID | Customer ID | Customer Name | Performance ID | Event ID | Event Title | Venue ID | Venue Name | Seats | Prices |
|---|---|---|---|---|---|---|---|---|---|
| 101 | 1 | Ali | 201 | 301 | Music Festival | 401 | Main Hall | A1, A2 | 500, 500 |
| 102 | 2 | Sara | 201 | 301 | Music Festival | 401 | Main Hall | A3 | 500 |
| 103 | 1 | Ali | 202 | 302 | Comedy Night | 402 | City Theatre | B1, B2 | 300, 350 |

The Seats and Prices columns contain repeating groups.
Therefore, the relation is not in First Normal Form.

## 3. First Normal Form (1NF)

Repeating groups are removed by creating one row for each
seat in a booking.

| Booking ID | Seat Number | Customer ID | Customer Name | Performance ID | Event ID | Event Title | Venue ID | Venue Name | Price |
|---|---|---|---|---|---|---|---|---|---|
| 101 | A1 | 1 | Ali | 201 | 301 | Music Festival | 401 | Main Hall | 500 |
| 101 | A2 | 1 | Ali | 201 | 301 | Music Festival | 401 | Main Hall | 500 |
| 102 | A3 | 2 | Sara | 201 | 301 | Music Festival | 401 | Main Hall | 500 |
| 103 | B1 | 1 | Ali | 202 | 302 | Comedy Night | 402 | City Theatre | 300 |
| 103 | B2 | 1 | Ali | 202 | 302 | Comedy Night | 402 | City Theatre | 350 |

All attributes now contain atomic values.

### Assumptions

- Each booking belongs to one customer and one performance.
- Each performance belongs to one event and one venue.
- Seat numbers are unique within a venue.
- A seat appears at most once within the same booking.
- The ticket price is determined by the booking and seat.
- Customer, event and venue names are not assumed to be unique.

## 4. Functional Dependencies

FD1: booking_id -> customer_id, performance_id

FD2: customer_id -> customer_name

FD3: performance_id -> event_id, venue_id

FD4: event_id -> event_title

FD5: venue_id -> venue_name

FD6: (booking_id, seat_number) -> price

## 5. Candidate Keys and Attribute Closure

Candidate key:

(booking_id, seat_number)

### Closure of booking_id

booking_id+
= {booking_id, customer_id, customer_name,
   performance_id, event_id, event_title,
   venue_id, venue_name}

The closure does not contain seat_number or price.

Therefore, booking_id alone is not a candidate key.

### Closure of seat_number

seat_number+ = {seat_number}

Therefore, seat_number alone is not a candidate key.

### Closure of the composite key

(booking_id, seat_number)+
= {booking_id, seat_number, customer_id,
   customer_name, performance_id, event_id,
   event_title, venue_id, venue_name, price}

The closure contains every attribute in the relation.

Neither booking_id nor seat_number appears on the
right-hand side of the stated functional dependencies.
Therefore, every candidate key must contain both attributes.

Removing either attribute prevents the closure from
containing all attributes.

The only candidate key is therefore:

(booking_id, seat_number)

## 6. Second Normal Form (2NF)

The 1NF relation contains partial dependencies because
booking_id determines several non-key attributes without
requiring seat_number.

Violating dependency:

booking_id -> customer_id, performance_id

Through transitive dependencies, booking_id also determines
customer_name, event_id, event_title, venue_id and venue_name.

To remove these partial dependencies, the relation is
decomposed into:

### Booking_2NF

- booking_id (PK)
- customer_id
- customer_name
- performance_id
- event_id
- event_title
- venue_id
- venue_name

### Ticket_2NF

- booking_id (PK, FK)
- seat_number (PK)
- price

The ticket price depends on the complete composite key.

The partial dependencies have been removed.
Both relations satisfy 2NF.

## 7. Third Normal Form (3NF)

Booking_2NF still contains transitive dependencies.

Violating dependencies:

- customer_id -> customer_name
- performance_id -> event_id, venue_id
- event_id -> event_title
- venue_id -> venue_name

These dependencies are removed by creating separate
relations for customers, performances, events and venues.

### Customer

- customer_id (PK)
- customer_name

### Event

- event_id (PK)
- event_title

### Venue

- venue_id (PK)
- venue_name

### Performance

- performance_id (PK)
- event_id (FK)
- venue_id (FK)

### Booking

- booking_id (PK)
- customer_id (FK)
- performance_id (FK)

### Ticket

- booking_id (PK, FK)
- seat_number (PK)
- price

Every non-key attribute now depends on the key without
partial or transitive dependencies.

All six relations satisfy 3NF.

## 8. Boyce-Codd Normal Form (BCNF)

A relation satisfies BCNF when the determinant of every
non-trivial functional dependency is a superkey.

| Relation | Determinant | Superkey |
|---|---|---|
| Customer | customer_id | Yes |
| Event | event_id | Yes |
| Venue | venue_id | Yes |
| Performance | performance_id | Yes |
| Booking | booking_id | Yes |
| Ticket | booking_id, seat_number | Yes |

Under the stated functional dependencies, all six
relations already satisfy BCNF after the 3NF decomposition.

No additional decomposition is required.

## 9. Lossless Join

The decomposition is lossless because each decomposition
step shares attributes that determine one of the resulting
relations.

The 2NF decomposition shares booking_id, which determines
all attributes in Booking_2NF.

The 3NF decomposition separates customer, event and venue
information using their respective identifiers.

Performance information is separated using performance_id.

Each shared identifier is a key in its corresponding
relation.

The original 1NF relation can be reconstructed by joining:

- Ticket with Booking using booking_id.
- Booking with Customer using customer_id.
- Booking with Performance using performance_id.
- Performance with Event using event_id.
- Performance with Venue using venue_id.

These joins reconstruct the original rows without
introducing spurious combinations under the stated
dependencies.

## 10. Dependency Preservation

| Functional Dependency | Preserved In |
|---|---|
| booking_id -> customer_id, performance_id | Booking |
| customer_id -> customer_name | Customer |
| performance_id -> event_id, venue_id | Performance |
| event_id -> event_title | Event |
| venue_id -> venue_name | Venue |
| booking_id, seat_number -> price | Ticket |

All stated functional dependencies are preserved within
individual relations.

No joins are required to enforce these dependencies.

## 11. SQL Verification

The PostgreSQL verification script is located at:

../sql/b2_verification.sql

The script compares the original 1NF sample with the
reconstructed relation using EXCEPT ALL in both directions.

Expected results:

- Original minus reconstructed: 0 rows.
- Reconstructed minus original: 0 rows.

Both results must be empty to confirm that the sample
data has been reconstructed correctly.

## 12. Benefits of Normalization

Normalization prevents several data anomalies:

- Update anomaly: Customer names can be updated in one place.
- Insertion anomaly: Events and venues can be created
  without requiring a booking.
- Deletion anomaly: Deleting the last ticket of an event
  does not require deleting the event information.

## 13. Scope and Limitations

This exercise uses an independently constructed legacy
export based on the Event Ticketing scenario.

The separate scenario catalog and its additional B2
question were not available when preparing this example.

The normalized relations represent the legacy export only,
rather than the complete Event Ticketing database schema.

## 14. Conclusion

The legacy export was converted into 1NF, 2NF, 3NF and BCNF.

The resulting decomposition is theoretically lossless and
dependency-preserving under the stated assumptions.

SQL verification is used to confirm reconstruction of the
sample data.
