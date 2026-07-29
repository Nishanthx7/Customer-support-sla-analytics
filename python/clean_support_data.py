"""Clean the Kaggle technical-support dataset and create Power BI-ready tables."""

from pathlib import Path
import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw" / "technical_support_dataset_raw.csv"
OUT = ROOT / "data" / "processed" / "fact_support_tickets_rebuilt.csv"

df = pd.read_csv(RAW)

df = df.rename(columns={
    "Status": "status",
    "Ticket ID": "ticket_id",
    "Priority": "priority",
    "Source": "source",
    "Topic": "topic",
    "Agent Group": "agent_group",
    "Agent Name": "agent_name",
    "Created time": "created_at",
    "Expected SLA to resolve": "expected_resolution_at",
    "Expected SLA to first response": "expected_first_response_at",
    "First response time": "first_response_at",
    "SLA For first response": "source_response_sla_status",
    "Resolution time": "resolution_at",
    "SLA For Resolution": "source_resolution_sla_status",
    "Close time": "closed_at",
    "Agent interactions": "agent_interactions",
    "Survey results": "survey_score",
    "Product group": "product_group",
    "Support Level": "support_level",
    "Country": "country",
    "Latitude": "latitude",
    "Longitude": "longitude",
})

datetime_cols = [
    "created_at", "expected_resolution_at", "expected_first_response_at",
    "first_response_at", "resolution_at", "closed_at"
]
for col in datetime_cols:
    df[col] = pd.to_datetime(df[col], errors="coerce")

df["topic"] = df["topic"].replace({
    "Pricing and Licensing": "Pricing and licensing"
})

df["status_group"] = np.where(
    df["status"].isin(["Closed", "Resolved"]), "Completed", "Active"
)

df["created_date"] = df["created_at"].dt.date
df["year_month"] = df["created_at"].dt.to_period("M").astype(str)

df["response_target_minutes"] = (
    (df["expected_first_response_at"] - df["created_at"])
    .dt.total_seconds() / 60
).round(2)

df["first_response_minutes_raw"] = (
    (df["first_response_at"] - df["created_at"])
    .dt.total_seconds() / 60
).round(2)

df["invalid_response_timestamp"] = df["first_response_minutes_raw"] < 0
df["first_response_minutes"] = df["first_response_minutes_raw"].mask(
    df["invalid_response_timestamp"]
)

df["resolution_target_hours"] = (
    (df["expected_resolution_at"] - df["created_at"])
    .dt.total_seconds() / 3600
).round(2)

df["resolution_hours"] = (
    (df["resolution_at"] - df["created_at"])
    .dt.total_seconds() / 3600
).round(2)

snapshot_at = max(df[col].max() for col in datetime_cols)

df["backlog_age_days"] = np.where(
    df["status_group"].eq("Active"),
    (snapshot_at - df["created_at"]).dt.total_seconds() / 86400,
    0,
).round(2)

df["calculated_response_sla_status"] = np.select(
    [
        df["first_response_at"].isna(),
        df["invalid_response_timestamp"],
        df["first_response_at"] <= df["expected_first_response_at"],
    ],
    ["No response", "Invalid timestamp", "Within SLA"],
    default="SLA Violated",
)

effective_resolution_check = df["resolution_at"].fillna(snapshot_at)
df["calculated_resolution_sla_status"] = np.where(
    effective_resolution_check <= df["expected_resolution_at"],
    "Within SLA",
    "SLA Violated",
)

df.to_csv(OUT, index=False)
print(f"Saved {len(df):,} cleaned ticket records to {OUT}")
