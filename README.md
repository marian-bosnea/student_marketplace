# 🎓 Student Marketplace

[![Flutter](https://img.shields.io/badge/Frontend-Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![BLoC](https://img.shields.io/badge/State%20Management-BLoC-546E7A?logo=google)](https://pub.dev/packages/flutter_bloc)
[![Node.js](https://img.shields.io/badge/Backend-Node.js-339933?logo=node.js&logoColor=white)](https://nodejs.org)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org)

**A secure peer-to-peer commerce platform designed for the university ecosystem.**

This application enables students to list items for sale and facilitates a full checkout experience where student buyers can place orders delivered directly to their campus or residential addresses.

---

## ✨ Key Features

* **🛡️ Student Authentication:** Verified access via university email domains.
* **📦 Sell Items:** Easy-to-use interface for listing textbooks, furniture, or electronics.
* **🛒 Ordering System:** Complete checkout flow allowing buyers to specify delivery/pickup addresses.
* **⚡ BLoC Architecture:** Predictable state management for a smooth, glitch-free UI.
* **📊 Relational Data:** Robust PostgreSQL backend ensuring data integrity for transactions and orders.

---

## 🛠️ Tech Stack

### Frontend
* **Framework:** Flutter
* **State Management:** BLoC (Business Logic Component)
* **Networking:** Dio / Http

### Backend
* **Runtime:** Node.js (Express.js)
* **Database:** PostgreSQL
* **ORM:** Sequelize or TypeORM



---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* [Node.js](https://nodejs.org/) (v16+)
* [PostgreSQL](https://www.postgresql.org/download/)

### 1. Database Setup
1. Create a new PostgreSQL database.
2. Configure your connection string in the backend `.env` file.

### 2. Backend Setup
```bash
cd server
npm install
# Configure DB_USER, DB_PASSWORD, DB_NAME in .env
npm run dev
