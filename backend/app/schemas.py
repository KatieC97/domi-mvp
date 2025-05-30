from pydantic import BaseModel, Field

from typing import Optional

from datetime import datetime



# Shared base

class ItemBase(BaseModel):

    name: str = Field(..., example="Fairy Liquid")

    barcode: Optional[str] = Field(None, example="5012345678900")

    location: Optional[str] = Field(None, example="Kitchen Cupboard")

    quantity: Optional[int] = Field(1, ge=0, example=2)



#  item creation

class ItemCreate(ItemBase):

    pass



#  item update (partial fields allowed)

class ItemUpdate(BaseModel):

    name: Optional[str] = None

    barcode: Optional[str] = None

    location: Optional[str] = None

    quantity: Optional[int] = None



# Response model

class ItemOut(ItemBase):

    id: int

    timestamp: datetime



    class Config:

        orm_mode = True



# user functionality

class UserBase(BaseModel):

    email: str
    name: Optional[str] = None



class UserCreate(UserBase):

    name: str
    email: str
    password: str



class UserOut(UserBase):

    id: int



    class Config:

        orm_mode = True

