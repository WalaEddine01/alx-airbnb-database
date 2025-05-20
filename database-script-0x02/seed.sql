-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Use a CTE to store generated UUIDs for reuse
WITH 
-- Insert users and capture their UUIDs
inserted_users AS (
    INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
    VALUES 
        (uuid_generate_v4(), 'Alice', 'Johnson', 'alice@example.com', 'hash1', '1234567890', 'guest', CURRENT_TIMESTAMP),
        (uuid_generate_v4(), 'Bob', 'Smith', 'bob@example.com', 'hash2', '0987654321', 'host', CURRENT_TIMESTAMP),
        (uuid_generate_v4(), 'Admin', 'User', 'admin@example.com', 'adminhash', NULL, 'admin', CURRENT_TIMESTAMP)
    RETURNING user_id, role
),

-- Extract host and guest IDs
host_guest_ids AS (
    SELECT
        MAX(CASE WHEN role = 'host' THEN user_id END) AS host_id,
        MAX(CASE WHEN role = 'guest' THEN user_id END) AS guest_id
    FROM inserted_users
),

-- Insert properties and return their IDs
inserted_properties AS (
    INSERT INTO properties (property_id, host_id, name, description, location, price_per_night, created_at, updated_at)
    SELECT
        uuid_generate_v4(), h.host_id, name, description, location, price, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    FROM 
        (SELECT 'Cozy Cottage' AS name, 'A cozy place in the woods.' AS description, 'Denver, CO' AS location, 120.00 AS price
         UNION ALL
         SELECT 'Modern Apartment', 'An urban apartment with Wi-Fi.', 'New York, NY', 180.00) AS p,
        host_guest_ids h
    RETURNING property_id
),

-- Insert bookings
inserted_bookings AS (
    INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
    SELECT 
        uuid_generate_v4(), prop.property_id, ids.guest_id, b.start_date, b.end_date, b.total_price, b.status, CURRENT_TIMESTAMP
    FROM 
        (SELECT ROW_NUMBER() OVER () AS rn, * FROM inserted_properties) prop
    JOIN host_guest_ids ids ON true
    JOIN (
        SELECT 1 AS rn, '2025-06-01'::DATE AS start_date, '2025-06-05'::DATE AS end_date, 480.00 AS total_price, 'confirmed' AS status
        UNION ALL
        SELECT 2, '2025-07-10', '2025-07-12', 360.00, 'pending'
    ) b ON prop.rn = b.rn
    RETURNING booking_id, property_id, user_id
)

-- Insert payments
INSERT INTO payments (payment_id, booking_id, amount, payment_date, payment_method)
SELECT 
    uuid_generate_v4(), booking_id, 
    CASE WHEN status = 'confirmed' THEN 480.00 ELSE 360.00 END,
    CURRENT_TIMESTAMP,
    CASE WHEN status = 'confirmed' THEN 'credit_card' ELSE 'paypal' END
FROM inserted_bookings;

-- Insert reviews
INSERT INTO reviews (review_id, property_id, user_id, rating, comment, created_at)
SELECT 
    uuid_generate_v4(), property_id, user_id,
    rating, comment, CURRENT_TIMESTAMP
FROM (
    SELECT 5 AS rating, 'Amazing stay, loved the nature!' AS comment
    UNION ALL
    SELECT 4, 'Nice apartment, a bit noisy.'
) r
JOIN (
    SELECT ROW_NUMBER() OVER () AS rn, * FROM inserted_properties
) prop ON prop.rn = r.rating - 3
JOIN host_guest_ids ids ON true;

-- Insert messages
INSERT INTO messages (message_id, sender_id, recipient_id, message_body, sent_at)
SELECT uuid_generate_v4(), g.guest_id, g.host_id, 'Hi, is the property available in July?', CURRENT_TIMESTAMP
FROM host_guest_ids g
UNION ALL
SELECT uuid_generate_v4(), g.host_id, g.guest_id, 'Yes, it is available!', CURRENT_TIMESTAMP
FROM host_guest_ids g;
