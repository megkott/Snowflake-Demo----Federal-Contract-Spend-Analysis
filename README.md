# Federal Contract Spend Analysis on Snowflake

## Problem
Contract descriptions are free text, so spend can't be grouped by type of work
out of the box. I wanted to analyze spend trends by agency and also turn the
description text into a category I could aggregate.

## Data
A 2,500-row **synthetic** dataset modeled on federal contract awards
(award ID, agency, NAICS code, award date, amount, description). It is not
real spending. The same pipeline works on public data from usaspending.gov.

## What I built
1. **Load:** created a warehouse (X-Small, 60-second auto-suspend), database
   and schema, then loaded the CSV through Snowsight.
2. **Window-function analytics:** CTEs plus LAG, a rolling 3-month AVG and
   RANK to show the top 5 agencies per month with month-over-month growth.
3. **AI classification:** used Snowflake Cortex `AI_CLASSIFY` to label each
   description, then grouped spend by the AI-assigned category.

## Finding
My first label list used a vague "Other" category, and the model filed
janitorial, security and laundry contracts under Logistics. I checked the
output against the raw text and replaced the labels with specific ones,
including "Facilities and support services." Logistics fell from 87 to 47
rows in the 200-row sample.

## Limits
- The AI step ran on a 200-row sample to limit credit use, so those totals
  describe the sample, not all 2,500 rows.
- One edge case is still arguable: "Construction of new warehouse and storage
  facility" is classified as warehousing.

## Next steps
- Classify all rows and store the result in a dynamic table so it refreshes
  automatically.
- Add a Streamlit dashboard on top of the results.
- Query the data from Python with the Snowflake connector.

## Files
- `01_setup.sql`
- `02_window_analytics.sql`
- `03_ai_classify.sql`
