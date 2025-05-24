-- Create the partitioned Booking table
CREATE TABLE Booking (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    property_id INTEGER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    booking_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (property_id) REFERENCES Property(id)
) PARTITION BY RANGE (start_date);

-- Create monthly partitions for the next year
DO $$
DECLARE
    start_date DATE := '2025-01-01';
    end_date DATE := '2026-01-01';
BEGIN
    WHILE start_date < end_date LOOP
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS booking_%s PARTITION OF Booking
            FOR VALUES FROM (''%s'') TO (''%s'')
            TABLESPACE booking_tablespace',
            TO_CHAR(start_date, 'YYYY_MM'),
            start_date,
            start_date + INTERVAL '1 month'
        );
        start_date := start_date + INTERVAL '1 month';
    END LOOP;
END $$;

-- Test 1: Query bookings for a specific month
EXPLAIN ANALYZE
SELECT * FROM Booking 
WHERE start_date >= '2025-01-01' 
  AND start_date < '2025-02-01';

-- Test 2: Query bookings for a range of months
EXPLAIN ANALYZE
SELECT * FROM Booking 
WHERE start_date >= '2025-01-01' 
  AND start_date < '2025-04-01';

-- Test 3: Query with joins
EXPLAIN ANALYZE
SELECT b.*, u.email, p.property_type
FROM Booking b
JOIN User u ON b.user_id = u.id
JOIN Property p ON b.property_id = p.id
WHERE b.start_date >= '2025-01-01' 
  AND b.start_date < '2025-02-01';