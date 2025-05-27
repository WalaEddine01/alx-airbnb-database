-- Inner Join
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM users u
INNER JOIN bookings b ON u.user_id = b.user_id
ORDER BY b.start_date DESC;

-- Left Join
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.price_per_night,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at
FROM properties p
LEFT JOIN reviews r ON p.property_id = r.property_id
ORDER BY p.name;

-- Full outer Join
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM users u
FULL OUTER JOIN bookings b ON u.user_id = b.user_id
ORDER BY COALESCE(u.user_id, b.user_id);