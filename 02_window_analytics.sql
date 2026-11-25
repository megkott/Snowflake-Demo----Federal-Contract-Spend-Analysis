//shows how spending changes over time for each agency. 
//It totals spend per agency per month, compares each month to the one before it, 
//calculates a rolling 3-month average, and ranks agencies within each month. 
//The final output keeps only the top 5 agencies for each month.


WITH monthly AS (
  SELECT agency,
         DATE_TRUNC('month', award_date) AS month,
         SUM(amount) AS total
  FROM contract_awards
  GROUP BY 1, 2
),
windowed AS (
  SELECT agency, month, total,
         LAG(total) OVER (PARTITION BY agency ORDER BY month) AS prev_total,
         AVG(total) OVER (PARTITION BY agency ORDER BY month
                          ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3mo,
         RANK() OVER (PARTITION BY month ORDER BY total DESC) AS rank_in_month
  FROM monthly
)
SELECT agency, month, total,
       (total - prev_total) / NULLIF(prev_total, 0) AS mom_growth,
       rolling_3mo, rank_in_month
FROM windowed
WHERE rank_in_month <= 5
ORDER BY month, rank_in_month;
