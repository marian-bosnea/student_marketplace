# 🎓 Student Marketplace

[![Flutter](https://img.shields.io/badge/Frontend-Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![BLoC](https://img.shields.io/badge/State%20Management-BLoC-546E7A?logo=google)](https://pub.dev/packages/flutter_bloc)
[![Node.js](https://img.shields.io/badge/Backend-Node.js-339933?logo=node.js&logoColor=white)](https://nodejs.org)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org)

A high-performance, cross-platform marketplace ecosystem designed for students. This project enables users to list items for sale and facilitates a complete buying experience with address management and order tracking.

---

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles, ensuring that the business logic is entirely decoupled from the UI and the data sources.



### 1. 🧠 Business Logic Layer (`student_marketplace_business_logic`)
A standalone, pure Dart package that acts as the "Engine" of the app.
* **Domain Layer:** Contains **Entities** and **Usecases** (the core business rules).
* **Data Layer:** Contains **Repositories** and **Models** (mapping JSON to Entities).
* **Key Modules:** Logic for `authentication`, `orders`, `sale_posts`, and `messaging`.

### 2. 📱 Presentation Layer (`student_marketplace_presentation`)
The Flutter application that interacts with the user.
* **BLoC Pattern:** Each feature is controlled by a dedicated Business Logic Component.
* **Feature-Driven UI:** Modular design where each folder (e.g., `create_order`, `detailed_post`) contains its own logic, widgets, and state management.
* **Multi-Platform:** Support for Android, iOS, macOS, Windows, and Web.

### 3. 🌐 Backend Layer (`student_marketplace_backend`)
A Node.js REST API serving as the central data hub.
* **Database:** **PostgreSQL** handles relational data for users, products, and transactions.
* **Storage:** Local filesystem handling for `uploads/avatars` and `uploads/sale_posts`.
* **Structure:** Organized by `controllers`, `routes`, and `db` for easy maintenance.

---

## 📁 Project Structure

```text
.
├── diagrams/                       # Documentation and ER Diagrams
├── student-marketplace-backend/    # Node.js + Express API
│   ├── src/
│   │   ├── controllers/            # Request logic
│   │   ├── db/                     # Postgres config & models
│   │   └── routes/                 # API Endpoints
│   └── uploads/                    # Product & Profile images
└── student-marketplace-frontend/
    ├── business_logic/             # Pure Dart Logic (Domain/Data layers)
    │   └── lib/domain/usecases/    # Business rules (orders, auth, etc.)
    └── presentation/               # Flutter App (UI/BLoC)
        └── lib/features/           # Individual UI modules
