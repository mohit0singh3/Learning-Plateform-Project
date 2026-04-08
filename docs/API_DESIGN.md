# REST API Design Documentation

## Base URL

```
http://localhost:8080/api
```

## Authentication

Most endpoints require authentication using JWT (JSON Web Token).

**Header Format:**
```
Authorization: Bearer <token>
```

---

## API Endpoints

### 1. Authentication APIs

#### 1.1 Register User

**Endpoint:** `POST /api/auth/register`

**Request Body:**
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "SecurePass123!",
  "fullName": "John Doe"
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "fullName": "John Doe",
  "role": "STUDENT",
  "createdAt": "2024-01-15T10:30:00"
}
```

**Error Responses:**
- `400 Bad Request`: Validation errors
- `409 Conflict`: Username or email already exists

---

#### 1.2 Login

**Endpoint:** `POST /api/auth/login`

**Request Body:**
```json
{
  "username": "john_doe",
  "password": "SecurePass123!"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "type": "Bearer",
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "fullName": "John Doe",
    "role": "STUDENT"
  }
}
```

**Error Responses:**
- `401 Unauthorized`: Invalid credentials
- `400 Bad Request`: Missing fields

---

### 2. User Management APIs

#### 2.1 Get Current User Profile

**Endpoint:** `GET /api/users/me`

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "fullName": "John Doe",
  "role": "STUDENT",
  "createdAt": "2024-01-15T10:30:00"
}
```

---

#### 2.2 Update User Profile

**Endpoint:** `PUT /api/users/me`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "fullName": "John Smith",
  "email": "johnsmith@example.com"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "johnsmith@example.com",
  "fullName": "John Smith",
  "role": "STUDENT",
  "updatedAt": "2024-01-15T11:00:00"
}
```

---

### 3. Project Management APIs

#### 3.1 Create Project

**Endpoint:** `POST /api/projects`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "name": "My First Project",
  "description": "Learning Java basics",
  "language": "java",
  "isPublic": false
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "name": "My First Project",
  "description": "Learning Java basics",
  "ownerId": 1,
  "language": "java",
  "isPublic": false,
  "createdAt": "2024-01-15T10:30:00"
}
```

---

#### 3.2 Get All Projects (for current user)

**Endpoint:** `GET /api/projects`

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `page` (optional): Page number (default: 0)
- `size` (optional): Page size (default: 10)
- `language` (optional): Filter by language

**Response (200 OK):**
```json
{
  "content": [
    {
      "id": 1,
      "name": "My First Project",
      "description": "Learning Java basics",
      "ownerId": 1,
      "language": "java",
      "isPublic": false,
      "createdAt": "2024-01-15T10:30:00"
    }
  ],
  "totalElements": 1,
  "totalPages": 1,
  "currentPage": 0
}
```

---

#### 3.3 Get Project by ID

**Endpoint:** `GET /api/projects/{projectId}`

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "My First Project",
  "description": "Learning Java basics",
  "ownerId": 1,
  "language": "java",
  "isPublic": false,
  "collaborators": [
    {
      "userId": 1,
      "username": "john_doe",
      "role": "OWNER"
    }
  ],
  "createdAt": "2024-01-15T10:30:00"
}
```

**Error Responses:**
- `404 Not Found`: Project not found
- `403 Forbidden`: User doesn't have access

---

#### 3.4 Update Project

**Endpoint:** `PUT /api/projects/{projectId}`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "name": "Updated Project Name",
  "description": "Updated description",
  "isPublic": true
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "Updated Project Name",
  "description": "Updated description",
  "ownerId": 1,
  "language": "java",
  "isPublic": true,
  "updatedAt": "2024-01-15T11:00:00"
}
```

---

#### 3.5 Delete Project

**Endpoint:** `DELETE /api/projects/{projectId}`

**Headers:** `Authorization: Bearer <token>`

**Response (204 No Content)**

**Error Responses:**
- `404 Not Found`: Project not found
- `403 Forbidden`: User is not the owner

---

#### 3.6 Add Collaborator to Project

**Endpoint:** `POST /api/projects/{projectId}/collaborators`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "username": "jane_doe",
  "role": "EDITOR"
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "projectId": 1,
  "userId": 2,
  "username": "jane_doe",
  "role": "EDITOR",
  "joinedAt": "2024-01-15T11:00:00"
}
```

---

### 4. Code File Management APIs

#### 4.1 Create/Update Code File

**Endpoint:** `PUT /api/projects/{projectId}/files`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "filename": "Main.java",
  "filePath": "/src/main/java/Main.java",
  "content": "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello World\");\n    }\n}",
  "language": "java"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "projectId": 1,
  "filename": "Main.java",
  "filePath": "/src/main/java/Main.java",
  "content": "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello World\");\n    }\n}",
  "language": "java",
  "lastModifiedBy": 1,
  "updatedAt": "2024-01-15T11:00:00"
}
```

---

#### 4.2 Get All Files in Project

**Endpoint:** `GET /api/projects/{projectId}/files`

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "projectId": 1,
    "filename": "Main.java",
    "filePath": "/src/main/java/Main.java",
    "language": "java",
    "updatedAt": "2024-01-15T11:00:00"
  }
]
```

---

#### 4.3 Get File Content

**Endpoint:** `GET /api/projects/{projectId}/files/{fileId}`

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "id": 1,
  "projectId": 1,
  "filename": "Main.java",
  "filePath": "/src/main/java/Main.java",
  "content": "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello World\");\n    }\n}",
  "language": "java",
  "lastModifiedBy": 1,
  "updatedAt": "2024-01-15T11:00:00"
}
```

