-- ============================================
-- WRITEWISE SQL PROJECT
-- PART 3: DATABASE AND TABLE CREATION
-- ============================================

-- 1. Create database
CREATE DATABASE IF NOT EXISTS writewise_db;

-- 2. Select database
USE writewise_db;

-- 3. Remove old project tables if they exist
DROP TABLE IF EXISTS usage_logs;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS plans;


-- 4. Create plans table
CREATE TABLE plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(30) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    plan_type VARCHAR(20) NOT NULL
);


-- 5. Create users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    signup_date DATE NOT NULL,
    customer_segment VARCHAR(30) NOT NULL
);


-- 6. Create subscriptions table
CREATE TABLE subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,

    CONSTRAINT fk_subscription_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    CONSTRAINT fk_subscription_plan
        FOREIGN KEY (plan_id)
        REFERENCES plans(plan_id)
);


-- 7. Create usage_logs table
CREATE TABLE usage_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    activity_date DATE NOT NULL,
    documents_created INT NOT NULL DEFAULT 0,

    CONSTRAINT fk_usage_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);


-- 8. Verify tables
SHOW TABLES;



-- ============================================
-- WRITEWISE SQL PROJECT
-- PART 4: INSERTING DUMMY DATA
-- ============================================

USE writewise_db;


-- ============================================
-- 1. INSERT PLANS
-- ============================================

INSERT INTO plans
    (plan_id, plan_name, price, plan_type)
VALUES
    (1, 'Free', 0.00, 'Free'),
    (2, 'Starter', 9.99, 'Paid'),
    (3, 'Pro', 19.99, 'Paid'),
    (4, 'Business', 49.99, 'Paid');


-- ============================================
-- 2. INSERT USERS
-- ============================================

INSERT INTO users
    (user_id, name, signup_date, customer_segment)
VALUES
    (1, 'Arjun',   '2026-01-05', 'Individual'),
    (2, 'Priya',   '2026-01-08', 'Small Business'),
    (3, 'Rahul',   '2026-01-15', 'Enterprise'),
    (4, 'Sneha',   '2026-01-22', 'Individual'),
    (5, 'Vikram',  '2026-02-03', 'Small Business'),
    (6, 'Ananya',  '2026-02-10', 'Enterprise'),
    (7, 'Kiran',   '2026-02-18', 'Individual'),
    (8, 'Neha',    '2026-03-02', 'Small Business'),
    (9, 'Rohit',   '2026-03-08', 'Enterprise'),
    (10, 'Divya',  '2026-03-15', 'Individual'),
    (11, 'Aditya', '2026-03-20', 'Small Business'),
    (12, 'Meera',  '2026-04-01', 'Enterprise'),
    (13, 'Suresh', '2026-04-05', 'Individual'),
    (14, 'Kavya',  '2026-04-10', 'Small Business'),
    (15, 'Nikhil', '2026-04-18', 'Enterprise');


-- ============================================
-- 3. INSERT SUBSCRIPTIONS
-- ============================================

INSERT INTO subscriptions
    (subscription_id, user_id, plan_id, start_date, end_date)
VALUES
    (1,  1,  1, '2026-01-05', NULL),
    (2,  2,  2, '2026-01-08', NULL),
    (3,  3,  3, '2026-01-15', NULL),
    (4,  4,  1, '2026-01-22', '2026-02-15'),
    (5,  5,  3, '2026-02-03', NULL),
    (6,  6,  4, '2026-02-10', NULL),
    (7,  7,  2, '2026-02-18', '2026-04-20'),
    (8,  8,  1, '2026-03-02', NULL),
    (9,  9,  3, '2026-03-08', NULL),
    (10, 10, 1, '2026-03-15', '2026-04-05'),
    (11, 11, 2, '2026-03-20', NULL),
    (12, 12, 4, '2026-04-01', NULL),
    (13, 13, 1, '2026-04-05', NULL),
    (14, 14, 3, '2026-04-10', NULL),
    (15, 15, 3, '2026-04-18', NULL);


-- ============================================
-- 4. INSERT USAGE LOGS
-- ============================================

INSERT INTO usage_logs
    (log_id, user_id, activity_date, documents_created)
VALUES
    (1,  1, '2026-01-06', 2),
    (2,  1, '2026-02-05', 3),
    (3,  1, '2026-03-05', 4),

    (4,  2, '2026-01-10', 5),
    (5,  2, '2026-02-10', 7),
    (6,  2, '2026-03-10', 8),

    (7,  3, '2026-01-20', 12),
    (8,  3, '2026-02-20', 18),
    (9,  3, '2026-03-20', 25),

    (10, 4, '2026-01-25', 1),
    (11, 4, '2026-02-10', 0),

    (12, 5, '2026-02-05', 8),
    (13, 5, '2026-03-05', 15),
    (14, 5, '2026-04-05', 20),

    (15, 6, '2026-02-15', 15),
    (16, 6, '2026-03-15', 24),
    (17, 6, '2026-04-15', 30),

    (18, 7, '2026-02-20', 3),
    (19, 7, '2026-03-20', 4),

    (20, 9, '2026-03-10', 10),
    (21, 9, '2026-04-10', 16),

    (22, 11, '2026-03-25', 6),
    (23, 11, '2026-04-25', 9),

    (24, 12, '2026-04-05', 20),
    (25, 12, '2026-05-05', 28),

    (26, 14, '2026-04-15', 12),
    (27, 14, '2026-05-15', 18),

    (28, 15, '2026-04-20', 9),
    (29, 15, '2026-05-20', 14),

    (30, 8, '2026-03-10', 1);

-- ============================================
-- 5. Fetching the Table 
-- ============================================
select * from plans;
select * from users;
select * from subscriptions;
select * from usage_logs;

