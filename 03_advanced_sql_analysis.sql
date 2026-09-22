-- =========================================================
-- WRITEWISE SQL PROJECT
-- FILE: 03_advanced_sql_analysis.sql
-- PURPOSE: Advanced SQL Analysis
-- =========================================================

USE writewise_db;

-- =========================================================
-- 1. USER-LEVEL ENGAGEMENT
-- How engaged is each WriteWise user, and which customer segment do they belong to?
-- =========================================================

SELECT
    u.user_id,
    u.name,
    u.customer_segment,
    COALESCE(SUM(ul.documents_created), 0) AS total_documents
FROM users u
LEFT JOIN usage_logs ul
    ON u.user_id = ul.user_id
GROUP BY
    u.user_id,
    u.name,
    u.customer_segment
ORDER BY total_documents DESC;

-- Inference:
-- Engagement varies considerably across users.
-- Some users have high document creation, while some
-- have very low or no recorded activity.

-- =========================================================
-- 2. ENGAGEMENT BY CUSTOMER SEGMENT
-- Which customer segments show stronger observed engagement?
-- =========================================================

SELECT
    u.customer_segment,
    COUNT(DISTINCT u.user_id) AS total_users,
    SUM(COALESCE(ul.documents_created, 0)) AS total_documents,
    ROUND(
        SUM(COALESCE(ul.documents_created, 0))
        / COUNT(DISTINCT u.user_id),
        2
    ) AS avg_documents_per_user
FROM users u
LEFT JOIN usage_logs ul
    ON u.user_id = ul.user_id
GROUP BY u.customer_segment
ORDER BY avg_documents_per_user DESC;

-- Inference:
-- Engagement differs across customer segments.
-- Enterprise users show the highest observed average
-- document creation in this sample, followed by Small
-- Business and Individual users.

-- =========================================================
-- 3. ENGAGEMENT BY SUBSCRIPTION PLAN
-- Does observed user engagement differ across subscription plans?
-- =========================================================

SELECT
    p.plan_name,
    p.plan_type,
    COUNT(DISTINCT s.user_id) AS total_users,
    SUM(COALESCE(ul.documents_created, 0)) AS total_documents,
    ROUND(
        SUM(COALESCE(ul.documents_created, 0))
        / COUNT(DISTINCT s.user_id),
        2
    ) AS avg_documents_per_user
FROM subscriptions s
JOIN plans p
    ON s.plan_id = p.plan_id
LEFT JOIN usage_logs ul
    ON s.user_id = ul.user_id
GROUP BY
    p.plan_id,
    p.plan_name,
    p.plan_type
ORDER BY avg_documents_per_user DESC;

-- Inference:
-- Observed engagement differs across subscription plans.
-- Higher-tier plans have higher average document creation
-- in this sample dataset.

-- =========================================================
-- 4. USERS WITH NO RECORDED ACTIVITY
-- Which users have no recorded usage activity?
-- =========================================================

SELECT
    u.user_id,
    u.name,
    u.customer_segment
FROM users u
LEFT JOIN usage_logs ul
    ON u.user_id = ul.user_id
WHERE ul.user_id IS NULL;

-- Inference:
-- These users have no recorded usage activity in the dataset
-- and may require further investigation.

-- =========================================================
-- 5. USER ENGAGEMENT CLASSIFICATION
-- How many users are highly, moderately, or weakly engaged?
-- =========================================================

WITH user_engagement AS (
    SELECT
        u.user_id,
        u.name,
        COALESCE(SUM(ul.documents_created), 0) AS total_documents
    FROM users u
    LEFT JOIN usage_logs ul
        ON u.user_id = ul.user_id
    GROUP BY
        u.user_id,
        u.name
)

SELECT
    CASE
        WHEN total_documents = 0 THEN 'Inactive'
        WHEN total_documents <= 10 THEN 'Low'
        WHEN total_documents <= 30 THEN 'Moderate'
        ELSE 'High'
    END AS engagement_level,
    COUNT(*) AS user_count
FROM user_engagement
GROUP BY
    CASE
        WHEN total_documents = 0 THEN 'Inactive'
        WHEN total_documents <= 10 THEN 'Low'
        WHEN total_documents <= 30 THEN 'Moderate'
        ELSE 'High'
    END
ORDER BY user_count DESC;

-- Inference:
-- Users can be grouped into different engagement levels
-- based on their total recorded document creation.

-- =========================================================
-- 6. RANK USERS BY ENGAGEMENT
-- Who are the highest-engagement users based on total document creation?
-- =========================================================

WITH user_engagement AS (
    SELECT
        u.user_id,
        u.name,
        u.customer_segment,
        COALESCE(SUM(ul.documents_created), 0) AS total_documents
    FROM users u
    LEFT JOIN usage_logs ul
        ON u.user_id = ul.user_id
    GROUP BY
        u.user_id,
        u.name,
        u.customer_segment
)

SELECT
    user_id,
    name,
    customer_segment,
    total_documents,
    RANK() OVER (
        ORDER BY total_documents DESC
    ) AS engagement_rank
FROM user_engagement
ORDER BY engagement_rank;

-- Inference:
-- The ranking identifies users with the highest observed
-- levels of document creation.

-- =========================================================
-- 7. MONTH-OVER-MONTH DOCUMENT ACTIVITY
-- How is total document activity changing from month to month?
-- =========================================================

WITH monthly_activity AS (
    SELECT
        MONTH(activity_date) AS activity_month,
        SUM(documents_created) AS total_documents
    FROM usage_logs
    GROUP BY MONTH(activity_date)
)

SELECT
    activity_month,
    total_documents,
    LAG(total_documents) OVER (
        ORDER BY activity_month
    ) AS previous_month_documents,
    total_documents
        - LAG(total_documents) OVER (
            ORDER BY activity_month
        ) AS change_from_previous_month
FROM monthly_activity
ORDER BY activity_month;

-- Inference:
-- Monthly document activity increased from January through April,
-- then declined in May in the sample dataset.

-- =========================================================
-- 8. FREE VS PAID USER ENGAGEMENT
-- Additional Business Question
-- Is observed engagement substantially different between Free and Paid users?
-- =========================================================

SELECT
    p.plan_type,
    COUNT(DISTINCT s.user_id) AS total_users,
    SUM(COALESCE(ul.documents_created, 0)) AS total_documents,
    ROUND(
        SUM(COALESCE(ul.documents_created, 0))
        / COUNT(DISTINCT s.user_id),
        2
    ) AS avg_documents_per_user
FROM subscriptions s
JOIN plans p
    ON s.plan_id = p.plan_id
LEFT JOIN usage_logs ul
    ON s.user_id = ul.user_id
GROUP BY p.plan_type
ORDER BY avg_documents_per_user DESC;

-- Inference:
-- Paid users show substantially higher observed average
-- document creation than Free users in this sample.
-- This difference should be investigated further to understand
-- whether plan type, customer segment, or other factors explain it.