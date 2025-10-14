# StageBridge 🪄

> A full-stack monorepo integrating **NestJS (backend)** and **React (frontend)** with **PostgreSQL**, managed via Docker Compose.

---

## 📂 Project Structure



stagebridge/
├── backend/ # NestJS backend (submodule)
├── frontend/ # React frontend (submodule)
├── .env.example # Environment variable template
├── docker-compose.yml # Multi-container configuration
└── README.md # Project documentation


---

## ⚙️ Setup & Run

### 1️⃣ Clone with Submodules
```bash
git clone --recurse-submodules git@github.com:stagebridge/stagebridge.git
cd stagebridge

2️⃣ Configure Environment
cp .env.example .env


Edit .env for your database and server configuration.

3️⃣ Start the Application
docker-compose up --build


✅ Backend (NestJS) → http://localhost:3000

✅ Frontend (React) → http://localhost:5173

✅ Database (PostgreSQL) → localhost:5432