"""Print verified support-operation metrics from the processed dataset."""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "processed" / "fact_support_tickets.csv"

df = pd.read_csv(DATA)

valid_response = df["calculated_response_sla_status"].isin(
    ["Within SLA", "SLA Violated"]
)
completed = df["status_group"].eq("Completed")

metrics = {
    "Total tickets": len(df),
    "Completed tickets": int(completed.sum()),
    "Active backlog": int(df["is_active_backlog"].sum()),
    "Backlog rate %": round(df["is_active_backlog"].mean() * 100, 2),
    "Average first response minutes": round(df["first_response_minutes"].mean(), 2),
    "Average resolution hours": round(df["resolution_hours"].mean(), 2),
    "Response SLA compliance %": round(
        (df.loc[valid_response, "calculated_response_sla_status"] == "Within SLA").mean() * 100,
        2,
    ),
    "Completed resolution SLA compliance %": round(
        (df.loc[completed, "calculated_resolution_sla_status"] == "Within SLA").mean() * 100,
        2,
    ),
    "Average survey score": round(df["survey_score"].mean(), 2),
}

for label, value in metrics.items():
    print(f"{label}: {value}")
