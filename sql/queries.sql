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

-- E. Transaction value by county

SELECT
    u.county,
    COUNT(t.txn_id) AS total_transactions,
    ROUND(SUM(t.amount),2) AS total_amount
FROM users u
JOIN transactions t
    ON u.user_id = t.user_id
GROUP BY u.county
ORDER BY total_amount DESC;

-- F. Monthly transaction trend

SELECT
    substr(txn_date,1,7) AS month,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount),2) AS total_amount
FROM transactions
GROUP BY month
ORDER BY month;

-- G. Monthly revenue growth

WITH monthly_revenue AS (

    SELECT
        substr(txn_date,1,7) AS month,
        SUM(amount) AS revenue
    FROM transactions
    GROUP BY month

)

SELECT
    month,
    revenue,

    LAG(revenue) OVER(
        ORDER BY month
    ) AS previous_revenue,

    CASE

        WHEN LAG(revenue) OVER(
            ORDER BY month
        ) IS NULL

        THEN NULL

        ELSE ROUND(
            (
                revenue -
                LAG(revenue) OVER(
                    ORDER BY month
                )
            ) * 100.0 /

            LAG(revenue) OVER(
                ORDER BY month
            )

        ,2)

    END AS growth_percent

FROM monthly_revenue;

-- H. Monthly active-user retention proxy

WITH monthly_users AS (

    SELECT
        substr(txn_date,1,7) AS month,
        COUNT(DISTINCT user_id) AS active_users
    FROM transactions
    GROUP BY month

)

SELECT
    month,
    active_users,

    LAG(active_users)
    OVER(
        ORDER BY month
    ) AS previous_active_users,

    CASE

        WHEN LAG(active_users)
        OVER(
            ORDER BY month
        ) IS NULL

        THEN NULL

        ELSE ROUND(
            active_users * 100.0 /

            LAG(active_users)
            OVER(
                ORDER BY month
            )

        ,2)

    END AS retention_percent

FROM monthly_users;
