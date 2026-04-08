package com.cursorai.controller;

import com.cursorai.dto.AuthResponse;
import com.cursorai.dto.LoginRequest;
import com.cursorai.dto.RegisterRequest;
import com.cursorai.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Authentication Controller
 * 
 * REST API endpoints for user authentication (register and login).
 * Handles HTTP requests and responses for authentication operations.
 */
@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:3000")
public class AuthController {

    @Autowired
    private AuthService authService;

    /**
     * Register a new user
     * 
     * POST /api/auth/register
     * 
     * @param request Registration request with user details
     * @return AuthResponse with JWT token and user info
     */
    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody RegisterRequest request) {
        try {
            AuthResponse response = authService.register(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            // Handle specific exceptions
            if (e.getMessage().contains("already exists")) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(new ErrorResponse(e.getMessage()));
            }
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ErrorResponse(e.getMessage()));
        }
    }

    /**
     * Login user
     * 
     * POST /api/auth/login
     * 
     * @param request Login request with credentials
     * @return AuthResponse with JWT token and user info
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        try {
            AuthResponse response = authService.login(request);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ErrorResponse(e.getMessage()));
        }
    }

    /**
     * Error Response DTO (inner class)
     * Used for error responses in authentication endpoints.
     * Getters/setters are used by Spring's Jackson JSON serialization.
     */
    @SuppressWarnings("unused")
    private static class ErrorResponse {
        private String message;

        public ErrorResponse(String message) {
            this.message = message;
        }

        /**
         * Getter method used by Spring's JSON serialization
         * @return error message
         */
        public String getMessage() {
            return message;
        }

        /**
         * Setter method used by Spring's JSON deserialization
         * @param message error message
         */
        public void setMessage(String message) {
            this.message = message;
        }
    }
}
