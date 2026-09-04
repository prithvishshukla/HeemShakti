# ============================================================
# personnel_cargo.py
# ============================================================
# Adds Personnel and Cargo/Inventory REST endpoints to your existing
# FastAPI backend, backed by persistent SQLite storage (a local .db
# file — data survives backend restarts).
#
# HOW TO USE
# ----------
# 1. Copy this file into the same folder as your existing FastAPI
#    app (the one that already serves /expeditions).
# 2. In your main FastAPI file (e.g. main.py), add:
#
#       from personnel_cargo import router as personnel_cargo_router
#       app.include_router(personnel_cargo_router)
#
# 3. Restart your backend. That's it — this file creates its own
#    SQLite database file called "heemshakti.db" in the same folder
#    the first time it runs, and creates the "personnel" and "cargo"
#    tables automatically if they don't exist yet. It does NOT touch
#    any table your Expedition module already uses.
#
# If you would rather store Personnel/Cargo in the SAME database file
# your Expedition module already uses, just change DB_PATH below to
# point at that file instead — the table names ("personnel", "cargo")
# won't collide with an "expeditions" table.
# ============================================================

import sqlite3
from pathlib import Path
from typing import Optional

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

# ----------------------------------------------------------
# DATABASE SETUP
# ----------------------------------------------------------

DB_PATH = Path(__file__).parent / "heemshakti.db"

router = APIRouter()


def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS personnel (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            role TEXT NOT NULL,
            station TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'Active',
            contact TEXT DEFAULT '',
            deployment_date TEXT DEFAULT '',
            assigned_expedition TEXT DEFAULT ''
        )
        """
    )

    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS cargo (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 0,
            unit TEXT NOT NULL DEFAULT 'Units',
            available INTEGER NOT NULL DEFAULT 0,
            not_available INTEGER NOT NULL DEFAULT 0,
            destination TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'Pending',
            assigned_expedition TEXT DEFAULT '',
            dispatch_date TEXT DEFAULT ''
        )
        """
    )

    conn.commit()
    conn.close()


init_db()


# ============================================================
# PERSONNEL
# ============================================================


class PersonnelIn(BaseModel):
    name: str
    role: str
    station: str
    status: str = "Active"
    contact: Optional[str] = ""
    deployment_date: Optional[str] = ""
    assigned_expedition: Optional[str] = ""


def row_to_personnel(row: sqlite3.Row) -> dict:
    return {
        "id": row["id"],
        "name": row["name"],
        "role": row["role"],
        "station": row["station"],
        "status": row["status"],
        "contact": row["contact"],
        "deployment_date": row["deployment_date"],
        "assigned_expedition": row["assigned_expedition"],
    }


@router.get("/personnel")
def get_all_personnel():
    conn = get_connection()
    rows = conn.execute("SELECT * FROM personnel ORDER BY id").fetchall()
    conn.close()
    return [row_to_personnel(r) for r in rows]


@router.get("/personnel/{personnel_id}")
def get_personnel(personnel_id: int):
    conn = get_connection()
    row = conn.execute(
        "SELECT * FROM personnel WHERE id = ?", (personnel_id,)
    ).fetchone()
    conn.close()

    if row is None:
        raise HTTPException(status_code=404, detail="Personnel not found")

    return row_to_personnel(row)


