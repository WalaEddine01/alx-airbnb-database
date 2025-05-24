-- User table indexes
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_user_phone ON User(phone);
CREATE INDEX idx_user_created_at ON User(created_at);

-- Property table indexes
CREATE INDEX idx_property_price_status ON Property(price, status);
CREATE INDEX idx_property_type_status ON Property(property_type, status);
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Booking table indexes
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);
CREATE INDEX idx_booking_status_date ON Booking(status, booking_date);

-- Example measurement queries
EXPLAIN ANALYZE
SELECT * FROM User 
WHERE email = 'example@email.com';

EXPLAIN ANALYZE
SELECT * FROM Property 
WHERE price BETWEEN 100 AND 500 
AND status = 'active';

EXPLAIN ANALYZE
SELECT * FROM Booking 
WHERE user_id = 123 
ORDER BY booking_date DESC;