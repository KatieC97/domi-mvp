from fastapi import FastAPI

from fastapi.middleware.cors import CORSMiddleware

from app.routers import items, auth


app = FastAPI()

app.include_router(auth.router)
app.include_router(items.router)

app.add_middleware(

    CORSMiddleware,

    allow_origins=["*"],  # got to limit this bit in production

    allow_credentials=True,

    allow_methods=["*"],

    allow_headers=["*"],

)



app.include_router(items.router)

app.include_router(auth.router)



@app.get("/")

def root():

    return {"message": "Domï API is running"}