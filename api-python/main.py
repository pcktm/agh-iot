from typing import Union
from fastapi import FastAPI
import toml

app = FastAPI()

@app.get("/")
def status():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}