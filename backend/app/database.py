from sqlalchemy import create_engine

from sqlalchemy.ext.declarative import declarative_base

from sqlalchemy.orm import sessionmaker

from sqlalchemy.pool import StaticPool

import logging



logger = logging.getLogger(__name__)



DATABASE_URL = "sqlite:///./dome.sqlite3"



engine = create_engine(

    DATABASE_URL,

    connect_args={"check_same_thread": False},

    poolclass=StaticPool

)



SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)



Base = declarative_base()



def get_db():

    db = SessionLocal()

    try:

        yield db

    finally:

        db.close()



def create_db_and_tables():

    try:

        from app import models

        Base.metadata.create_all(bind=engine)

        logger.info("Database and tables created successfully.")

    except Exception as e:

        logger.error(f"Database setup failed: {e}")