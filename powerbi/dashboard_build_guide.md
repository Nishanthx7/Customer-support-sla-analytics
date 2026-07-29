# Power BI Dashboard Build Guide

## Source

Public Kaggle dataset:

https://www.kaggle.com/datasets/suvroo/technical-support-dataset

The source contains **2,330 tickets and 22 original columns**.
Treat it as a public portfolio dataset; do not claim that it is verified production data from a named company.

## Import these processed tables

1. `fact_support_tickets.csv` → `FactSupportTickets`
2. `dim_date.csv` → `DimDate`
3. `dim_agent.csv` → `DimAgent`
4. `dim_topic.csv` → `DimTopic`
5. `dim_country.csv` → `DimCountry`

## Relationships

- `DimDate[date]` 1:* `FactSupportTickets[created_date]`
- `DimAgent[agent_id]` 1:* `FactSupportTickets[agent_id]`
- `DimTopic[topic]` 1:* `FactSupportTickets[topic]`
- `DimCountry[country]` 1:* `FactSupportTickets[country]`

Use single-direction filtering from each dimension to the fact table.

Mark `DimDate` as the date table and sort `month_name` by `month_number`.

## Page 1 — Executive Overview

KPI cards:

- Total Tickets: **2,330**
- Completed Tickets: **1,912**
- Active Backlog: **418**
- Backlog Rate: **17.94%**
- Response SLA Compliance: **87.92%**
- Completed Resolution SLA Compliance: **80.86%**
- Average Survey Score: **3.51/5**

Visuals:

- Monthly ticket volume and active backlog
- Ticket volume by topic
- SLA compliance by source
- Ticket-status distribution
- Slicers for month, priority, source, product group, and support level

## Page 2 — SLA & Backlog Analysis

Visuals:

- Response SLA compliance by source and priority
- Completed resolution SLA compliance by topic
- Active backlog by topic and product group
- Backlog table with priority, agent, age, and overdue flag
- Average first-response and resolution time trends

## Page 3 — Agent & Product Performance

Visuals:

- Ticket volume and backlog by agent
- Resolution time and survey score by agent
- Product-group backlog rate
- Workload-versus-resolution scatter plot
- Country map using latitude and longitude

## Verified data-quality observations

- 2 tickets have a first response earlier than creation.
- 18 tickets have no first-response timestamp.
- 18 tickets have a missing interaction count.
- 14 source response-SLA flags differ from timestamp-based recalculation.
- 0 completed resolution-SLA flags differ from timestamp-based recalculation.

Use the calculated SLA fields for dashboard KPIs and retain source SLA fields for audit comparison.
