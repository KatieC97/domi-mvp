from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional, List

from app.database import get_db
from app.schemas import ItemCreate, ItemUpdate, ItemOut
from app.crud import (
get_all_items,
get_item_by_id,
create_item,
update_item,
delete_item,
)
from app.utils.security import get_current_user
from app.models import User

router = APIRouter(prefix="/items", tags=["Items"])

@router.get("/", response_model=List[ItemOut])
def read_items(
    name: Optional[str] = Query(None),
    location: Optional[str] = Query(None),
    barcode: Optional[str] = Query(None),
    owner_id: Optional[int] = Query(None),
    db: Session = Depends(get_db)
):
    return get_all_items(db, name=name, location=location, barcode=barcode, owner_id=owner_id)

@router.get("/{item_id}", response_model=ItemOut)
def read_item(item_id: int, db: Session = Depends(get_db)):
    return get_item_by_id(db, item_id)

@router.post("/", response_model=ItemOut, status_code=201)
def create_new_item(
    item: ItemCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return create_item(db, item, owner_id=current_user.id)

@router.put("/{item_id}", response_model=ItemOut)
def update_existing_item(
    item_id: int,
    update_data: ItemUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return update_item(db, item_id, update_data)

@router.delete("/{item_id}")
def delete_existing_item(
    item_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return delete_item(db, item_id)