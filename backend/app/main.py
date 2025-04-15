from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

# Product model (can be expanded based on your database)
class Product(BaseModel):
    name: str
    brand: str
    quantity: int
    location: str

# Simulate a product database or external API call
@app.get("/product/{barcode}")
async def get_product(barcode: str):
# Simulate a database or an external API call to fetch product details
# Replace this part with actual logic to query your database
    if barcode == "12345": # Simulate a successful lookup
        product = {
            "name": "Fairy Liquid",
            "brand": "Fairy",
            "quantity": 1,
            "location": "Kitchen"
        }
    else: # Handle error or not found case
        product = {"message": "Product not found"}

    return product