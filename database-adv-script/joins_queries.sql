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
    p.title,
    p.description,
    r.review_id,
    r.property_id,
    r.rating,
    r.comment
FROM 
    properties p
LEFT JOIN 
    reviews r ON p.property_id = r.property_id
    ORDER BY r.rating

-- Full outer Join
SELECT 
    u.user_id,
    u.name,
    u.email,
    b.booking_id,
    b.property_id,
    b.booking_date
FROM 
    users u
FULL OUTER JOIN 
    bookings b ON u.user_id = b.user_id;
