//uses Snowflake's built-in AI to read each contract description and sort it into one of five categories: 
//IT and software, construction, research, freight and warehousing, or facilities and support services. 
//It then totals the number of awards and the dollar spend for each category, using a 200-row sample to keep credit use low.


USE WAREHOUSE demo_wh;

WITH classified AS (
  SELECT amount,
         AI_CLASSIFY(description,
           ['IT and software services',
            'Construction and building work',
            'Research and development',
            'Freight, shipping and warehousing',
            'Facilities and support services (cleaning, security, food service)']
         ):labels[0]::STRING AS category
  FROM contract_awards
  LIMIT 200
)
SELECT category, COUNT(*) AS n, SUM(amount) AS total_spend
FROM classified
GROUP BY category
ORDER BY total_spend DESC;

//ALTER WAREHOUSE demo_wh SUSPEND; //ending so no more credits
