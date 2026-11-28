
BEGIN;

-- Original flattened 1NF data

CREATE TEMP TABLE b2_legacy (
    booking_id INT,
    seat_number VARCHAR(10),
    customer_id INT,
    customer_name VARCHAR(100),
    performance_id INT,
    event_id INT,
    event_title VARCHAR(100),
    venue_id INT,
    venue_name VARCHAR(100),
    price NUMERIC(10,2),
    PRIMARY KEY (booking_id, seat_number)
);

INSERT INTO b2_legacy VALUES
(101, 'A1', 1, 'Ali', 201, 301, 'Music Festival', 401, 'Main Hall', 500),
(101, 'A2', 1, 'Ali', 201, 301, 'Music Festival', 401, 'Main Hall', 500),
(102, 'A3', 2, 'Sara', 201, 301, 'Music Festival', 401, 'Main Hall', 500),
(103, 'B1', 1, 'Ali', 202, 302, 'Comedy Night', 402, 'City Theatre', 300),
(103, 'B2', 1, 'Ali', 202, 302, 'Comedy Night', 402, 'City Theatre', 350);

-- Normalized BCNF tables

CREATE TEMP TABLE b2_customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

CREATE TEMP TABLE b2_event (
    event_id INT PRIMARY KEY,
    event_title VARCHAR(100) NOT NULL
);

CREATE TEMP TABLE b2_venue (
    venue_id INT PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL
);

CREATE TEMP TABLE b2_performance (
    performance_id INT PRIMARY KEY,
    event_id INT NOT NULL REFERENCES b2_event(event_id),
    venue_id INT NOT NULL REFERENCES b2_venue(venue_id)
);

CREATE TEMP TABLE b2_booking (
    booking_id INT PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES b2_customer(customer_id),
    performance_id INT NOT NULL REFERENCES b2_performance(performance_id)
);

CREATE TEMP TABLE b2_ticket (
    booking_id INT REFERENCES b2_booking(booking_id),
    seat_number VARCHAR(10),
    price NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (booking_id, seat_number)
);

-- Populate normalized tables from the legacy export

INSERT INTO b2_customer
SELECT DISTINCT customer_id, customer_name
FROM b2_legacy;

INSERT INTO b2_event
SELECT DISTINCT event_id, event_title
FROM b2_legacy;

INSERT INTO b2_venue
SELECT DISTINCT venue_id, venue_name
FROM b2_legacy;

INSERT INTO b2_performance
SELECT DISTINCT performance_id, event_id, venue_id
FROM b2_legacy;

INSERT INTO b2_booking
SELECT DISTINCT booking_id, customer_id, performance_id
FROM b2_legacy;

INSERT INTO b2_ticket
SELECT booking_id, seat_number, price
FROM b2_legacy;

-- Reconstruct the original relation

CREATE TEMP VIEW b2_reconstructed AS
SELECT
    b.booking_id,
    t.seat_number,
    c.customer_id,
    c.customer_name,
    p.performance_id,
    e.event_id,
    e.event_title,
    v.venue_id,
    v.venue_name,
    t.price
FROM b2_ticket t
JOIN b2_booking b ON t.booking_id = b.booking_id
JOIN b2_customer c ON b.customer_id = c.customer_id
JOIN b2_performance p ON b.performance_id = p.performance_id
JOIN b2_event e ON p.event_id = e.event_id
JOIN b2_venue v ON p.venue_id = v.venue_id;

-- Verification 1: Original minus reconstructed
-- Expected: 0 rows

SELECT * FROM b2_legacy
EXCEPT ALL
SELECT * FROM b2_reconstructed;

-- Verification 2: Reconstructed minus original
-- Expected: 0 rows

SELECT * FROM b2_reconstructed
EXCEPT ALL
SELECT * FROM b2_legacy;

-- Verification summary

SELECT
    (SELECT COUNT(*) FROM b2_legacy) AS original_rows,
    (SELECT COUNT(*) FROM b2_reconstructed) AS reconstructed_rows,
    CASE
        WHEN NOT EXISTS (
            SELECT * FROM b2_legacy
            EXCEPT ALL
            SELECT * FROM b2_reconstructed
        )
        AND NOT EXISTS (
            SELECT * FROM b2_reconstructed
            EXCEPT ALL
            SELECT * FROM b2_legacy
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END AS verification_result;

ROLLBACK;
