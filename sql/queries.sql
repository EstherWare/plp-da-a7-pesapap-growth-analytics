-- Validation: Users with transactions before signup date

SELECT
    u.user_id,
    u.signup_date,
    MIN(t.txn_date) AS first_transaction
FROM users u
JOIN transactions t
    ON u.user_id = t.user_id
GROUP BY u.user_id
HAVING first_transaction < u.signup_date;

-- A. Total number of users

SELECT
    COUNT(*) AS total_users
FROM users;

-- B. Total transaction value

SELECT
    ROUND(SUM(amount),2) AS total_transaction_value
FROM transactions;

-- C. Performance by product

SELECT
    product,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount),2) AS total_amount
FROM transactions
GROUP BY product
ORDER BY total_amount DESC;

-- D. Users by acquisition channel

SELECT
    acquisition_channel,
    COUNT(*) AS total_users
FROM users
GROUP BY acquisition_channel
ORDER BY total_users DESC;

