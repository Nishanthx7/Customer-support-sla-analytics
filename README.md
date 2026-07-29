# Customer Support Operations & SLA Analytics

An end-to-end data analytics portfolio project built from a public Kaggle technical-support dataset.

## Data source

https://www.kaggle.com/datasets/suvroo/technical-support-dataset

The uploaded source contains **2,330 rows and 22 columns**.
It should be described as a public Kaggle dataset, not as verified production data from a specific company.

## Tools

- Python
- pandas / NumPy
- SQL / SQLite
- Microsoft Excel
- Power Query
- Power BI
- DAX

## Project objectives

1. Clean and validate ticket, timestamp, SLA, interaction, and survey fields.
2. Recalculate response and resolution SLA outcomes from timestamps.
3. Analyse ticket volume, backlog, response time, resolution time, SLA compliance, agent workload, and survey scores.
4. Build a Power BI star schema and three-page dashboard.
5. Document findings, data-quality limitations, and operational recommendations.

## Verified metrics

- Total tickets: **2,330**
- Completed tickets: **1,912**
- Active backlog: **418 (17.94%)**
- Average first-response time: **26.83 minutes**
- Median first-response time: **5.53 minutes**
- Average completed resolution time: **33.24 hours**
- Response SLA compliance: **87.92%**
- Completed resolution SLA compliance: **80.86%**
- Average survey score: **3.51/5**

## Verified findings

- Highest-volume topic: **Product setup (630 tickets)**
- Highest topic backlog rate: **Training request (24.24%)**
- Lowest topic resolution-SLA compliance: **Training request (76.00%)**
- Lowest response-SLA compliance by source: **Phone (75.82%)**
- Largest active backlog by agent: **Connor Danielovitch (74 tickets)**

## Data-quality findings

- 2 invalid negative first-response durations
- 18 missing first-response timestamps
- 18 missing agent-interaction values
- 14 response-SLA label mismatches against timestamps
- 0 completed resolution-SLA label mismatches against timestamps

## Repository structure

```text
customer-support-sla-analytics-kaggle/
├── data/
│   ├── raw/
│   └── processed/
├── docs/
├── powerbi/
├── python/
├── reports/
├── sql/
├── customer_support_sla_analytics.db
├── requirements.txt
└── README.md
```

## Important reporting rule

Use `calculated_response_sla_status` and `calculated_resolution_sla_status`
for dashboard metrics. Retain the original source SLA columns only for audit comparison.