@router.post("/personnel", status_code=201)
def create_personnel(payload: PersonnelIn):
    conn = get_connection()
    cur = conn.execute(
        """
        INSERT INTO personnel (name, role, station, status, contact, deployment_date, assigned_expedition)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        (
            payload.name,
            payload.role,
            payload.station,
            payload.status,
            payload.contact or "",
            payload.deployment_date or "",
            payload.assigned_expedition or "",
        ),
    )
    conn.commit()
    new_id = cur.lastrowid

    row = conn.execute(
        "SELECT * FROM personnel WHERE id = ?", (new_id,)
    ).fetchone()
    conn.close()

    return row_to_personnel(row)


@router.put("/personnel/{personnel_id}")
def update_personnel(personnel_id: int, payload: PersonnelIn):
    conn = get_connection()

    existing = conn.execute(
        "SELECT * FROM personnel WHERE id = ?", (personnel_id,)
    ).fetchone()

    if existing is None:
        conn.close()
        raise HTTPException(status_code=404, detail="Personnel not found")

    conn.execute(
        """
        UPDATE personnel
        SET name = ?, role = ?, station = ?, status = ?, contact = ?,
            deployment_date = ?, assigned_expedition = ?
        WHERE id = ?
        """,
        (
            payload.name,
            payload.role,
            payload.station,
            payload.status,
            payload.contact or "",
            payload.deployment_date or "",
            payload.assigned_expedition or "",
            personnel_id,
        ),
    )
    conn.commit()

    row = conn.execute(
        "SELECT * FROM personnel WHERE id = ?", (personnel_id,)
    ).fetchone()
    conn.close()

    return row_to_personnel(row)


@router.delete("/personnel/{personnel_id}", status_code=200)
def delete_personnel(personnel_id: int):
    conn = get_connection()

    existing = conn.execute(
        "SELECT * FROM personnel WHERE id = ?", (personnel_id,)
    ).fetchone()

    if existing is None:
        conn.close()
        raise HTTPException(status_code=404, detail="Personnel not found")

    conn.execute("DELETE FROM personnel WHERE id = ?", (personnel_id,))
    conn.commit()
    conn.close()

    return {"message": "Personnel deleted", "id": personnel_id}


# ============================================================
# CARGO / INVENTORY
# ============================================================


class CargoIn(BaseModel):
    name: str
    category: str
    quantity: int
    unit: str = "Units"
    available: int = 0
    not_available: int = 0
    destination: str
    status: str = "Pending"
    assigned_expedition: Optional[str] = ""
    dispatch_date: Optional[str] = ""


def row_to_cargo(row: sqlite3.Row) -> dict:
    return {
        "id": row["id"],
        "name": row["name"],
        "category": row["category"],
        "quantity": row["quantity"],
        "unit": row["unit"],
        "available": row["available"],
        "not_available": row["not_available"],
        "destination": row["destination"],
        "status": row["status"],
        "assigned_expedition": row["assigned_expedition"],
        "dispatch_date": row["dispatch_date"],
    }


@router.get("/cargo")
def get_all_cargo():
    conn = get_connection()
    rows = conn.execute("SELECT * FROM cargo ORDER BY id").fetchall()
    conn.close()
    return [row_to_cargo(r) for r in rows]


@router.get("/cargo/{cargo_id}")
def get_cargo(cargo_id: int):
    conn = get_connection()
    row = conn.execute("SELECT * FROM cargo WHERE id = ?", (cargo_id,)).fetchone()
    conn.close()

    if row is None:
        raise HTTPException(status_code=404, detail="Cargo item not found")

    return row_to_cargo(row)


@router.post("/cargo", status_code=201)
def create_cargo(payload: CargoIn):
    conn = get_connection()
    cur = conn.execute(
        """
        INSERT INTO cargo (name, category, quantity, unit, available, not_available,
                            destination, status, assigned_expedition, dispatch_date)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            payload.name,
            payload.category,
            payload.quantity,
            payload.unit or "Units",
            payload.available,
            payload.not_available,
            payload.destination,
            payload.status,
            payload.assigned_expedition or "",
            payload.dispatch_date or "",
        ),
    )
    conn.commit()
    new_id = cur.lastrowid

    row = conn.execute("SELECT * FROM cargo WHERE id = ?", (new_id,)).fetchone()
    conn.close()

    return row_to_cargo(row)


@router.put("/cargo/{cargo_id}")
def update_cargo(cargo_id: int, payload: CargoIn):
    conn = get_connection()

    existing = conn.execute(
        "SELECT * FROM cargo WHERE id = ?", (cargo_id,)
    ).fetchone()

    if existing is None:
        conn.close()
        raise HTTPException(status_code=404, detail="Cargo item not found")

    conn.execute(
        """
        UPDATE cargo
        SET name = ?, category = ?, quantity = ?, unit = ?, available = ?,
            not_available = ?, destination = ?, status = ?,
            assigned_expedition = ?, dispatch_date = ?
        WHERE id = ?
        """,
        (
            payload.name,
            payload.category,
            payload.quantity,
            payload.unit or "Units",
            payload.available,
            payload.not_available,
            payload.destination,
            payload.status,
            payload.assigned_expedition or "",
            payload.dispatch_date or "",
            cargo_id,
        ),
    )
    conn.commit()

    row = conn.execute("SELECT * FROM cargo WHERE id = ?", (cargo_id,)).fetchone()
    conn.close()

    return row_to_cargo(row)


@router.delete("/cargo/{cargo_id}", status_code=200)
def delete_cargo(cargo_id: int):
    conn = get_connection()

    existing = conn.execute(
        "SELECT * FROM cargo WHERE id = ?", (cargo_id,)
    ).fetchone()

    if existing is None:
        conn.close()
        raise HTTPException(status_code=404, detail="Cargo item not found")

    conn.execute("DELETE FROM cargo WHERE id = ?", (cargo_id,))
    conn.commit()
    conn.close()

    return {"message": "Cargo item deleted", "id": cargo_id}
