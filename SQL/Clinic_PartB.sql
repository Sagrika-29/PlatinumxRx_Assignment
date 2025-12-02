-- -------------------------------
-- CLINIC MANAGEMENT – PART B
-- -------------------------------

USE platinumrx;

---------------------------------
-- 1. Creating tables
---------------------------------

CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100)
);

CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(200),
    phone_number VARCHAR(20),
    mail_id VARCHAR(200)
);

CREATE TABLE clinic_sales (
    sale_id VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    uid VARCHAR(50),
    datetime DATETIME,
    amount DECIMAL(10,2),
    sales_channel VARCHAR(100),
    FOREIGN KEY (cid) REFERENCES clinics(cid),
    FOREIGN KEY (uid) REFERENCES customer(uid)
);

CREATE TABLE expenses (
    exp_id VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    datetime DATETIME,
    amount DECIMAL(10,2),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

---------------------------------
-- 2. Sample Data
---------------------------------

INSERT INTO clinics VALUES
('C1','Wellness Clinic','Hyderabad','TS'),
('C2','Health Clinic','Mumbai','MH');

INSERT INTO customer VALUES
('U1','John Doe','973000xxxx','john@mail.com');

INSERT INTO clinic_sales VALUES
('S1','C1','U1','2021-10-10 10:00:00',1200,'Online'),
('S2','C1','U1','2021-10-15 11:00:00',1000,'Offline'),
('S3','C1','U1','2021-11-15 09:30:00',2000,'Online');

INSERT INTO expenses VALUES
('E1','C1','2021-10-10 10:00:00',500),
('E2','C1','2021-11-15 09:00:00',800);

---------------------------------
-- Q1. Revenue by sales channel
---------------------------------
SELECT sales_channel,
       SUM(amount) AS total_revenue
FROM clinic_sales
GROUP BY sales_channel;

---------------------------------
-- Q2. Customer-wise total visits
---------------------------------
SELECT cs.uid,
       cu.customer_name,
       COUNT(*) AS total_visits
FROM clinic_sales cs
JOIN customer cu ON cs.uid = cu.uid
GROUP BY cs.uid, cu.customer_name;

---------------------------------
-- Q3. Monthly Profit / Loss
---------------------------------
WITH rev AS (
    SELECT MONTH(datetime) AS month,
           SUM(amount) AS revenue
    FROM clinic_sales
    GROUP BY MONTH(datetime)
),
exp AS (
    SELECT MONTH(datetime) AS month,
           SUM(amount) AS expenses
    FROM expenses
    GROUP BY MONTH(datetime)
)
SELECT 
    COALESCE(r.month, e.month) AS month,
    COALESCE(revenue, 0) AS revenue,
    COALESCE(expenses, 0) AS expenses,
    (COALESCE(revenue, 0) - COALESCE(expenses, 0)) AS profit_or_loss
FROM rev r
FULL JOIN exp e
ON r.month = e.month
ORDER BY month;

---------------------------------
-- Q4. Most visited clinic
---------------------------------
SELECT c.cid,
       c.clinic_name,
       COUNT(*) AS total_visits
FROM clinic_sales cs
JOIN clinics c ON cs.cid = c.cid
GROUP BY c.cid, c.clinic_name
ORDER BY total_visits DESC
LIMIT 1;

---------------------------------
-- Q5. Top spending customer
---------------------------------
SELECT cs.uid,
       cu.customer_name,
       SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer cu ON cs.uid = cu.uid
GROUP BY cs.uid, cu.customer_name
ORDER BY total_spent DESC
LIMIT 1;
