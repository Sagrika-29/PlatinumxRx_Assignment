-- HOTEL MANAGEMENT SQL (PART A)

-- 1. Create tables
CREATE TABLE users (
  user_id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(100),
  phone_number VARCHAR(20),
  billing_address VARCHAR(200)
);

CREATE TABLE bookings (
  booking_id VARCHAR(50) PRIMARY KEY,
  booking_date DATETIME,
  room_no VARCHAR(50),
  user_id VARCHAR(50),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE items (
  item_id VARCHAR(50) PRIMARY KEY,
  item_name VARCHAR(100),
  item_rate DECIMAL(10,2)
);

CREATE TABLE booking_commercials (
  id VARCHAR(50) PRIMARY KEY,
  booking_id VARCHAR(50),
  bill_date DATETIME,
  item_id VARCHAR(50),
  item_quantity INT,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
  FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- 2. Insert data
INSERT INTO users VALUES 
('U1','John Doe','987xxxxxxx','Hyderabad'),
('U2','Rick','999xxxxxxx','Bengaluru');

INSERT INTO bookings VALUES 
('B1','2021-10-05 15:00:00','R201','U1'),
('B2','2021-10-22 12:00:00','R202','U1'),
('B3','2021-11-05 10:15:00','R202','U2');

INSERT INTO items VALUES 
('I1','Tea',80.00),
('I2','Veg Biryani',180.00),
('I3','Max Veg',680.00);

INSERT INTO booking_commercials VALUES
('C1','B1','2021-10-05 16:00:00','I1',1),
('C2','B1','2021-10-05 16:20:00','I2',1),
('C3','B2','2021-10-22 12:05:00','I2',1),
('C4','B2','2021-10-22 12:05:00','I3',1),
('C5','B3','2021-11-05 10:20:00','I1',2);

-- 3. Questions & SQL answers

-- Q1: Latest booking of each user
SELECT b.user_id, MAX(b.booking_date) AS last_date
FROM bookings b
GROUP BY b.user_id;

-- Q2: Total bill per booking for 2021
SELECT bc.booking_id, SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
JOIN bookings b ON bc.booking_id = b.booking_id
WHERE YEAR(b.booking_date) = 2021
GROUP BY bc.booking_id;

-- Q3: For each month, 2nd highest spending user
WITH bill_values AS (
  SELECT 
    MONTH(b.bill_date) AS month,
    b.user_id,
    SUM(i.item_rate * b.item_quantity) AS bill_amount
  FROM booking_commercials b
  JOIN items i ON b.item_id = i.item_id
  JOIN bookings bk ON b.booking_id = bk.booking_id
  GROUP BY MONTH(b.bill_date), b.user_id
),
ranked AS (
  SELECT *,
    RANK() OVER (PARTITION BY month ORDER BY bill_amount DESC) AS rnk
  FROM bill_values
)
SELECT month, user_id, bill_amount
FROM ranked
WHERE rnk = 2
ORDER BY month, bill_amount DESC;

-- Q4: Most sold item each month (best seller)
WITH monthly_items AS (
  SELECT 
    MONTH(b.bill_date) AS month,
    i.item_name,
    SUM(b.item_quantity) AS total_qty
  FROM booking_commercials b
  JOIN items i ON b.item_id = i.item_id
  GROUP BY MONTH(b.bill_date), i.item_name
),
ranked_items AS (
  SELECT *,
    RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rnk
  FROM monthly_items
)
SELECT month, item_name, total_qty
FROM ranked_items
WHERE rnk = 1;

-- Q5: Customer visit count (no. of bookings)
SELECT u.user_id, u.name AS customer_name, COUNT(b.booking_id) AS total_visits
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.name
ORDER BY total_visits DESC;

