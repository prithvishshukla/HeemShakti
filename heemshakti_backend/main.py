# from fastapi import FastAPI, HTTPException
# from pydantic import BaseModel
# from typing import List
#
# from personnel_cargo import router as personnel_cargo_router
# app = FastAPI(
#     title="HeemShakti API",
#     description="Integrated Polar Expedition Logistics and Asset Management System",
#     version="1.0.0"
# )
# app.include_router(personnel_cargo_router)
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List

from personnel_cargo import router as personnel_cargo_router
from reports import router as reports_router


app = FastAPI(
    title="HeemShakti API",
    description="Integrated Polar Expedition Logistics and Asset Management System",
    version="1.0.0"
)


app.include_router(personnel_cargo_router)
app.include_router(reports_router)

# ============================================================
# MODELS
# ============================================================

class ExpeditionCreate(BaseModel):
    name: str
    destination: str
    start_date: str
    end_date: str
    status: str


class Expedition(BaseModel):
    id: int
    name: str
    destination: str
    start_date: str
    end_date: str
    status: str


# ============================================================
# TEMPORARY DATABASE
# ============================================================

expeditions = [
    {
        "id": 1,
        "name": "Antarctica Summer Expedition",
        "destination": "Bharati Research Station",
        "start_date": "2026-11-01",
        "end_date": "2027-03-31",
        "status": "Planning"
    },
    {
        "id": 2,
        "name": "Arctic Research Mission",
        "destination": "Ny-Alesund Research Station",
        "start_date": "2026-12-01",
        "end_date": "2027-02-28",
        "status": "Planning"
    }
]


# ============================================================
# HOME
# ============================================================

@app.get("/")
def home():
    return {
        "message": "HeemShakti Backend is running"
    }


# ============================================================
# GET ALL EXPEDITIONS
# ============================================================

@app.get("/expeditions", response_model=List[Expedition])
def get_expeditions():
    return expeditions


# ============================================================
# GET SINGLE EXPEDITION
# ============================================================

@app.get("/expeditions/{expedition_id}", response_model=Expedition)
def get_expedition(expedition_id: int):

    for expedition in expeditions:
        if expedition["id"] == expedition_id:
            return expedition

    raise HTTPException(
        status_code=404,
        detail="Expedition not found"
    )


# ============================================================
# CREATE EXPEDITION
# ============================================================

@app.post("/expeditions", status_code=201)
def create_expedition(expedition: ExpeditionCreate):

    new_id = max(
        [item["id"] for item in expeditions],
        default=0
    ) + 1

    new_expedition = {
        "id": new_id,
        **expedition.model_dump()
    }

    expeditions.append(new_expedition)

    return {
        "message": "Expedition created successfully",
        "data": new_expedition
    }


# ============================================================
# UPDATE EXPEDITION
# ============================================================

@app.put("/expeditions/{expedition_id}")
def update_expedition(
        expedition_id: int,
        updated_expedition: ExpeditionCreate
):

    for index, expedition in enumerate(expeditions):

        if expedition["id"] == expedition_id:

            expeditions[index] = {
                "id": expedition_id,
                **updated_expedition.model_dump()
            }

            return {
                "message": "Expedition updated successfully",
                "data": expeditions[index]
            }

    raise HTTPException(
        status_code=404,
        detail="Expedition not found"
    )


# ============================================================
# DELETE EXPEDITION
# ============================================================

@app.delete("/expeditions/{expedition_id}")
def delete_expedition(expedition_id: int):

    for index, expedition in enumerate(expeditions):

        if expedition["id"] == expedition_id:

            deleted = expeditions.pop(index)

            return {
                "message": "Expedition deleted successfully",
                "data": deleted
            }

    raise HTTPException(
        status_code=404,
        detail="Expedition not found"
    )