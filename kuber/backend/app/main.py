from fastapi import FastAPI, Request
import os


app = FastAPI()


POD = os.environ.get("POD_NAME", "unknown-pod")


@app.get("/")
async def root():
    return {"message": "Hello from backend!", "pod": POD}


@app.get("/ping")
async def ping():
    return {"status": "ok", "pod": POD}


# простая страница для ручного теста
@app.get("/hello")
async def hello():
    return "Hello from backend!"