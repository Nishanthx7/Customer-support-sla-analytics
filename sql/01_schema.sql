-- SQLite star-schema tables are also included in customer_support_sla_analytics.db.

CREATE TABLE fact_support_tickets (
    ticket_id TEXT PRIMARY KEY,
    status TEXT,
    status_group TEXT,
    priority TEXT,
    source TEXT,
    topic TEXT,
    product_group TEXT,
    support_level TEXT,
    agent_group TEXT,
    agent_name TEXT,
    agent_id TEXT,
    country TEXT,
    latitude REAL,
    longitude REAL,
    created_at TEXT,
    created_date TEXT,
    year_month TEXT,
    expected_first_response_at TEXT,
    first_response_at TEXT,
    response_target_minutes REAL,
    first_response_minutes REAL,
    calculated_response_sla_status TEXT,
    expected_resolution_at TEXT,
    resolution_at TEXT,
    resolution_target_hours REAL,
    resolution_hours REAL,
    calculated_resolution_sla_status TEXT,
    closed_at TEXT,
    closure_hours REAL,
    agent_interactions REAL,
    survey_score REAL,
    is_active_backlog INTEGER,
    is_completed INTEGER,
    active_overdue INTEGER,
    backlog_age_days REAL
);

CREATE TABLE dim_date (
    date TEXT PRIMARY KEY,
    year INTEGER,
    month_number INTEGER,
    month_name TEXT,
    year_month TEXT,
    quarter TEXT,
    day_name TEXT,
    week_number INTEGER,
    is_weekend INTEGER
);

CREATE TABLE dim_agent (
    agent_id TEXT PRIMARY KEY,
    agent_name TEXT,
    agent_group TEXT,
    support_level TEXT
);

CREATE TABLE dim_topic (
    topic_id TEXT PRIMARY KEY,
    topic TEXT
);

CREATE TABLE dim_country (
    country TEXT PRIMARY KEY,
    latitude REAL,
    longitude REAL
);
