# System Architecture Explanation

## Overview

This document explains the high-level architecture of the CodeSphere platform in simple, student-friendly terms.

## What is MVC Architecture?

**MVC** stands for **Model-View-Controller**. It's a design pattern that separates concerns:

- **Model**: Represents data and business logic (Entities, DTOs)
- **View**: User interface (React components)
- **Controller**: Handles user input and coordinates between Model and View (REST Controllers)

## Backend Architecture (Spring Boot)

### Layer Structure

```
┌─────────────────────────────────────┐
│      Controller Layer               │  ← Handles HTTP requests/responses
│  (REST API Endpoints)               │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Service Layer                  │  ← Business logic
│  (Business Operations)              │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Repository Layer               │  ← Database operations
│  (Data Access)                      │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Database (MySQL)               │  ← Data storage
└─────────────────────────────────────┘
```

### 1. Controller Layer (`com.cursorai.controller`)

**Purpose**: Handle HTTP requests and responses

**Responsibilities**:
- Receive HTTP requests from frontend
- Validate input data
- Call appropriate service methods
- Return HTTP responses with proper status codes

**Example**: `AuthController`
- `POST /api/auth/register` → Calls `AuthService.register()`
- `POST /api/auth/login` → Calls `AuthService.login()`

### 2. Service Layer (`com.cursorai.service`)

**Purpose**: Implement business logic

**Responsibilities**:
- Process business rules
- Coordinate between repositories
- Handle transactions
- Transform data between entities and DTOs

**Example**: `AuthService`
- Validates user doesn't exist
- Hashes password
- Creates user entity
- Generates JWT token

### 3. Repository Layer (`com.cursorai.repository`)

**Purpose**: Database operations

**Responsibilities**:
- CRUD operations (Create, Read, Update, Delete)
- Custom queries
- Data persistence

**Example**: `UserRepository`
- `findByUsername()` → Query database for user
- `save()` → Save user to database

### 4. Model Layer (`com.cursorai.model`)

**Purpose**: Represent database tables as Java objects

**Example**: `User` entity maps to `users` table in MySQL

### 5. DTO Layer (`com.cursorai.dto`)

**Purpose**: Transfer data between layers without exposing entity details

**Why DTOs?**
- Security: Don't expose internal entity structure
- Flexibility: Can shape data differently for different endpoints
- Performance: Only send needed data

## Frontend Architecture (React)

### Component Structure

```
App.js
├── AuthProvider (Context)
├── Router
│   ├── Login Page
│   ├── Register Page
│   ├── Dashboard Page
│   │   └── Project Cards
│   ├── Project View Page
│   │   └── Code Editor Component
│   └── Learning Pages
│       └── Exercise Components
└── Navbar Component
```

### Key Concepts

1. **Components**: Reusable UI pieces (e.g., `Navbar`, `ProjectCard`)
2. **Pages**: Full page views (e.g., `Dashboard`, `Login`)
3. **Context**: Global state management (`AuthContext`)
4. **Services**: API communication (`api.js`)

## Data Flow

### User Registration Flow

```
1. User fills form → React Component
2. Component calls → AuthContext.register()
3. AuthContext calls → api.post('/auth/register')
4. HTTP Request → Spring Boot Backend
5. AuthController receives → Validates input
6. AuthController calls → AuthService.register()
7. AuthService calls → UserRepository.save()
8. Database saves → User entity
9. AuthService generates → JWT token
10. Response flows back → Frontend receives token
11. Token stored → localStorage
12. User redirected → Dashboard
```

## Security Flow

### JWT Authentication

1. **Login**: User provides credentials
2. **Backend validates**: Checks username/password
3. **Token generated**: JWT token created with username
4. **Token sent**: Frontend receives token
5. **Token stored**: Saved in localStorage
6. **Token attached**: Added to all API requests (Authorization header)
7. **Backend validates**: Checks token on each request
8. **Access granted**: If valid, request proceeds

## Real-Time Collaboration (WebSocket)

### How It Works

1. **Connection**: User opens project → WebSocket connection established
2. **Code Change**: User types → Change sent via WebSocket
3. **Broadcast**: Server receives change → Broadcasts to all connected users
4. **Update**: Other users receive → Code editor updates

### Implementation (Future)

- Backend: Spring WebSocket
- Frontend: Socket.io client
- Message Types: Code changes, cursor positions, user presence

## Database Relationships

### One-to-Many
- **User** → **Projects** (One user owns many projects)
- **Project** → **CodeFiles** (One project has many files)

### Many-to-Many
- **Users** ↔ **Projects** (Many users collaborate on many projects)
- Implemented via: `project_collaborators` junction table

## Why This Architecture?

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Maintainability**: Easy to find and fix bugs
3. **Scalability**: Can scale each layer independently
4. **Testability**: Can test each layer separately
5. **Security**: Centralized authentication/authorization

## Learning Points

- **REST APIs**: Standard way to communicate between frontend and backend
- **JWT Tokens**: Secure way to authenticate users without storing sessions
- **Repository Pattern**: Abstraction layer for database operations
- **DTO Pattern**: Clean way to transfer data between layers
- **Component-Based UI**: React's approach to building user interfaces

## Next Steps

1. Understand each layer's responsibility
2. Trace a request through all layers
3. Add new features following the same pattern
4. Practice writing tests for each layer
