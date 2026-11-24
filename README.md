# PesaPap Growth Analytics

## Project Summary

This project analyzes growth performance for PesaPap, a Kenyan digital-payments startup.

The analysis includes:

- Data validation
- SQL business analysis
- KPI scorecard
- RFM segmentation
- Cohort retention analysis
- Onboarding experiment evaluation
- Growth recommendations

The objective is to determine whether the new onboarding experience should be rolled out to all users.

---

# Dataset Tables

## users

| Column | Description |
|----------|----------|
| user_id | Unique user identifier |
| signup_date | User registration date |
| county | User county |
| acquisition_channel | Acquisition source |

Primary Key:

```text
user_id
```

---

## transactions

| Column | Description |
|----------|----------|
| txn_id | Transaction identifier |
| user_id | User identifier |
| txn_date | Transaction date |
| product | Product type |
| amount | Transaction amount |

Primary Key:

```text
txn_id
```

Foreign Key:

```text
user_id → users.user_id
```

---

## experiment

| Column | Description |
|----------|----------|
| user_id | User identifier |
| group | Experiment group |
| converted | Conversion indicator |

Primary Key:

```text
user_id
```

Foreign Key:

```text
user_id → users.user_id
```

---

# How To Run

## 1 Generate data

Run:

```bash
python generate_data.py
```

This creates:

```text
users.csv
transactions.csv
experiment.csv
```

## 2 Run notebook

Open:

```text
pesapap_analysis.ipynb
```

Run all cells from top to bottom.

## 3 Outputs

The notebook produces:

- SQL analysis
- KPI scorecard
- RFM segmentation
- Cohort retention analysis
- Experiment evaluation

---

# Headline Recommendation

The simplified onboarding experience (Group B) should be rolled out if the experiment demonstrates statistical significance and a positive confidence interval.

The growth team should continue monitoring user retention and transaction behavior after implementation.

