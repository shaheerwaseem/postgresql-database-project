
# S4 — Event Ticketing

# Requirements Document

# Project Overview
A PostgreSQL database for managing event venues,
performances, seating, ticket bookings, and check-ins.

# Business Rules

BR1. Each event is created by one organizer.

BR2. An event can have multiple performances.

BR3. Each performance takes place at one venue.

BR4. Each venue contains multiple seats.

BR5. A customer can make multiple bookings.

BR6. Each booking belongs to one customer.

BR7. A seat cannot be booked twice for the same performance.

BR8. Each ticket is linked to one booking.

BR9. Each ticket is valid for one performance and one seat.

BR10. A ticket can only be checked in once.

BR11. A booking must be confirmed before its tickets can be used.

BR12. A cancelled booking cannot be used for check-in.

# Actors and Operations

The system has four main actors:

1. **Customer**
   - browses available events and performances.
   - books seats and purchases tickets.
   - views existing bookings.
  
2. **Event Organizer**
   - Creates and updates events.
   - schedules performances at venues.
   - sets ticket prices.
  
3. **Venue Manager**
   - Adds and updates venue information.
   - Manages seating arrangements.
   - Marks seats as unavailable when necessary.

4. **Check-in Staff**
   - Checks ticket validity.
   - Records ticket check-ins.
   - Rejects invalid or previously used tickets.

# Assumptions

1. Customers must have an account before making bookings.
2. Each venue has a fixed seating arrangement.
3. Ticket prices are set by the event organizer.
4. A booking can contain multiple tickets for the same performance.
5. Only confirmed bookings produce valid tickets.
6. Each ticket has a unique identifier for check-in.
7. Cancelled bookings cannot be used to enter events.
8. Payments are recorded in the database, but payment processing is handled by an external service.




# Example Operations

# Successful Booking
1. A customer selects a performance.
2. The customer chooses two available seats.
3. The system checks that both seats are available.
4. The customer completes payment.
5. The booking is confirmed and two tickets are created.

# Rejected Booking
1. A customer selects a performance.
2. The customer chooses a seat that is already booked.
3. The system detects that the seat is unavailable.
4. The booking is rejected.
5. No new ticket is created.


# Database Invariants

1. Every customer must have a unique customer ID.
2. Every event must belong to an existing organizer.
3. Every performance must belong to an existing event and venue.
4. A seat can only have one active ticket per performance.
5. Every ticket must belong to an existing booking.
6. Every ticket must reference a valid performance and seat.
7. A ticket cannot be checked in more than once.
8. Cancelled bookings cannot have valid check-ins.

