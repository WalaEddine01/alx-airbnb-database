-- monitoring.sql
-- Enable detailed query statistics
SET track_io_timing = on;
SET statement_timeout = '5min';

-- Create monitoring table for tracking performance
CREATE TABLE IF NOT EXISTS query_performance (
    id SERIAL PRIMARY KEY,
    query_hash TEXT,
    query_text TEXT,
    execution_time FLOAT,
    rows_returned BIGINT,
    shared_blks_hit BIGINT,
    shared_blks_read BIGINT,
    shared_blks_written BIGINT,
    local_blks_hit BIGINT,
    local_blks_read BIGINT,
    local_blks_written BIGINT,
    temp_blks_read BIGINT,
    temp_blks_written BIGINT,
    blk_read_time FLOAT,
    blk_write_time FLOAT,
    check_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create function to monitor query performance
CREATE OR REPLACE FUNCTION monitor_query_performance(
    p_query text
) RETURNS VOID AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_query_hash TEXT;
BEGIN
    -- Record start time
    v_start_time := CURRENT_TIMESTAMP;
    
    -- Execute the query
    EXECUTE p_query;
    
    -- Record end time and calculate metrics
    v_end_time := CURRENT_TIMESTAMP;
    v_query_hash := md5(p_query);
    
    -- Insert performance metrics
    INSERT INTO query_performance (
        query_hash,
        query_text,
        execution_time,
        rows_returned,
        shared_blks_hit,
        shared_blks_read,
        shared_blks_written,
        local_blks_hit,
        local_blks_read,
        local_blks_written,
        temp_blks_read,
        temp_blks_written,
        blk_read_time,
        blk_write_time
    ) VALUES (
        v_query_hash,
        p_query,
        EXTRACT(EPOCH FROM (v_end_time - v_start_time)),
        pg_last_query_rows(),
        pg_stat_get_blocks_fetched(),
        pg_stat_get_blocks_hit(),
        pg_stat_get_blocks_read(),
        pg_stat_get_local_blocks_fetched(),
        pg_stat_get_local_blocks_hit(),
        pg_stat_get_local_blocks_read(),
        pg_stat_get_temp_blocks_read(),
        pg_stat_get_temp_blocks_written(),
        pg_stat_get_blk_read_time(),
        pg_stat_get_blk_write_time()
    );
END;
$$ LANGUAGE plpgsql;

-- Monitor booking queries
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM Booking 
WHERE start_date >= '2025-01-01' 
  AND start_date < '2025-02-01';

-- Monitor user queries
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM User 
WHERE email LIKE '%@example.com';

-- Monitor property queries
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM Property 
WHERE price BETWEEN 100 AND 500 
  AND status = 'active';


-- Create composite index for booking queries
CREATE INDEX idx_booking_date_status ON Booking(start_date, status);

-- Create covering index for user queries
CREATE INDEX idx_user_email_phone ON User(email, phone);

-- Create composite index for property queries
CREATE INDEX idx_property_price_status ON Property(price, status);

-- Add partitioning for large tables
ALTER TABLE Booking SET (parallel_workers = 4);
ALTER TABLE Property SET (parallel_workers = 4);

-- Optimize foreign key relationships
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Create monitoring schedule
CREATE EXTENSION IF NOT EXISTS pg_cron;
