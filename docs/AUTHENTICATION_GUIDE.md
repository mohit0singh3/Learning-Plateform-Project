# Authentication System Guide

## Overview

The authentication system uses **JWT (JSON Web Tokens)** for stateless authentication. This guide explains how it works and how to use it.

## Components

### 1. JwtUtil (`com.cursorai.util.JwtUtil`)
- Generates JWT tokens
- Validates tokens
- Extracts username from tokens

### 2. JwtAuthenticationFilter (`com.cursorai.security.JwtAuthenticationFilter`)
- Intercepts all HTTP requests
- Extracts JWT token from Authorization header
- Validates token and sets authentication in Spring Security context

### 3. CustomUserDetailsService (`com.cursorai.security.CustomUserDetailsService`)
- Loads user details for Spring Security
- Converts User entity to UserDetails

### 4. SecurityConfig (`com.cursorai.config.SecurityConfig`)
- Configures Spring Security
- Sets up password encoding (BCrypt)
- Configures CORS
- Adds JWT filter to filter chain

### 5. AuthService (`com.cursorai.service.AuthService`)
- Handles registration logic
- Handles login logic
- Generates JWT tokens

## Authentication Flow

### Registration Flow

```
1. Client sends POST /api/auth/register
   {
     "username": "john",
     "email": "john@example.com",
     "password": "password123",
     "fullName": "John Doe"
   }

2. AuthController receives request
3. AuthService.register() is called
   - Validates username/email don't exist
   - Hashes password with BCrypt
   - Saves user to database
   - Generates JWT token
4. Response sent with token:
   {
     "token": "eyJhbGciOiJIUzI1NiIs...",
     "type": "Bearer",
     "user": { ... }
   }
```

### Login Flow

```
1. Client sends POST /api/auth/login
   {
     "username": "john",
     "password": "password123"
   }

2. AuthController receives request
3. AuthService.login() is called
   - Finds user by username
   - Verifies password with BCrypt
   - Generates JWT token
4. Response sent with token
```

### Protected Endpoint Flow

```
1. Client sends request with token:
   GET /api/users/me
   Header: Authorization: Bearer <token>

2. JwtAuthenticationFilter intercepts request
   - Extracts token from header
   - Validates token
   - Loads user details
   - Sets authentication in SecurityContext

3. Controller receives authenticated request
   - Can access current user via Authentication parameter

4. Response sent
```

## API Endpoints

### Public Endpoints (No Authentication Required)

- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/learning/topics/**` - Get learning topics
- `GET /api/learning/exercises/**` - Get exercises

### Protected Endpoints (Authentication Required)

- `GET /api/users/me` - Get current user profile
- `PUT /api/users/me` - Update current user profile
- All `/api/projects/**` endpoints
- All other `/api/**` endpoints

## Using Authentication in Controllers

### Get Current User

```java
@GetMapping("/me")
public ResponseEntity<?> getCurrentUser(Authentication authentication) {
    String username = authentication.getName();
    // Use username to fetch user details
}
```

### Using SecurityUtils

```java
import com.cursorai.util.SecurityUtils;

String username = SecurityUtils.getCurrentUsername();
boolean isAuthenticated = SecurityUtils.isAuthenticated();
```

## Frontend Integration

### Storing Token

```javascript
// After login/register
localStorage.setItem('token', response.data.token);
```

### Sending Token with Requests

```javascript
// Using axios
axios.get('/api/users/me', {
  headers: {
    'Authorization': `Bearer ${localStorage.getItem('token')}`
  }
});
```

### Automatic Token Attachment

The frontend `api.js` service automatically adds the token:

```javascript
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

## Password Security

- **BCrypt** is used for password hashing
- Passwords are never stored in plain text
- BCrypt automatically handles salting

## Token Security

- Tokens expire after 24 hours (configurable in `application.yml`)
- Secret key should be changed in production
- Tokens are stateless (no server-side storage)

## Error Handling

### Common Errors

1. **401 Unauthorized**
   - Invalid or expired token
   - Missing Authorization header

2. **409 Conflict**
   - Username or email already exists (registration)

3. **400 Bad Request**
   - Validation errors
   - Invalid request format

### Error Response Format

```json
{
  "timestamp": "2024-01-15T10:30:00",
  "status": 400,
  "message": "Validation failed",
  "errors": {
    "email": "Email is required",
    "password": "Password must be at least 6 characters"
  }
}
```

## Testing with Postman

1. **Register User**
   ```
   POST http://localhost:8080/api/auth/register
   Body (JSON):
   {
     "username": "testuser",
     "email": "test@example.com",
     "password": "password123",
     "fullName": "Test User"
   }
   ```

2. **Login**
   ```
   POST http://localhost:8080/api/auth/login
   Body (JSON):
   {
     "username": "testuser",
     "password": "password123"
   }
   Copy the token from response
   ```

3. **Access Protected Endpoint**
   ```
   GET http://localhost:8080/api/users/me
   Headers:
   Authorization: Bearer <your-token-here>
   ```

## Security Best Practices

1. ✅ Always use HTTPS in production
2. ✅ Change JWT secret key in production
3. ✅ Set appropriate token expiration time
4. ✅ Validate all inputs
5. ✅ Hash passwords (already done with BCrypt)
6. ✅ Use strong password requirements
7. ✅ Implement rate limiting for login attempts
8. ✅ Log authentication failures

## Troubleshooting

### Token Not Working

1. Check if token is being sent in Authorization header
2. Verify token format: `Bearer <token>` (note the space)
3. Check if token has expired
4. Verify JWT secret key matches

### CORS Issues

- Check CORS configuration in `SecurityConfig`
- Verify frontend URL is in allowed origins
- Check browser console for CORS errors

### User Not Found

- Verify user exists in database
- Check if user is active (`is_active = true`)
- Verify username spelling

## Next Steps

1. Implement refresh token mechanism (optional)
2. Add password reset functionality
3. Add email verification
4. Implement role-based access control (RBAC)
5. Add rate limiting
