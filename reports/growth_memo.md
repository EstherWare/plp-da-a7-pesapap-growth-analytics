# PesaPap Growth Memo

## Result

The simplified onboarding group converted 215 of 1,557 assigned users (13.81%), compared with 151 of 1,443 control users (10.46%). The observed difference is 3.34 percentage points, or a 31.96% relative lift. A two-sided Pearson chi-square test gives p=0.0052; the 95% Newcombe confidence interval for the difference is 1.00–5.67 percentage points.

The assignment balance check found 1,443 control and 1,557 simplified-onboarding users (chi-square p=0.0374). The analysis also flagged 3,737 transactions before signup dates, involving 1,749 users (58.3% of all users).

## Impact

If the measured effect carries over, the simplified flow corresponds to about 33 additional conversions per 1,000 assigned users. The experiment measures conversion only; it does not establish added transaction value, retention, or customer lifetime value.

## Recommendation

Proceed with a monitored, staged rollout of the simplified screen while keeping a randomized holdout. Investigate the group-size imbalance and confirm the uplift in a follow-up test before committing to a full rollout. Track conversion alongside post-signup transaction activity and retention.

## Caveats

The group-size balance test flags an allocation difference, which should be investigated even though the observed conversion difference is statistically significant. The confidence interval quantifies uncertainty in conversion lift, not downstream business value. Pre-signup transaction rows are retained in overall SQL and transaction KPIs to preserve source totals, but excluded from cohort retention because they cannot represent post-signup activity. June is a partial transaction month, so affected cohort cells are marked incomplete.
