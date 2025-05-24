-- Non-Correlated
SELECT 
    p.property_id,
    p.title,
    p.description,
    p.avg_rating
FROM 
    properties p
WHERE 
    p.property_id IN (
        SELECT 
            property_id
        FROM 
            reviews
        GROUP BY 
            property_id
        HAVING 
            AVG(rating) > 4.0
    );

-- Correlated Subquery
SELECT 
    u.user_id,
    u.name,
    u.email,
    (
        SELECT 
            COUNT(*) 
        FROM 
            bookings b
        WHERE 
            b.user_id = u.user_id
    ) as booking_count
FROM 
    users u
WHERE 
    (
        SELECT 
            COUNT(*) 
        FROM 
            bookings b
        WHERE 
            b.user_id = u.user_id
    ) > 3;

