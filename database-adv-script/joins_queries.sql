-- Inner Join
SELECT 
    b.booking_id,
    b.property_id,
    b.user_id,
    b.booking_date,
    u.user_id,
    u.name,
    u.email
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id;

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
    reviews r ON p.property_id = r.property_id;

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
