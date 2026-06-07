"""Build one dashboard-ready dataset for UrbanCart Capstone 1.

Run from the repo root:
    python src/build_dashboard_dataset.py
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
PROCESSED = ROOT / "data" / "processed"


def main() -> None:
    customers = pd.read_csv(RAW / "customers.csv")
    orders = pd.read_csv(RAW / "orders.csv")
    order_items = pd.read_csv(RAW / "order_items.csv")
    products = pd.read_csv(RAW / "products.csv")
    returns = pd.read_csv(RAW / "returns.csv")

    returns_flags = returns[["line_id", "return_id", "return_reason", "refund_amount"]].copy()
    returns_flags["returned_flag"] = 1

    analysis = (
        order_items
        .merge(orders, on="order_id", how="left")
        .merge(
            customers[["customer_id", "age_band", "acquisition_channel", "loyalty_tier"]],
            on="customer_id",
            how="left",
        )
        .merge(
            products[["product_id", "category", "sub_category", "product_name", "brand"]],
            on="product_id",
            how="left",
        )
        .merge(returns_flags, on="line_id", how="left")
    )

    analysis["returned_flag"] = analysis["returned_flag"].fillna(0).astype(int)
    analysis["refund_amount"] = analysis["refund_amount"].fillna(0)
    analysis["return_reason"] = analysis["return_reason"].fillna("Not Returned")
    analysis["order_month"] = pd.to_datetime(analysis["order_date"]).dt.to_period("M").astype(str)
    analysis["net_revenue"] = analysis["line_revenue"] - analysis["refund_amount"]

    columns = [
        "order_id", "line_id", "order_date", "order_month", "customer_id", "city", "region",
        "sales_channel", "payment_method", "age_band", "loyalty_tier", "product_id",
        "category", "sub_category", "product_name", "brand", "quantity", "unit_price",
        "discount_pct", "line_revenue", "line_cost", "line_margin", "returned_flag",
        "return_reason", "refund_amount", "net_revenue", "customer_rating",
    ]

    PROCESSED.mkdir(parents=True, exist_ok=True)
    output_path = PROCESSED / "dashboard_ready.csv"
    analysis[columns].to_csv(output_path, index=False)

    print(f"Created {output_path}")
    print(f"Rows: {len(analysis):,}")


if __name__ == "__main__":
    main()
