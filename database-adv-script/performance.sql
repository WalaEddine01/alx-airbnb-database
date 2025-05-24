-- Initial query to retrieve all booking details
SELECT 
    b.*,
    u.email,
    u.phone,
    p.property_type,
    p.price,
    p.status as property_status,
    pm.payment_method,
    pm.amount,
    pm.transaction_date
FROM 
    Booking b
    INNER JOIN User u ON b.user_id = u.id
    INNER JOIN Property p ON b.property_id = p.id
    LEFT JOIN Payment pm ON b.id = pm.booking_id
ORDER BY 
    b.booking_date DESC;

--
EXPLAIN ANALYZE
SELECT 
    b.*,
    u.email,
    u.phone,
    p.property_type,
    p.price,
    p.status as property_status,
    pm.payment_method,
    pm.amount,
    pm.transaction_date
FROM 
    Booking b
    INNER JOIN User u ON b.user_id = u.id
    INNER JOIN Property p ON b.property_id = p.id
    LEFT JOIN Payment pm ON b.id = pm.booking_id
ORDER BY 
    b.booking_date DESC;

-- Optimized query with better performance
WITH RecentBookings AS (
    SELECT 
        b.id,
        b.user_id,
        b.property_id,
        b.booking_date,
        b.status,
        ROW_NUMBER() OVER (
            PARTITION BY b.user_id 
            ORDER BY b.booking_date DESC
        ) as row_num
    FROM Booking b
    WHERE b.status IN ('confirmed', 'completed')
)
SELECT 
    rb.id,
    rb.booking_date,
    rb.status,
    u.email,
    u.phone,
    p.property_type,
    p.price,
    p.status as property_status,
    pm.payment_method,
    pm.amount,
    pm.transaction_date
FROM RecentBookings rb
INNER JOIN User u ON rb.user_id = u.id
INNER JOIN Property p ON rb.property_id = p.id
LEFT JOIN Payment pm ON rb.id = pm.booking_id
WHERE rb.row_num <= 10
ORDER BY rb.booking_date DESC;

-- Required indexes for optimal performance
CREATE INDEX idx_booking_status_date ON Booking(status, booking_date);
CREATE INDEX idx_user_email_phone ON User(email, phone);
CREATE INDEX idx_property_type_price ON Property(property_type, price);
CREATE INDEX idx_payment_booking ON Payment(booking_id);
