-- Seed data for User table
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES 
  ('uuid-guest-1', 'Alice', 'Johnson', 'alice@example.com', 'hash1', '1234567890', 'guest', CURRENT_TIMESTAMP),
  ('uuid-host-1', 'Bob', 'Smith', 'bob@example.com', 'hash2', '0987654321', 'host', CURRENT_TIMESTAMP),
  ('uuid-admin-1', 'Admin', 'User', 'admin@example.com', 'adminhash', NULL, 'admin', CURRENT_TIMESTAMP);

-- Seed data for Property table
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
VALUES 
  ('prop-1', 'uuid-host-1', 'Cozy Cottage', 'A cozy place in the woods.', 'Denver, CO', 120.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('prop-2', 'uuid-host-1', 'Modern Apartment', 'An urban apartment with Wi-Fi.', 'New York, NY', 180.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Seed data for Booking table
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
VALUES 
  ('book-1', 'prop-1', 'uuid-guest-1', '2025-06-01', '2025-06-05', 480.00, 'confirmed', CURRENT_TIMESTAMP),
  ('book-2', 'prop-2', 'uuid-guest-1', '2025-07-10', '2025-07-12', 360.00, 'pending', CURRENT_TIMESTAMP);

-- Seed data for Payment table
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method)
VALUES 
  ('pay-1', 'book-1', 480.00, CURRENT_TIMESTAMP, 'credit_card'),
  ('pay-2', 'book-2', 360.00, CURRENT_TIMESTAMP, 'paypal');

-- Seed data for Review table
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at)
VALUES 
  ('rev-1', 'prop-1', 'uuid-guest-1', 5, 'Amazing stay, loved the nature!', CURRENT_TIMESTAMP),
  ('rev-2', 'prop-2', 'uuid-guest-1', 4, 'Nice apartment, a bit noisy.', CURRENT_TIMESTAMP);

-- Seed data for Message table
INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at)
VALUES 
  ('msg-1', 'uuid-guest-1', 'uuid-host-1', 'Hi, is the property available in July?', CURRENT_TIMESTAMP),
  ('msg-2', 'uuid-host-1', 'uuid-guest-1', 'Yes, it is available!', CURRENT_TIMESTAMP);
