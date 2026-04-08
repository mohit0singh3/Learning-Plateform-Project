# CodeSphere – Real-Time Collaborative Coding and Interactive Learning Platform

## 📋 Project Overview

A full-stack platform enabling multiple users to collaboratively write code in real-time, learn programming concepts interactively, and receive AI-powered guidance while coding.

## 🏗️ System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Frontend (React)                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Auth UI    │  │ Code Editor  │  │ Learning UI  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ HTTP/REST API
                            │ WebSocket (Real-time)
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   Backend (Spring Boot)                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Controllers  │  │   Services   │  │ Repositories │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │     DTOs     │  │   Security   │  │   WebSocket  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ JDBC/JPA
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    Database (MySQL)                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │    Users     │  │   Projects   │  │   Sessions   │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### Architecture Layers

1. **Presentation Layer (React Frontend)**
   - User interface components
   - State management
   - API communication
   - WebSocket client for real-time updates

2. **Controller Layer (Spring Boot)**
   - REST API endpoints
   - Request/Response handling
   - Input validation
   - HTTP status code management

3. **Service Layer (Spring Boot)**
   - Business logic
   - Transaction management
   - AI integration logic
   - Real-time collaboration logic

4. **Repository Layer (Spring Boot)**
   - Database operations
   - JPA/Hibernate queries
   - Data access abstraction

5. **Database Layer (MySQL)**
   - Data persistence
   - Relationships and constraints

## 🗄️ Database Schema

### Tables Overview

1. **users** - User accounts and authentication
2. **projects** - Code projects/sessions
3. **project_collaborators** - Many-to-many relationship between users and projects
4. **code_files** - Files within projects
5. **learning_topics** - Available learning topics
6. **exercises** - Coding exercises for learning
7. **user_progress** - Track user learning progress
8. **ai_interactions** - Log AI assistant interactions

See `docs/DATABASE_SCHEMA.md` for detailed schema.

## 🚀 Tech Stack

- **Frontend**: HTML, CSS, JavaScript, React.js
- **Backend**: Java, Spring Framework, Spring Boot
- **Database**: MySQL
- **Tools**: GitHub, Postman
- **DevOps**: Docker

## 📁 Project Structure

```
Learning Platform/
├── backend/                 # Spring Boot backend
│   ├── src/
│   │   └── main/
│   │       ├── java/
│   │       │   └── com/cursorai/
│   │       │       ├── controller/
│   │       │       ├── service/
│   │       │       ├── repository/
│   │       │       ├── model/
│   │       │       ├── dto/
│   │       │       ├── config/
│   │       │       └── CursorAiApplication.java
│   │       └── resources/
│   │           ├── application.properties
│   │           └── application.yml
│   ├── pom.xml
│   └── Dockerfile
├── frontend/               # React frontend
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── utils/
│   │   └── App.js
│   ├── package.json
│   └── Dockerfile
├── docker-compose.yml      # Docker orchestration
├── docs/                   # Documentation
└── README.md

```

## 🛠️ Setup Instructions

### Prerequisites
- Java 17+
- Node.js 16+
- Docker & Docker Compose
- MySQL 8.0+ (or use Docker)

### Quick Start with Docker

```bash
# Clone the repository
git clone <your-repo-url>
cd "Learning Platform"

# Start all services
docker-compose up -d

# Backend will run on http://localhost:8080
# Frontend will run on http://localhost:3000
# MySQL will run on localhost:3306
```

### Manual Setup

See `docs/SETUP_GUIDE.md` for detailed manual setup instructions.

## 📚 API Documentation

See `docs/API_DESIGN.md` for complete API endpoint documentation.

## 🧪 Testing

- **Backend**: Use Postman to test REST APIs
- **Frontend**: Manual testing in browser
- **Database**: MySQL Workbench or command line

## 📖 Development Plan

See `docs/DEVELOPMENT_PLAN.md` for step-by-step development guide.

## 👥 Contributing

This is a portfolio/final-year project. Follow the coding standards and architecture patterns defined in the documentation.

## 📝 License

Educational/Portfolio Project
