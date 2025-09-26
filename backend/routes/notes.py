from fastapi import APIRouter, Depends, HTTPException
from models import Note
from services.firebase import db
from dependencies import get_current_user   # artık buradan geliyor
from datetime import datetime

router = APIRouter(
    prefix="/notes",
    tags=["Notes"]
)

# GET /notes
@router.get("")
def list_notes(user_id: str = Depends(get_current_user)):
    notes_ref = db.collection("notes").where("userId", "==", user_id)
    results = [ {**doc.to_dict(), "id": doc.id} for doc in notes_ref.stream() ]
    return results

# POST /notes
@router.post("")
def create_note(note: Note, user_id: str = Depends(get_current_user)):
    note_data = {
        "title": note.title,
        "content": note.content,
        "pinned": note.pinned,
        "userId": user_id,
        "createdAt": datetime.utcnow(),
        "updatedAt": datetime.utcnow()
    }
    new_ref = db.collection("notes").add(note_data)
    return {"id": new_ref[1].id, **note_data}

# PUT /notes/{id}
@router.put("/{note_id}")
def update_note(note_id: str, note: Note, user_id: str = Depends(get_current_user)):
    note_ref = db.collection("notes").document(note_id)
    doc = note_ref.get()
    if not doc.exists or doc.to_dict().get("userId") != user_id:
        raise HTTPException(status_code=404, detail="Note not found or not authorized")
    update_data = {
        "title": note.title,
        "content": note.content,
        "pinned": note.pinned,
        "updatedAt": datetime.utcnow()
    }
    note_ref.update(update_data)
    return {"id": note_id, **update_data}

# DELETE /notes/{id}
@router.delete("/{note_id}")
def delete_note(note_id: str, user_id: str = Depends(get_current_user)):
    note_ref = db.collection("notes").document(note_id)
    doc = note_ref.get()
    if not doc.exists or doc.to_dict().get("userId") != user_id:
        raise HTTPException(status_code=404, detail="Note not found or not authorized")
    note_ref.delete()
    return {"message": "Note deleted successfully"}
