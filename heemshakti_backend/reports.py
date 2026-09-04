import sqlite3
from pathlib import Path

from fastapi import APIRouter


# ============================================================
# DATABASE
# ============================================================

DB_PATH = Path(__file__).parent / "heemshakti.db"

router = APIRouter(
    prefix="/reports",
    tags=["Reports"]
)


def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


# ============================================================
# REPORT SUMMARY
# ============================================================

@router.get("/summary")
def get_report_summary():

    conn = get_connection()

    # --------------------------------------------------------
    # PERSONNEL REPORT
    # --------------------------------------------------------

    personnel_total = conn.execute(
        "SELECT COUNT(*) FROM personnel"
    ).fetchone()[0]

    personnel_active = conn.execute(
        """
        SELECT COUNT(*)
        FROM personnel
        WHERE LOWER(status) = 'active'
        """
    ).fetchone()[0]

    personnel_inactive = conn.execute(
        """
        SELECT COUNT(*)
        FROM personnel
        WHERE LOWER(status) != 'active'
        """
    ).fetchone()[0]

    # --------------------------------------------------------
    # CARGO REPORT
    # --------------------------------------------------------

    cargo_total = conn.execute(
        "SELECT COUNT(*) FROM cargo"
    ).fetchone()[0]

    cargo_delivered = conn.execute(
        """
        SELECT COUNT(*)
        FROM cargo
        WHERE LOWER(status) = 'delivered'
        """
    ).fetchone()[0]

    cargo_in_transit = conn.execute(
        """
        SELECT COUNT(*)
        FROM cargo
        WHERE LOWER(status) = 'in transit'
        """
    ).fetchone()[0]

    cargo_pending = conn.execute(
        """
        SELECT COUNT(*)
        FROM cargo
        WHERE LOWER(status) = 'pending'
        """
    ).fetchone()[0]

    # --------------------------------------------------------
    # INVENTORY REPORT
    # --------------------------------------------------------

    inventory_total = conn.execute(
        """
        SELECT COALESCE(SUM(quantity), 0)
        FROM cargo
        """
    ).fetchone()[0]

    inventory_available = conn.execute(
        """
        SELECT COALESCE(SUM(available), 0)
        FROM cargo
        """
    ).fetchone()[0]

    inventory_not_available = conn.execute(
        """
        SELECT COALESCE(SUM(not_available), 0)
        FROM cargo
        """
    ).fetchone()[0]

    conn.close()

    # --------------------------------------------------------
    # PERCENTAGES
    # --------------------------------------------------------

    personnel_active_percentage = 0

    if personnel_total > 0:
        personnel_active_percentage = round(
            (personnel_active / personnel_total) * 100,
            1
        )

    inventory_available_percentage = 0

    if inventory_total > 0:
        inventory_available_percentage = round(
            (inventory_available / inventory_total) * 100,
            1
        )

    # --------------------------------------------------------
    # FINAL RESPONSE
    # --------------------------------------------------------

    return {

        "personnel": {
            "total": personnel_total,
            "active": personnel_active,
            "inactive": personnel_inactive,
            "active_percentage": personnel_active_percentage
        },

        "cargo": {
            "total": cargo_total,
            "delivered": cargo_delivered,
            "in_transit": cargo_in_transit,
            "pending": cargo_pending
        },

        "inventory": {
            "total": inventory_total,
            "available": inventory_available,
            "not_available": inventory_not_available,
            "available_percentage": inventory_available_percentage
        }
    }


# ============================================================
# PERSONNEL REPORT
# ============================================================

@router.get("/personnel")
def personnel_report():

    conn = get_connection()

    total = conn.execute(
        "SELECT COUNT(*) FROM personnel"
    ).fetchone()[0]

    active = conn.execute(
        """
        SELECT COUNT(*)
        FROM personnel
        WHERE LOWER(status) = 'active'
        """
    ).fetchone()[0]

    rows = conn.execute(
        """
        SELECT role, COUNT(*) as count
        FROM personnel
        GROUP BY role
        ORDER BY count DESC
        """
    ).fetchall()

    conn.close()

    role_distribution = []

    for row in rows:
        role_distribution.append({
            "role": row["role"],
            "count": row["count"]
        })

    return {
        "total": total,
        "active": active,
        "role_distribution": role_distribution
    }


# ============================================================
# CARGO REPORT
# ============================================================

@router.get("/cargo")
def cargo_report():

    conn = get_connection()

    rows = conn.execute(
        """
        SELECT status, COUNT(*) as count
        FROM cargo
        GROUP BY status
        """
    ).fetchall()

    categories = conn.execute(
        """
        SELECT category, COUNT(*) as count
        FROM cargo
        GROUP BY category
        ORDER BY count DESC
        """
    ).fetchall()

    conn.close()

    status_distribution = []

    for row in rows:
        status_distribution.append({
            "status": row["status"],
            "count": row["count"]
        })

    category_distribution = []

    for row in categories:
        category_distribution.append({
            "category": row["category"],
            "count": row["count"]
        })

    return {
        "status_distribution": status_distribution,
        "category_distribution": category_distribution
    }