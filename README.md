# PesaPap Growth Analytics

## Project summary

This project uses a reproducible synthetic dataset to assess PesaPap's growth, transaction activity, user cohorts, RFM segments, and simplified-onboarding experiment. It combines SQLite queries with a Python KPI scorecard and experiment analysis.

## Data tables

| Table | Description | Primary key | Foreign key |
|---|---|---|---|
| `users` | User signup date, county, and acquisition channel | `user_id` | — |
| `transactions` | Transaction date, product, and amount | `txn_id` | `user_id` → `users.user_id` |
| `experiment` | Onboarding assignment and conversion outcome | `user_id` | `user_id` → `users.user_id` |

## How to run

From the repository root, install the analysis libraries and generate the CSV files:

```bash
python -m pip install -r requirements.txt
python generate_data.py
```

Open `pesapap_analysis.ipynb` in Jupyter and run all cells from top to bottom. The notebook regenerates the same CSV data, builds `pesapap.db` from the CSVs, runs the validation query and every query A–H from `sql/queries.sql` with `pd.read_sql`, then produces the KPI scorecard, RFM segments, cohort retention table, and experiment analysis. Generated CSV and database files are excluded from Git.

## Headline recommendation

The simplified onboarding group converted at 13.81%, versus 10.46% for control: a 3.34 percentage-point increase (31.96% relative lift; 95% confidence interval for the difference: 1.00–5.67 percentage points; chi-square p=0.0052). This supports a monitored, staged rollout while retaining a randomized holdout. The assignment balance check flagged unequal group sizes (1,443 vs. 1,557; p=0.0374), so investigate the allocation imbalance and confirm the result before full rollout.