---

#### 4.4 Delete File

**Endpoint:** `DELETE /api/projects/{projectId}/files/{fileId}`

**Headers:** `Authorization: Bearer <token>`

**Response (204 No Content)**

---

### 5. Learning APIs

#### 5.1 Get All Learning Topics

**Endpoint:** `GET /api/learning/topics`

**Headers:** `Authorization: Bearer <token>` (optional)

**Query Parameters:**
- `category` (optional): Filter by category
- `difficulty` (optional): Filter by difficulty level

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "title": "Object-Oriented Programming Basics",
    "description": "Learn about classes, objects, and inheritance",
    "category": "OOPs",
    "difficultyLevel": "BEGINNER",
    "orderIndex": 1
  }
]
```

---

#### 5.2 Get Exercises for Topic

**Endpoint:** `GET /api/learning/topics/{topicId}/exercises`

**Headers:** `Authorization: Bearer <token>` (optional)

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "topicId": 1,
    "title": "Create a Class",
    "description": "Create a simple class with attributes and methods",
    "starterCode": "public class Student {\n    // Your code here\n}",
    "difficulty": "BEGINNER",
    "orderIndex": 1
  }
]
```

---

#### 5.3 Get Exercise Details

**Endpoint:** `GET /api/learning/exercises/{exerciseId}`

**Headers:** `Authorization: Bearer <token>` (optional)

**Response (200 OK):**
```json
{
  "id": 1,
  "topicId": 1,
  "title": "Create a Class",
  "description": "Create a simple class with attributes and methods",
  "starterCode": "public class Student {\n    // Your code here\n}",
  "hints": [
    "Use the 'class' keyword",
    "Add private attributes",
    "Add public getter methods"
  ],
  "difficulty": "BEGINNER",
  "orderIndex": 1
}
```

---

#### 5.4 Submit Exercise Solution

**Endpoint:** `POST /api/learning/exercises/{exerciseId}/submit`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "code": "public class Student {\n    private String name;\n    public String getName() { return name; }\n}"
}
```

**Response (200 OK):**
```json
{
  "isCorrect": true,
  "feedback": "Great job! Your solution is correct.",
  "attempts": 1,
  "status": "COMPLETED"
}
```

---

#### 5.5 Get User Progress

**Endpoint:** `GET /api/learning/progress`

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
[
  {
    "exerciseId": 1,
    "exerciseTitle": "Create a Class",
    "status": "COMPLETED",
    "attempts": 1,
    "completedAt": "2024-01-15T11:00:00"
  }
]
```

---

### 6. AI Assistant APIs

#### 6.1 Get AI Code Suggestion

**Endpoint:** `POST /api/ai/suggest`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "code": "public class Main {\n    public static void main(String[] args) {\n        // TODO: print hello\n    }\n}",
  "context": "I want to print hello world",
  "type": "CODE_SUGGESTION"
}
```

**Response (200 OK):**
```json
{
  "suggestion": "System.out.println(\"Hello World\");",
  "explanation": "Use System.out.println() to print text to the console"
}
```

---

#### 6.2 Get Error Explanation

**Endpoint:** `POST /api/ai/explain-error`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "code": "public class Main {\n    public static void main(String[] args) {\n        System.out.println(x);\n    }\n}",
  "error": "cannot find symbol: variable x"
}
```

**Response (200 OK):**
```json
{
  "explanation": "The variable 'x' is not declared. You need to declare it before using it.",
  "fix": "int x = 10; // Declare the variable before using it"
}
```

---

#### 6.3 Get Concept Explanation

**Endpoint:** `POST /api/ai/explain-concept`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "concept": "inheritance",
  "context": "I'm learning OOPs"
}
```

**Response (200 OK):**
```json
{
  "explanation": "Inheritance is a mechanism where a new class inherits properties and methods from an existing class. In Java, use the 'extends' keyword.",
  "example": "class Animal { }\nclass Dog extends Animal { }"
}
```

---

#### 6.4 Get Exercise Hint

**Endpoint:** `POST /api/ai/hint`

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "exerciseId": 1,
  "userCode": "public class Student { }",
  "hintLevel": 1
}
```

**Response (200 OK):**
```json
{
  "hint": "Try adding private attributes to store student data like name and age."
}
```

---

## HTTP Status Codes

- `200 OK`: Successful GET, PUT requests
- `201 Created`: Successful POST requests (resource created)
- `204 No Content`: Successful DELETE requests
- `400 Bad Request`: Invalid request data/validation errors
- `401 Unauthorized`: Authentication required or invalid token
- `403 Forbidden`: User doesn't have permission
- `404 Not Found`: Resource not found
- `409 Conflict`: Resource conflict (e.g., duplicate username)
- `500 Internal Server Error`: Server error

## Error Response Format

```json
{
  "timestamp": "2024-01-15T11:00:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "path": "/api/auth/register",
  "errors": [
    {
      "field": "email",
      "message": "Email is required"
    }
  ]
}
```

## Pagination

For list endpoints, pagination is supported:

**Query Parameters:**
- `page`: Page number (0-indexed, default: 0)
- `size`: Page size (default: 10)
- `sort`: Sort field and direction (e.g., `createdAt,desc`)

**Response Format:**
```json
{
  "content": [...],
  "totalElements": 100,
  "totalPages": 10,
  "currentPage": 0,
  "size": 10
}
```
