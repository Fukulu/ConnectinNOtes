from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class Note(BaseModel):
    id: Optional[str] = None
    title: str
    content: str
    pinned: bool = False
    createdAt: Optional[datetime] = None
    updatedAt: Optional[datetime] = None
