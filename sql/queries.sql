-- Validation: Which transactions are dated before the user's signup date?
SELECT
    t.txn_id,
    t.user_id,
    u.signup_date,
    t.txn_date,
    t.product,
    t.amount
FROM transactions AS t
JOIN users AS u
    ON u.user_id = t.user_id
WHERE t.txn_date < u.signup_date
ORDER BY t.user_id, t.txn_date, t.txn_id;

-- A. How many users are registered on PesaPap?
SELECT
    COUNT(*) AS total_users
FROM users;

-- B. What is the total value of all recorded transactions?
SELECT
    ROUND(SUM(amount), 2) AS total_transaction_value
FROM transactions;

-- C. How many transactions and how much transaction value does each product generate?
SELECT
    product,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_amount
FROM transactions
GROUP BY product
ORDER BY total_amount DESC;

-- D. How many users came from each acquisition channel?
SELECT
    acquisition_channel,
    COUNT(*) AS total_users
FROM users
GROUP BY acquisition_channel
ORDER BY total_users DESC;

-- E. What are the transaction count and total transaction value for each county?
SELECT
    u.county,
    COUNT(t.txn_id) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS total_amount
FROM users AS u
JOIN transactions AS t
    ON u.user_id = t.user_id
GROUP BY u.county
ORDER BY total_amount DESC;

-- F. How do transaction counts and total transaction value change by month?
SELECT
    substr(txn_date, 1, 7) AS month,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount
FROM transactions
GROUP BY month
ORDER BY month;

-- G. What is the month-over-month percentage change in total transaction value?
WITH monthly_revenue AS (
    SELECT
        substr(txn_date, 1, 7) AS month,
        SUM(amount) AS transaction_value
    FROM transactions
    GROUP BY month
),
revenue_changes AS (
    SELECT
        month,
        transaction_value,
        LAG(transaction_value) OVER (ORDER BY month) AS previous_transaction_value
    FROM monthly_revenue
)
SELECT
    month,
    transaction_value,
    previous_transaction_value,
    CASE
        WHEN previous_transaction_value IS NULL OR previous_transaction_value = 0 THEN NULL
        ELSE ROUND(
            (transaction_value - previous_transaction_value) * 100.0
                / previous_transaction_value,
            2
        )
    END AS growth_percent
FROM revenue_changes
ORDER BY month;

-- H. What percentage of last month's active users returned to transact this month?
WITH user_months AS (
    SELECT DISTINCT
        substr(txn_date, 1, 7) AS month,
        user_id
    FROM transactions
),
user_activity AS (
    SELECT
        month,
        user_id,
        LAG(month) OVER (PARTITION BY user_id ORDER BY month) AS previous_active_month
    FROM user_months
),
monthly_retention AS (
    SELECT
        month,
        COUNT(*) AS active_users,
        SUM(
            CASE
                WHEN previous_active_month = strftime(
                    '%Y-%m',
                    date(month || '-01', '-1 month')
                ) THEN 1
                ELSE 0
            END
        ) AS returning_users
    FROM user_activity
    GROUP BY month
),
retention_with_previous AS (
    SELECT
        month,
        active_users,
        returning_users,
        LAG(active_users) OVER (ORDER BY month) AS previous_active_users
    FROM monthly_retention
)
SELECT
    month,
    active_users,
    previous_active_users,
    returning_users,
    CASE
        WHEN previous_active_users IS NULL OR previous_active_users = 0 THEN NULL
        ELSE ROUND(returning_users * 100.0 / previous_active_users, 2)
    END AS retention_percent
FROM retention_with_previous
ORDER BY month;
