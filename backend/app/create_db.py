from app.database import Base, engine
from app import models

def create_database():
    print("Creating database tables...")
    Base.metadata.create_all(bind=engine)
    print("Done.")

if __name__ == "__main__":
    create_database()