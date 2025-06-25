# 🧪 Test Management App – Fullstack (Django + Flutter)

Une application complète de gestion de projets et de tâches, construite avec :
- 🛠️ **Backend** : Django REST Framework + JWT Auth
- 📱 **Frontend** : Flutter + Provider + Flutter Secure Storage

---

## ⚙️ Fonctionnalités principales

### 👤 Authentification (JWT)
- Inscription, connexion
- Stockage sécurisé du token
- Gestion centralisée via `AuthProvider`

### 📁 Gestion des projets
- Créer / modifier / supprimer un projet
- Visualiser la liste des projets
- Date de création affichée

### ✅ Gestion des tâches
- Liste des tâches par projet
- Création / édition avec :
  - titre, description, statut (TODO / IN_PROGRESS / DONE)
  - date d’échéance
  - utilisateur assigné automatiquement
- Suppression avec confirmation
- Icônes de statut colorées

---

## 🛠️ Technologies utilisées

### 🔙 Backend (Django)
- Django REST Framework
- JWT Auth (via `SimpleJWT`)
- Serializers, ViewSets, Permissions
- Endpoints :
  - `/api/auth/login/`, `/api/auth/register/`
  - `/api/projets/`, `/api/taches/`
- Auto-assignation de l’utilisateur connecté aux tâches

### 📱 Frontend (Flutter)
- Flutter 3+
- `provider` pour auth state global
- `flutter_secure_storage` pour JWT
- `http` pour les appels réseau
- `Material 3` UI, responsive, cards, dropdowns, pickers

---

## 🔐 Flux d’authentification

1. Connexion → token JWT stocké
2. Lancement → `SplashScreen` vérifie le token
3. Navigation conditionnelle vers `/projets` ou `/login`
4. Logout supprime les tokens et redirige

---

## 📂 Structure du code

### Backend Django :

```core/
├── models.py # User, Projet, Tache
├── serializers.py # UserSerializer, ProjetSerializer, TacheSerializer
├── views.py # ViewSets (Projet, Tache)
├── urls.py # routes API
```


### Frontend Flutter :

```
lib/
├── main.dart
├── models/
│ ├── projet.dart
│ └── tache.dart
├── screens/
│ ├── auth/
│ ├── projets/
│ ├── taches/
│ └── splash/
├── services/
│ └── api_service.dart
├── providers/
│ └── auth_provider.dart

```



---

## 📦 Installation

### 🔙 Backend
```bash
cd backend/
python -m venv env
source env/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

## 📱 Frontend
```bash
cd frontend/
flutter pub get
flutter run

```
