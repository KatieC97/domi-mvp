from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

# Product model (can be expanded based on your database)
class Product(BaseModel):
    name: str
    brand: str
    quantity: int
    location: str

# Error model for better handling
class ErrorResponse(BaseModel):
    message: str

# Simulate a product database or external API call
@app.get("/product/{barcode}", response_model=Product, responses={404: {"model": ErrorResponse}})
async def get_product(barcode: str):
    # Simulate a database or an external API call to fetch product details
    if barcode == "12345": # Simulate a successful lookup
        return Product(
            name="Fairy Liquid",
            brand="Fairy",
            quantity=1,
            location="Kitchen"
        )
    else: # Handle error or not found case
        return ErrorResponse(message="Product not found")