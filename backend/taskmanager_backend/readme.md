# TaskManager - Backend Django REST

Une API sécurisée pour gérer des projets et des tâches personnelles, avec authentification JWT. Ce backend fait partie du test technique Django/Flutter.

---

## ⚙️ Fonctionnalités

- Authentification JWT (login, register, refresh)
- CRUD sécurisé pour :
  - Projets (par utilisateur)
  - Tâches (liées aux projets)
- Sérialisation imbriquée (nested)
- Permissions par utilisateur
- Documentation Swagger & Redoc

---

## 🚀 Lancement rapide

### 1. Cloner le repo

```bash
git clone https://github.com/votre-utilisateur/taskmanager-backend.git
cd taskmanager-backend



## a modier
2. Créer un environnement virtuel
bash
Copier
Modifier
python -m venv env
source env/bin/activate  # ou env\Scripts\activate sur Windows
3. Installer les dépendances
bash
Copier
Modifier
pip install -r requirements.txt
4. Configurer la base de données
Par défaut, SQLite est utilisé. Pour PostgreSQL, modifiez settings.py.

5. Appliquer les migrations
bash
Copier
Modifier
python manage.py migrate
6. Créer un superutilisateur (facultatif)
bash
Copier
Modifier
python manage.py createsuperuser
7. Lancer le serveur
bash
Copier
Modifier
python manage.py runserver
🔐 Endpoints d'authentification
Méthode	URL	Description
POST	/api/auth/register/	Créer un compte
POST	/api/auth/login/	Obtenir un token JWT
POST	/api/auth/refresh/	Rafraîchir le token

📡 Endpoints API
/api/projets/ – Liste & CRUD des projets

/api/taches/ – Liste & CRUD des tâches (liées aux projets de l'utilisateur)

⚠️ Tous les endpoints nécessitent un token JWT (Authorization: Bearer <votre_token>)

📚 Documentation API
Swagger : http://localhost:8000/swagger/

Redoc : http://localhost:8000/redoc/

📦 Structure du projet
bash
Copier
Modifier
taskmanager_backend/
│
├── core/                # App principale (modèles, vues, urls, etc.)
├── taskmanager_backend/ # Fichiers de configuration Django
├── manage.py
├── requirements.txt
└── README.md

📌 Installation en une commande
bash
Copier
Modifier
pip install -r requirements.txt