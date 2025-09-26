from fastapi import FastAPI
from routes import notes

app = FastAPI(
    title="ConnectInno Case API",
    version="1.0.0"
)

app.include_router(notes.router)

@app.get("/")
def root():
    return {"message": "Backend is running 🚀"}
