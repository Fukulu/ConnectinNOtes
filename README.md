# 📝 ConnectInnoCase – Notes App

A **Flutter Notes Application** powered by **Cubit (flutter_bloc)** on the frontend and **FastAPI + Firebase Firestore** on the backend.
- 🔑 Authentication via **Firebase Auth**
- 🗄 Offline-first storage with **Hive**
- ☁️ Online sync with **Firestore**

---

## 📂 Project Structure

```text
connectinnocase/
│
├── lib/                    # Flutter app
│   ├── presentation/       # UI pages (NotesPage, NoteEditPage, SignInPage, SignUpPage)
│   ├── cubit/              # Cubits (NotesCubit, AuthCubit)
│   ├── domain/             # Entities, UseCases, Repository interfaces
│   ├── data/               # Repository implementations + Local & Remote datasources
│   └── core/               # Shared utilities (Result, NetworkInfo, etc.)
│
└── backend/                # FastAPI backend
    ├── main.py             # FastAPI entrypoint
    ├── routes/notes.py     # Notes CRUD endpoints
    ├── services/           # Firebase service connection
    ├── models.py           # Pydantic models
    └── .env                # Firebase Admin SDK credentials
```

---

## 🚀 Getting Started

### 1. Requirements
- Flutter SDK (>=3.0)
- Python 3.11 + pip
- Firebase project (Auth + Firestore enabled)
- Node.js + Firebase CLI

---

### 2. Flutter Setup
cd connectinnocase
flutter pub get

.env for Flutter:
FIREBASE_API_KEY=xxx
FIREBASE_PROJECT_ID=xxx
FIREBASE_APP_ID=xxx
FIREBASE_MESSAGING_SENDER_ID=xxx

flutter run

### 3. Backend Setup

```
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```

.env for backend:
```
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_CLIENT_EMAIL=your_service_account_email
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEv...snip...\n-----END PRIVATE KEY-----\n"
```

### 4. Open API docs:
👉 http://127.0.0.1:8000/docs

### 5. Firestore Security Rules

```
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == resource.data.userId;
    }
  }
}
```

### 6. Screenshots

<p align="center">
  <img src="assets/screenshots/signin.png" width="200"/>
  <img src="assets/screenshots/signup.png" width="200"/>
  <img src="assets/screenshots/notes.png" width="200"/>
  <img src="assets/screenshots/edit.png" width="200"/>
</p>