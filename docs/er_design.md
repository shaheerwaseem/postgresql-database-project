
# S4 — Event Ticketing

## ER Design v1

### Entities and Attributes

PK = Primary Key

| Entity | Primary Key | Other Attributes |
|---|---|---|
| Customer | customer_id | name, email, phone |
| Organizer | organizer_id | name, email |
| Event | event_id | title, description |
| EventCategory | category_id | category_name |
| Performance | performance_id | start_time, end_time |
| Venue | venue_id | name, address |
| Seat | venue_id, seat_number | row_number, is_available |
| Booking | booking_id | booking_date, status |
| Ticket | ticket_id | price, status |
| Payment | payment_id | amount, payment_date, status |
| Staff | staff_id | name, email |
| VenueManager | staff_id | assigned_date |
| CheckInStaff | staff_id | shift |
| CheckIn | checkin_id | checkin_time |
| TicketType | type_id | type_name, description |




### Relationships and Cardinalities

| Entity A | Relationship | Entity B | Cardinality |
|---|---|---|---|
| Organizer | Creates | Event | 1:N |
| EventCategory | Classifies | Event | 1:N |
| Event | Has | Performance | 1:N |
| Venue | Hosts | Performance | 1:N |
| Venue | Contains | Seat | 1:N |
| Customer | Makes | Booking | 1:N |
| Booking | Contains | Ticket | 1:N |
| Booking | Has | Payment | 1:N |
| Performance | Has | Ticket | 1:N |
| Seat | Assigned to | Ticket | 1:N |
| TicketType | Classifies | Ticket | 1:N |
| Ticket | Has | CheckIn | 1:1 |
| CheckInStaff | Records | CheckIn | 1:N |
| Staff | Supervises | Staff | 1:N |
| VenueManager | Manages | Venue | 1:N |




### Many-to-Many Relationships

#### 1. Performance and TicketType

- A performance can offer multiple ticket types.
- A ticket type can be offered at multiple performances.
- Relationship name: Offers
- Cardinality: M:N
- Relationship attribute: price

#### 2. CheckInStaff and Performance

- A staff member can be assigned to multiple performances.
- A performance can have multiple check-in staff members.
- Relationship name: AssignedTo
- Cardinality: M:N
- Relationship attribute: assigned_at




### Participation Constraints

T = Total (mandatory)
P = Partial (optional)

| Entity A | Relationship | Entity B | A Participation | B Participation |
|---|---|---|---|---|
| Organizer | Creates | Event | P | T |
| EventCategory | Classifies | Event | P | T |
| Event | Has | Performance | P | T |
| Venue | Hosts | Performance | P | T |
| Venue | Contains | Seat | T | T |
| Customer | Makes | Booking | P | T |
| Booking | Contains | Ticket | P | T |
| Booking | Has | Payment | P | T |
| Performance | Has | Ticket | P | T |
| Seat | Assigned to | Ticket | P | T |
| TicketType | Classifies | Ticket | P | T |
| Ticket | Has | CheckIn | P | T |
| CheckInStaff | Records | CheckIn | P | T |
| Staff | Supervises | Staff | P | P |
| VenueManager | Manages | Venue | P | T |
| Performance | Offers | TicketType | T | P |
| CheckInStaff | AssignedTo | Performance | P | P |



### Weak Entity

Seat is a weak entity because it depends on Venue for its identification.

- Owner entity: Venue
- Partial key: seat_number
- Primary key: (venue_id, seat_number)
- Identifying relationship: Contains

A seat cannot exist without its venue.

### Recursive Relationship

Staff has a recursive relationship called Supervises.

- One staff member can supervise multiple staff members.
- Each staff member can have at most one supervisor.
- Having a supervisor is optional.
- A staff member cannot supervise themselves.

### Specialization

Staff is the superclass of two subclasses:

- VenueManager
- CheckInStaff

The specialization is total and disjoint. Every staff member belongs to exactly one of these subclasses.

### Mapping Rationale

- Each regular entity will have its own table.
- One-to-many relationships will use foreign keys.
- Many-to-many relationships will use separate junction tables.
- Seat will use a composite primary key.
- Staff supervision will use a self-referencing foreign key.
- Each Staff subclass will have a separate table using staff_id as both its primary key and foreign key.




### Additional Design Constraints

#### Performance and Booking

- Relationship: Receives
- Cardinality: 1:N
- Performance participation: Partial
- Booking participation: Total

Each booking belongs to exactly one performance.
A performance can exist without any bookings.

#### Additional Business Constraints

- All tickets in a booking must belong to the same performance.
- The assigned seat must belong to the venue hosting the performance.
- The ticket type must be offered by the selected performance.
- A check-in must be recorded by a staff member assigned to that performance.
- Each venue must have a venue manager.
- Each performance must offer at least one ticket type.
- Each event must belong to one event category.
- Cancelled tickets do not prevent seats from being booked again.
- A booking cannot be cancelled after a ticket has been checked in.

### ER Diagram

The editable ER diagram is available in ER_Diagram_v1.drawio.

![ER Diagram v1](ER_Diagram_v1.png)







