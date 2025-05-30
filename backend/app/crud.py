from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from datetime import datetime
from fastapi import HTTPException

from app.models import Item, User
from app.schemas import ItemCreate, ItemUpdate

# ===== USER CRUD =====

def get_user_by_username(db: Session, username: str):
    return db.query(User).filter(User.email == username).first()

# ===== ITEM CRUD =====

def get_all_items(db: Session, name=None, location=None, barcode=None, owner_id=None):
    query = db.query(Item)

    if name:
        query = query.filter(Item.name.ilike(f"%{name}%"))
    if location:
        query = query.filter(Item.location.ilike(f"%{location}%"))
    if barcode:
        query = query.filter(Item.barcode == barcode)
    if owner_id:
        query = query.filter(Item.owner_id == owner_id)

    return query.order_by(Item.timestamp.desc()).all()

def get_item_by_id(db: Session, item_id: int):
    item = db.query(Item).filter(Item.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item

def create_item(db: Session, item_data: ItemCreate, owner_id: int):
    new_item = Item(
        name=item_data.name,
        barcode=item_data.barcode,
        location=item_data.location,
        quantity=item_data.quantity,
        timestamp=datetime.utcnow(),
        owner_id=owner_id
)
    db.add(new_item)
    try:
        db.commit()
        db.refresh(new_item)
    except SQLAlchemyError:
        db.rollback()
        raise HTTPException(status_code=500, detail="Failed to create item")
    return new_item

def update_item(db: Session, item_id: int, update_data: ItemUpdate):
    item = db.query(Item).filter(Item.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")

    for field, value in update_data.dict(exclude_unset=True).items():
        setattr(item, field, value)

    try:
        db.commit()
        db.refresh(item)
    except SQLAlchemyError:
        db.rollback()
        raise HTTPException(status_code=500, detail="Failed to update item")
    return item

def delete_item(db: Session, item_id: int):
    item = db.query(Item).filter(Item.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")

    try:
        db.delete(item)
        db.commit()
    except SQLAlchemyError:
        db.rollback()
        raise HTTPException(status_code=500, detail="Failed to delete item")
    return {"message": f"Item {item_id} deleted"}