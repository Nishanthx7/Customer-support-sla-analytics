-- 1. Executive support-operation KPIs
SELECT
    COUNT(*) AS total_tickets,
    SUM(is_completed) AS completed_tickets,
    SUM(is_active_backlog) AS active_backlog,
    ROUND(100.0 * AVG(is_active_backlog), 2) AS backlog_rate_pct,
    ROUND(AVG(first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(survey_score), 2) AS avg_survey_score
FROM fact_support_tickets;

-- 2. Response SLA compliance
SELECT
    ROUND(
        100.0 * SUM(
            CASE WHEN calculated_response_sla_status = 'Within SLA' THEN 1 ELSE 0 END
        ) / NULLIF(SUM(
            CASE WHEN calculated_response_sla_status IN ('Within SLA', 'SLA Violated') THEN 1 ELSE 0 END
        ), 0),
        2
    ) AS response_sla_compliance_pct
FROM fact_support_tickets;

-- 3. Completed-ticket resolution SLA compliance
SELECT
    ROUND(
        100.0 * AVG(
            CASE WHEN calculated_resolution_sla_status = 'Within SLA' THEN 1.0 ELSE 0.0 END
        ),
        2
    ) AS completed_resolution_sla_compliance_pct
FROM fact_support_tickets
WHERE status_group = 'Completed';

-- 4. Monthly operational trend
SELECT
    year_month,
    COUNT(*) AS total_tickets,
    SUM(is_active_backlog) AS active_backlog,
    ROUND(AVG(first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(survey_score), 2) AS avg_survey_score
FROM fact_support_tickets
GROUP BY year_month
ORDER BY year_month;

-- 5. SLA performance by source
SELECT
    source,
    COUNT(*) AS total_tickets,
    ROUND(AVG(first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(
        100.0 * SUM(
            CASE WHEN calculated_response_sla_status = 'Within SLA' THEN 1 ELSE 0 END
        ) / NULLIF(SUM(
            CASE WHEN calculated_response_sla_status IN ('Within SLA', 'SLA Violated') THEN 1 ELSE 0 END
        ), 0),
        2
    ) AS response_sla_compliance_pct
FROM fact_support_tickets
GROUP BY source
ORDER BY response_sla_compliance_pct;

-- 6. Topic volume, backlog, and resolution performance
SELECT
    topic,
    COUNT(*) AS total_tickets,
    SUM(is_active_backlog) AS active_backlog,
    ROUND(100.0 * AVG(is_active_backlog), 2) AS backlog_rate_pct,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours
FROM fact_support_tickets
GROUP BY topic
ORDER BY total_tickets DESC;

-- 7. Agent workload
SELECT
    agent_name,
    COUNT(*) AS total_tickets,
    SUM(is_active_backlog) AS active_backlog,
    ROUND(AVG(first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(survey_score), 2) AS avg_survey_score
FROM fact_support_tickets
GROUP BY agent_name
ORDER BY active_backlog DESC, total_tickets DESC;

-- 8. Product-group bottlenecks
SELECT
    product_group,
    COUNT(*) AS total_tickets,
    SUM(is_active_backlog) AS active_backlog,
    ROUND(100.0 * AVG(is_active_backlog), 2) AS backlog_rate_pct,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours
FROM fact_support_tickets
GROUP BY product_group
ORDER BY backlog_rate_pct DESC;

-- 9. Priority and SLA analysis
SELECT
    priority,
    COUNT(*) AS total_tickets,
    SUM(is_active_backlog) AS active_backlog,
    ROUND(AVG(first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours
FROM fact_support_tickets
GROUP BY priority
ORDER BY total_tickets DESC;

-- 10. High-risk backlog
SELECT
    ticket_id,
    status,
    priority,
    topic,
    product_group,
    agent_name,
    country,
    backlog_age_days,
    active_overdue
FROM fact_support_tickets
WHERE is_active_backlog = 1
ORDER BY active_overdue DESC, backlog_age_days DESC;

-- 11. Survey score by service performance
SELECT
    calculated_response_sla_status,
    calculated_resolution_sla_status,
    COUNT(*) AS surveyed_tickets,
    ROUND(AVG(survey_score), 2) AS avg_survey_score
FROM fact_support_tickets
WHERE survey_score IS NOT NULL
GROUP BY
    calculated_response_sla_status,
    calculated_resolution_sla_status
ORDER BY avg_survey_score DESC;

-- 12. Data-quality exceptions
SELECT
    ticket_id,
    invalid_response_timestamp,
    response_sla_label_mismatch,
    resolution_sla_label_mismatch,
    data_quality_issue
FROM fact_support_tickets
WHERE data_quality_issue <> 'None'
   OR response_sla_label_mismatch = 1
   OR resolution_sla_label_mismatch = 1;
