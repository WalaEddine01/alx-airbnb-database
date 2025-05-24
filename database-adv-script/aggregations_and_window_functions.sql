-- User Booking Counts with group by

SELECT 
    u.user_id,
    u.name,
    COUNT(b.booking_id) as total_bookings
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.name
ORDER BY 
    total_bookings DESC;

-- Property Rankings

WITH property_bookings AS (
    SELECT 
        p.property_id,
        p.title,
        COUNT(b.booking_id) as booking_count
    FROM 
        properties p
    LEFT JOIN 
        bookings b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, p.title
)
SELECT 
    property_id,
    title,
    booking_count,
    ROW_NUMBER() OVER (
        ORDER BY booking_count DESC
    ) as ranking
FROM 
    property_bookings
ORDER BY 
    ranking;
