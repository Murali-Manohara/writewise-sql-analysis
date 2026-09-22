-- =========================================================
-- WRITEWISE SQL PROJECT
-- FILE: 02_basic_sql_analysis.sql
-- PURPOSE: Basic SQL Analysis
-- =========================================================

USE writewise_db;

select * from plans;
select * from users;
select * from subscriptions;
select * from usage_logs;


-- 1. Row counts
SELECT COUNT(*) FROM users;      		-- 15 rows
SELECT COUNT(*) FROM plans;				-- 4 rows
SELECT COUNT(*) FROM subscriptions;     -- 15 rows
SELECT COUNT(*) FROM usage_logs; 		-- 30 rows


-- 2. Number of users by customer segment

SELECT
    customer_segment,
    COUNT(*) AS user_count
FROM users
GROUP BY customer_segment
ORDER BY user_count DESC;

-- Inference:
-- The sample dataset contains an equal number of users
-- across the three customer segments.


-- 3. Monthly user signups

SELECT
    MONTH(signup_date) AS signup_month,
    COUNT(*) AS new_users
FROM users
GROUP BY MONTH(signup_date)
ORDER BY signup_month;

-- Inference:
-- This shows how user acquisition changed across the months
-- represented in the dataset.

-- 4. Total documents created
SELECT
    SUM(documents_created) AS total_documents_created
FROM usage_logs;

-- Inference:
-- Users created a total of 347 documents in the sample dataset.

-- 5. Average documents created per usage record
SELECT
    ROUND(AVG(documents_created), 2) AS avg_documents_per_activity
FROM usage_logs;

-- Inference:
-- Each recorded usage event generated approximately
-- 11.57 documents on average.


-- 06. Minimum and maximum documents created in an activity record

SELECT
    MIN(documents_created) AS minimum_documents,
    MAX(documents_created) AS maximum_documents
FROM usage_logs;

-- Inference:
-- The observed usage ranges from 0 to 30 documents
-- per recorded activity.

-- 07. Total documents created by each user

SELECT
    user_id,
    SUM(documents_created) AS total_documents
FROM usage_logs
GROUP BY user_id
ORDER BY total_documents DESC;

-- Inference:
-- Document creation varies considerably across users,
-- indicating different levels of observed engagement.

-- 08. Users with more than 20 documents

SELECT
    user_id,
    SUM(documents_created) AS total_documents
FROM usage_logs
GROUP BY user_id
HAVING SUM(documents_created) > 20
ORDER BY total_documents DESC;

-- Inference:
-- These users represent the higher-engagement group
-- based on total documents created.

-- 09. Subscription status distribution

SELECT
    CASE
        WHEN end_date IS NULL THEN 'Active'
        ELSE 'Ended'
    END AS subscription_status,
    COUNT(*) AS subscription_count
FROM subscriptions
GROUP BY
    CASE
        WHEN end_date IS NULL THEN 'Active'
        ELSE 'Ended'
    END;

-- Inference:
-- The sample contains 12 active subscriptions and 3 ended subscriptions.

-- 10. Active subscriptions

SELECT
    subscription_id,
    user_id,
    plan_id,
    start_date
FROM subscriptions
WHERE end_date IS NULL
ORDER BY start_date;

-- Inference:
-- These subscriptions have no recorded end date
-- and are treated as active in our simplified dataset.

-- 11. Ended subscriptions

SELECT
    subscription_id,
    user_id,
    plan_id,
    start_date,
    end_date
FROM subscriptions
WHERE end_date IS NOT NULL
ORDER BY end_date;

-- Inference:
-- Three subscriptions in the sample have recorded end dates.

-- 12. Average documents created by month

SELECT
    MONTH(activity_date) AS activity_month,
    ROUND(AVG(documents_created), 2) AS avg_documents
FROM usage_logs
GROUP BY MONTH(activity_date)
ORDER BY activity_month;

-- Inference:
-- Average usage varies across months, indicating that
-- engagement levels are not constant over time.

-- 13. Total documents created by month

SELECT
    MONTH(activity_date) AS activity_month,
    SUM(documents_created) AS total_documents
FROM usage_logs
GROUP BY MONTH(activity_date)
ORDER BY activity_month;

-- Inference:
-- This shows the monthly volume of content creation
-- and helps identify changes in overall platform activity.

-- 14. Usage records with zero document creation

SELECT
    log_id,
    user_id,
    activity_date
FROM usage_logs
WHERE documents_created = 0;

-- Inference:
-- There is at least one recorded activity period
-- with zero documents created.

-- 15. High-activity usage records

SELECT
    log_id,
    user_id,
    activity_date,
    documents_created
FROM usage_logs
WHERE documents_created >= 20
ORDER BY documents_created DESC;

-- Inference:
-- These records represent periods of relatively high
-- observed platform activity.