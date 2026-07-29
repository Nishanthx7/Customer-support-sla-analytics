# Executive Summary

## Dataset profile

- Public Kaggle technical-support dataset
- 2,330 unique tickets
- Activity period: 2023-01-02 to 2023-12-30
- 1,912 completed tickets
- 418 active tickets at the dataset snapshot

## Core performance

- Active backlog rate: **17.94%**
- Average first-response time: **26.83 minutes**
- Median first-response time: **5.53 minutes**
- Average completed resolution time: **33.24 hours**
- Response SLA compliance: **87.92%**
- Completed resolution SLA compliance: **80.86%**
- Average survey score: **3.51/5**

## Verified findings

1. **Product setup** was the highest-volume topic with **630 tickets**.
2. **Training request** had the highest topic-level backlog rate at **24.24%**.
3. **Training request** had the lowest completed resolution-SLA compliance among topics at **76.00%**.
4. **Phone** had the lowest response-SLA compliance among support sources at **75.82%**.
5. **Connor Danielovitch** held the largest active backlog with **74 tickets**.
6. Completed resolution-SLA compliance declined from **91.44%** in 2023-01 to **72.41%** in 2023-12.

## Recommendations

- Review staffing and routing rules for topics with elevated backlog or low resolution-SLA compliance.
- Investigate the Phone workflow because it has the lowest response-SLA compliance, despite a relatively small share of total volume.
- Monitor workload concentration at agent level and redistribute active tickets where backlogs are disproportionately high.
- Audit the identified timestamp and source-SLA inconsistencies before using the original SLA fields for executive reporting.
- Track monthly resolution-SLA performance because the verified trend weakened over the year.
