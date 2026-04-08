# Setup Guide

## Prerequisites

- Java 17 or higher
- Node.js 16+ and npm
- MySQL 8.0+ (or use Docker)
- Maven 3.6+
- Docker & Docker Compose (optional)

## Quick Start with Docker

```bash
# Clone repository
git clone <your-repo-url>
cd "Learning Platform"

# Start all services
docker-compose up -d

# Backend: http://localhost:8080
# Frontend: http://localhost:3000
# MySQL: localhost:3306
```

## Manual Setup

### Backend Setup

1. **Navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Update database configuration** in `src/main/resources/application.yml`:
   ```yaml
   spring:
     datasource:
       url: jdbc:mysql://localhost:3306/cursor_ai_db
       username: your_username
       password: your_password
   ```

3. **Create MySQL database**
   ```sql
   CREATE DATABASE cursor_ai_db;
   ```

4. **Run database migration**
   ```bash
   mysql -u root -p cursor_ai_db < src/main/resources/db/migration/schema.sql
   ```

5. **Build and run**
   ```bash
   mvn clean install
   mvn spring-boot:run
   ```

### Frontend Setup

1. **Navigate to frontend directory**
   ```bash
   cd frontend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start development server**
   ```bash
   npm start
   ```

4. **Access application**
   - Open http://localhost:3000

## Testing APIs with Postman

1. **Register User**
   - POST http://localhost:8080/api/auth/register
   - Body: `{"username":"test","email":"test@test.com","password":"password123","fullName":"Test User"}`

2. **Login**
   - POST http://localhost:8080/api/auth/login
   - Body: `{"username":"test","password":"password123"}`
   - Copy the token from response

3. **Create Project**
   - POST http://localhost:8080/api/projects
   - Header: `Authorization: Bearer <token>`
   - Body: `{"name":"My Project","description":"Test","language":"java"}`

## Troubleshooting

- **Port conflicts**: Change ports in docker-compose.yml or application.yml
- **Database connection**: Verify MySQL is running and credentials are correct
- **CORS errors**: Check CORS configuration in SecurityConfig.java
