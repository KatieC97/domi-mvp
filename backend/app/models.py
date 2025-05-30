from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, func

from sqlalchemy.orm import relationship

from app.database import Base



class User(Base):

    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)

    email = Column(String, unique=True, nullable=False)

    hashed_password = Column(String, nullable=False)



    items = relationship("Item", back_populates="owner")



class Item(Base):

    __tablename__ = "items"



    id = Column(Integer, primary_key=True, index=True)

    name = Column(String, nullable=False)

    barcode = Column(String, index=True)

    location = Column(String, nullable=True)

    quantity = Column(Integer, default=1)

    timestamp = Column(DateTime(timezone=True), server_default=func.now())



    owner_id = Column(Integer, ForeignKey("users.id"))

    owner = relationship("User", back_populates="items")

