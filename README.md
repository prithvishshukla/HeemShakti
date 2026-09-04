# Polar Logistics — Integrated Expedition & Asset Management System

[![Flutter](https://img.shields.io/badge/Flutter-3.22+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.4+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.141+-009688?logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python&logoColor=white)](https://python.org)
[![SQLite](https://img.shields.io/badge/Database-SQLite3-003B57?logo=sqlite&logoColor=white)](https://sqlite.org)
[![OpenStreetMap](https://img.shields.io/badge/Maps-OpenStreetMap-7EAC33?logo=openstreetmap&logoColor=white)](https://www.openstreetmap.org)

![HeemShakti project icon](polar_logistics_android/assets/icon/app_icon.png)

This is the official HeemShakti project icon.

An enterprise-grade cross-platform mobile application and backend API system developed for the **National Centre for Polar and Ocean Research (NCPOR)**, Ministry of Earth Sciences, India. 

**Polar Logistics** (Project **HeemShakti** / SIH26062) provides real-time tracking, asset management, cargo inventory oversight, personnel deployment monitoring, interactive expedition mapping, and live operational analytics across remote Antarctic research stations (such as *Maitri* and *Bharati*).

---

## 🌟 Key Features

### 1. 🔐 Dual-Role Authentication & Access Control
- **NCPOR Administrator Portal**: High-level control center for full operational management, user account provisioning, asset tracking, and analytics.
- **Expedition Member Portal**: Operational view for field personnel to check active assignments, assigned cargo, tasks, and emergency contacts.
- **Role-Based Security Gate (`AuthGate`)**: Automatic re-validation of account status and active sessions on every screen rebuild. Deactivated accounts are blocked instantly.
- **Cryptographic Security**: Salted SHA-256 password hashing stored locally in fast NoSQL key-value store (`Hive`). Raw passwords are never persisted.
- **Session Persistence**: Automated session restoration across app restarts using `SharedPreferences`.

### 2. 🗺️ Interactive Expedition Mapping & GIS
- **Live Station & Expedition Map**: Powered by `flutter_map` (v7.0) and OpenStreetMap tiles.
- **Station Markers**: Interactive visual markers for Antarctic research stations (*Maitri Station*, *Bharati Station*).
- **Route Tracking**: View live coordinates, route statuses, and destination markers for ongoing expeditions.

### 3. 📦 Cargo & Inventory Tracking
- **Inventory Availability Analytics**: Custom-painted interactive Donut Chart visualizing available vs. unavailable inventory ratios.
- **Shipment Lifecycle**: Track status across `Pending`, `In Transit`, and `Delivered` stages.
- **Categorized Inventory**: Medical supplies, research equipment, food provisions, fuel containers, clothing, and communication gear.

### 4. 👥 Personnel & User Account Management
- **Personnel Records**: Role assignment (Expedition Leader, Research Scientist, Logistics Officer, Engineer, Medical Officer, Crew Member) and station assignment.
- **Admin User Management**: Complete CRUD interface for administrators to create expedition accounts, update details, reset passwords, and toggle active/inactive states.

### 5. 🚜 Transport Vehicles & Asset Oversight
- **Polar Vehicles & Field Equipment**: Track snow vehicles, ATVs, transport trucks, field generators, and satellite units.
- **Maintenance & Availability**: Real-time status indicators (`Available`, `In Use`, `Maintenance`, `Out of Service`).

### 6. 📊 Real-Time Analytics & Operational Reports
- **Dynamic Backend Reports**: Integrated REST communication connecting Flutter frontend to FastAPI `/reports/summary`.
- **Live Metrics**: Automatically aggregates total records, pending cargo, delivered items, active personnel percentages, and inventory availability.
- **Pull-To-Refresh**: Live data synchronization with the backend database.

---

## 🏗️ System Architecture

The project consists of a modern, decoupled full-stack architecture:

```
                  +-----------------------------------+
                  |   Polar Logistics Mobile App      |
                  |     (Flutter / Dart - M3 UI)      |
                  +-----------------+-----------------+
                                    |
          +-------------------------+-------------------------+
          |                                                   |
          v                                                   v
+-------------------+                               +-------------------+
|  Local Hive Store |                               |  FastAPI Backend  |
| (Auth & Sessions) |                               |    (HeemShakti)   |
+-------------------+                               +---------+---------+
                                                              |
                                                              v
                                                    +-------------------+
                                                    | SQLite Database   |
                                                    |  (heemshakti.db)  |
                                                    +-------------------+
```

---

## 📂 Project Directory Structure

```
SIH26062/
├── polar_logistics_android/          # Flutter Mobile Application
│   ├── android/                      # Native Android configuration
│   ├── ios/                          # Native iOS configuration
│   ├── lib/
│   │   ├── main.dart                 # App entry point, session gate, theme definitions
│   │   ├── models/
│   │   │   ├── report_model.dart     # Analytics & report JSON serialization models
│   │   │   └── user_model.dart       # User role & authentication account models
│   │   ├── repositories/
│   │   │   └── user_repository.dart  # Hive local storage repository for accounts & admin bootstrap
│   │   ├── screens/
│   │   │   ├── start_menu.dart       # Gateway screen with dual login selection
│   │   │   ├── admin/                # Admin-only management views
│   │   │   │   ├── admin_dashboard.dart           # NCPOR main control center
│   │   │   │   ├── cargo_page.dart                # Cargo & donut inventory availability chart
│   │   │   │   ├── expeditions_page.dart          # Interactive FlutterMap & expedition list
│   │   │   │   ├── manage_expedition_users_page.dart # Account provisioning & active toggle
│   │   │   │   ├── personnel_page.dart            # Personnel deployment list
│   │   │   │   ├── reports_page.dart              # Live backend analytics dashboard
│   │   │   │   └── transport_assets_page.dart     # Vehicles & equipment tracking
│   │   │   ├── auth/                 # Authentication screens
│   │   │   │   ├── admin_login_page.dart          # Admin authentication form
│   │   │   │   └── expedition_login_page.dart     # Expedition team login form
│   │   │   └── expedition/           # Field team screens
│   │   │       └── expedition_dashboard.dart     # Field operational dashboard
│   │   ├── services/
│   │   │   ├── api_service.dart      # REST API client connecting to FastAPI backend
│   │   │   ├── auth_gate.dart        # Guard widget for route protection and status verification
│   │   │   ├── auth_service.dart     # Authentication logic, credentials verification
│   │   │   ├── password_hasher.dart  # SHA-256 password hashing with salt
│   │   │   └── session_service.dart  # SharedPreferences session persistence
│   │   └── widgets/
│   │       ├── dashboard_widgets.dart# Reusable dashboard UI cards and stat widgets
│   │       └── login_field.dart      # Styled input fields with validation
│   └── pubspec.yaml                  # Flutter dependencies and app assets configuration
│
└── heemshakti_backend/               # Python FastAPI REST Backend
    ├── main.py                       # FastAPI application entry point & Expedition endpoints
    ├── personnel_cargo.py            # SQLite database models & routes for Personnel & Cargo
    ├── reports.py                    # Analytics aggregator endpoints (/reports/summary)
    ├── heemshakti.db                 # Persistent SQLite database file
    └── requirements.txt              # Python package requirements
```

---

## 🛠️ Tech Stack & Dependencies

### Frontend (Mobile App)
- **Framework**: [Flutter SDK](https://flutter.dev) (Dart `>=3.4.0 <4.0.0`)
- **UI Design System**: Material 3 with Custom "Polar Ice" Palette
- **Local Database**: `hive` (v2.2.3) & `hive_flutter` (v1.1.0)
- **Session Management**: `shared_preferences` (v2.3.2)
- **Maps & GIS**: `flutter_map` (v7.0.2) & `latlong2` (v0.9.1)
- **Security & Utilities**: `crypto` (v3.0.5) for SHA-256 hashing, `uuid` (v4.4.2)
- **HTTP Client**: `http` (v1.2.2)

### Backend (REST API)
- **Framework**: [FastAPI](https://fastapi.tiangolo.com) (v0.141.1)
- **Server**: [Uvicorn](https://www.uvicorn.org) (v0.52.4)
- **Validation**: [Pydantic](https://docs.pydantic.dev) (v2.13.5)
- **Database**: SQLite3 (Native Python file-backed persistence)

---

## 🎨 Design System & Color Palette

The app features a custom ice-themed color palette designed specifically for polar operational environments:

| Color Token | Hex Code | Visual Preview | Usage |
| :--- | :--- | :--- | :--- |
| `polarVeryLight` | `#E3F2FD` | `■` Light Ice Blue | App scaffold background |
| `polarLight` | `#90CAF9` | `■` Glacier Blue | Card borders and input outlines |
| `polarBlue` | `#2196F3` | `■` Arctic Blue | Primary action buttons and map badges |
| `polarDark` | `#1565C0` | `■` Deep Ocean Blue | App bars and key navigation headers |
| `polarDeep` | `#0D47A1` | `■` Polar Deep Blue | Headlines, text, and critical iconography |
| `cargoLightBlue` | `#38BDF8` | `■` Available Blue | Chart legend for available cargo |
| `cargoViolet` | `#8B5CF6` | `■` Violet | Chart legend for unavailable cargo |

---

## 📡 REST API Documentation

The **HeemShakti FastAPI Backend** exposes the following RESTful endpoints:

### 1. Expeditions (`/expeditions`)
- `GET /expeditions`: Retrieve all recorded polar expeditions.
- `GET /expeditions/{id}`: Fetch detailed record for a specific expedition.
- `POST /expeditions`: Register a new polar expedition.
- `PUT /expeditions/{id}`: Update expedition parameters.
- `DELETE /expeditions/{id}`: Remove an expedition entry.

### 2. Personnel (`/personnel`)
- `GET /personnel`: List all registered station and field personnel.
- `GET /personnel/{id}`: Get specific personnel details.
- `POST /personnel`: Add a new personnel profile to SQLite database.
- `PUT /personnel/{id}`: Modify personnel station or deployment status.
- `DELETE /personnel/{id}`: Delete a personnel record.

### 3. Cargo & Inventory (`/cargo`)
- `GET /cargo`: Retrieve all cargo items and availability quantities.
- `GET /cargo/{id}`: Fetch specific cargo record.
- `POST /cargo`: Record new cargo dispatch.
- `PUT /cargo/{id}`: Update cargo availability and transport status.
- `DELETE /cargo/{id}`: Remove cargo entry.

### 4. Live Analytics Reports (`/reports`)
- `GET /reports/summary`: Aggregate live breakdown of personnel status, cargo delivery states, and inventory availability percentages.
- `GET /reports/personnel`: Detailed role distribution and active status counts.
- `GET /reports/cargo`: Category distribution and transport stage breakdown.

---

## 🚀 Getting Started & Installation

### Prerequisites
- **Flutter SDK**: `>= 3.22.0`
- **Dart SDK**: `>= 3.4.0`
- **Python**: `>= 3.10`
- **Android Studio / VS Code** with Flutter extensions installed
- **Android Device / Emulator** (API Level 21+)

---

### Step 1: Set Up the FastAPI Backend

1. Navigate to the backend directory:
   ```bash
   cd heemshakti_backend
   ```

2. Create and activate a Python virtual environment:
   ```bash
   python -m venv venv
   # Windows:
   venv\Scripts\activate
   # Linux/macOS:
   source venv/bin/activate
   ```

3. Install required Python packages:
   ```bash
   pip install -r requirements.txt
   ```

4. Start the Uvicorn server:
   ```bash
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   ```

   The backend will launch at `http://localhost:8000`. Automatic Interactive API Documentation is available at `http://localhost:8000/docs`.

---

### Step 2: Configure & Run the Flutter Mobile App

1. Navigate to the Flutter app directory:
   ```bash
   cd polar_logistics_android
   ```

2. Configure Backend Host IP in `lib/services/api_service.dart`:
   Update `baseUrl` with your machine's IP address (or `10.0.2.2` for default Android emulator):
   ```dart
   static const String baseUrl = 'http://<YOUR_LOCAL_IP>:8000';
   ```

3. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

4. Launch the application:
   ```bash
   flutter run
   ```

---

## 🔑 Initial Credentials (Bootstrap Admin Account)

On the very first launch, the local database automatically seeds the default NCPOR System Administrator account:

- **Login Portal**: `LOGIN — NCPOR / ADMIN`
- **Username**: `admin`
- **Password**: `Ncpor@2026`

> **Note**: Administrators can create new Expedition Member accounts and update credentials directly through the **Manage Expedition Users** panel in the app.

---

## 🧪 Testing & Verification

Run the Flutter test suite to verify UI components and core application logic:

```bash
flutter test
```

To run static analysis and lint checks:

```bash
flutter analyze
```

---

## 📄 License & Acknowledgments

Developed for the **Smart India Hackathon (SIH 2026)** — Problem Statement **SIH26062**.
Dedicated to the **National Centre for Polar and Ocean Research (NCPOR)**, Ministry of Earth Sciences, Government of India.

---
# HeemShakti 
