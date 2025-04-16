from fastapi import FastAPI
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import requests
from pydantic import BaseModel

app = FastAPI()

# Allow CORS for local dev
origins = ["*"] # Allows all origins for dev

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Product(BaseModel):
    name: str
    brand: str
    quantity: int
    location: str

# Product endpoint
@app.get("/product/{barcode}", response_model=Product)
async def get_product(barcode: str):
    print(f"Fetching product for barcode: {barcode}") # Log the incoming barcode

    response = requests.get(f"https://api.upcitemdb.com/prod/trial/lookup?upc={barcode}")
    print(f"UPCItemDB raw response: {response.text}") # Log API response

    if response.status_code == 200:
        data = response.json()
        items = data.get("items", [])
        if items:
            item = items[0]
            return Product(
                name=item.get("title", "Unknown Product"),
                brand=item.get("brand", "Unknown Brand"),
                quantity=1,
                location="Kitchen"
            )

    return JSONResponse(status_code=404, content={"message": "Product not found"})