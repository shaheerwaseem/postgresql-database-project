
# B3 — Third Normal Form and BCNF

## 1. Introduction

This exercise demonstrates a relation that satisfies
Third Normal Form (3NF) but violates Boyce-Codd Normal
Form (BCNF).

The example is based on staff assignments in the
Event Ticketing scenario.

## 2. Original Relation

StaffAssignment(performance_id, venue_id, staff_id)

### Assumptions

- Each staff member in this example is assigned to
  exactly one venue.
- For each performance and venue combination, there
  is at most one designated staff member.
- A staff member may be assigned to multiple performances.
- This is a separate normalization example with its
  own assumptions, not the complete staff assignment model.

### Sample Data

| performance_id | venue_id | staff_id |
|---|---|---|
| 201 | 401 | 501 |
| 202 | 401 | 501 |
| 203 | 402 | 502 |
| 204 | 402 | 503 |

## 3. Functional Dependencies

FD1: (performance_id, venue_id) -> staff_id

FD2: staff_id -> venue_id

These are the functional dependencies assumed for
this separate example.

## 4. Candidate Keys

### Key 1

(performance_id, venue_id)

Closure:

(performance_id, venue_id)+
= {performance_id, venue_id, staff_id}

Neither attribute alone determines all attributes.

Therefore, this is a minimal candidate key.

### Key 2

(performance_id, staff_id)

Closure:

(performance_id, staff_id)+
= {performance_id, staff_id, venue_id}

The venue_id is obtained through FD2.

Neither attribute alone determines all attributes.

Therefore, this is also a minimal candidate key.

### All Candidate Keys

- (performance_id, venue_id)
- (performance_id, staff_id)

Every candidate key must contain performance_id
because it cannot be derived from the other attributes.

Adding either venue_id or staff_id produces a
minimal superkey.

All three attributes are prime attributes because
each belongs to at least one candidate key.

## 5. Third Normal Form (3NF)

A relation satisfies 3NF if, for every non-trivial
functional dependency, either:

- The determinant is a superkey, or
- The dependent attribute is a prime attribute.

FD1 satisfies 3NF because its determinant is a
candidate key.

FD2 satisfies 3NF because venue_id is a prime
attribute, even though staff_id is not a superkey.

Therefore, StaffAssignment satisfies 3NF.

## 6. BCNF Violation

BCNF requires every determinant of a non-trivial
functional dependency to be a superkey.

The violating dependency is:

staff_id -> venue_id

The closure of staff_id is:

staff_id+ = {staff_id, venue_id}

This closure does not contain performance_id.

Therefore, staff_id is not a superkey, and the
relation violates BCNF.

## 7. BCNF Decomposition

The original relation is decomposed into two relations.

### StaffVenue

- staff_id (PK)
- venue_id

Functional dependency:

staff_id -> venue_id

### PerformanceStaff

- performance_id (PK)
- staff_id (PK, FK)

Composite primary key:

(performance_id, staff_id)

StaffVenue satisfies BCNF because staff_id is its key.

PerformanceStaff satisfies BCNF because it has no
non-trivial functional dependencies with a determinant
that is not a superkey.

Therefore, both resulting relations satisfy BCNF.

## 8. Lossless Join

The common attribute between the two relations is
staff_id.

staff_id determines all attributes in StaffVenue.

Therefore, the decomposition satisfies the lossless
join condition.

The original relation can be reconstructed by joining
StaffVenue and PerformanceStaff using staff_id.

## 9. Dependency Preservation

FD2 is preserved directly in StaffVenue:

staff_id -> venue_id

However, FD1 is not directly preserved:

(performance_id, venue_id) -> staff_id

The attributes of FD1 are distributed across the
two resulting relations.

The dependency cannot be enforced using only the
primary keys of the decomposed tables.

## 10. Enforcing the Lost Dependency

A PostgreSQL trigger could check the joined relations
before accepting a staff assignment.

The trigger would reject an assignment if another
staff member is already assigned to the same
performance and venue.

Changes to staff venue assignments must also be checked.

Concurrent changes must be controlled using appropriate
transaction isolation or locking to prevent two
conflicting assignments from being accepted.

This would preserve the original business constraint
across the decomposed relations.

## 11. Conclusion

The original relation satisfies 3NF because all its
attributes are prime attributes.

However, it violates BCNF because staff_id determines
venue_id without being a superkey.

The decomposition is lossless and produces two
BCNF relations, but one functional dependency is
not directly preserved.

Additional database enforcement is required to
maintain that dependency.
