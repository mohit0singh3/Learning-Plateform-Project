package com.cursorai.controller;

import com.cursorai.dto.AuthResponse;
import com.cursorai.model.User;
import com.cursorai.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

/**
 * User Controller
 * 
 * REST API endpoints for user profile management.
 * Handles operations related to current authenticated user.
 */
@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "http://localhost:3000")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    /**
     * Get current authenticated user's profile
     * 
     * GET /api/users/me
     * 
     * @param authentication Spring Security authentication object
     * @return User profile information
     */
    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser(Authentication authentication) {
        try {
            // Get username from authentication
            String username = authentication.getName();
            
            // Find user
            User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

            // Create response DTO
            AuthResponse.UserDto userDto = new AuthResponse.UserDto(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getFullName(),
                user.getRole().toString()
            );

            return ResponseEntity.ok(userDto);
        } catch (Exception e) {
            return ResponseEntity.status(401).body(new ErrorResponse("Unauthorized"));
        }
    }

    /**
     * Update current user's profile
     * 
     * PUT /api/users/me
     * 
     * @param updateRequest Request containing fields to update
     * @param authentication Spring Security authentication object
     * @return Updated user profile
     */
    @PutMapping("/me")
    @SuppressWarnings("null")
    public ResponseEntity<?> updateCurrentUser(
            @RequestBody UpdateUserRequest updateRequest,
            Authentication authentication) {
        try {
            String username = authentication.getName();
            
            User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

            // Update fields if provided
            if (updateRequest.getFullName() != null) {
                user.setFullName(updateRequest.getFullName());
            }
            if (updateRequest.getEmail() != null) {
                // Check if email already exists for another user
                if (userRepository.existsByEmail(updateRequest.getEmail()) && 
                    !user.getEmail().equals(updateRequest.getEmail())) {
                    return ResponseEntity.status(409)
                        .body(new ErrorResponse("Email already exists"));
                }
                user.setEmail(updateRequest.getEmail());
            }

            // JPA save() returns the saved entity, never null for existing entities
            User updatedUser = userRepository.save(user);
            // Line removed - duplicate variable declaration

            AuthResponse.UserDto userDto = new AuthResponse.UserDto(
                updatedUser.getId(),
                updatedUser.getUsername(),
                updatedUser.getEmail(),
                updatedUser.getFullName(),
                updatedUser.getRole().toString()
            );

            return ResponseEntity.ok(userDto);
        } catch (Exception e) {
            return ResponseEntity.status(400).body(new ErrorResponse(e.getMessage()));
        }
    }

    /**
     * Update User Request DTO
     */
    public static class UpdateUserRequest {
        private String fullName;
        private String email;

        public String getFullName() {
            return fullName;
        }

        public void setFullName(String fullName) {
            this.fullName = fullName;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }
    }

    /**
     * Error Response DTO
     * Used for error responses in user endpoints.
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
