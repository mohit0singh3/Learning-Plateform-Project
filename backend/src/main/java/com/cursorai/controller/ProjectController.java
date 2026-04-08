package com.cursorai.controller;

import com.cursorai.dto.ProjectDto;
import com.cursorai.service.ProjectService;
import com.cursorai.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Project Controller
 *
 * REST API endpoints for project management.
 * Handles CRUD operations for projects.
 */
@RestController
@RequestMapping("/api/projects")
@CrossOrigin(origins = "http://localhost:3000")
public class ProjectController {

    @Autowired
    private ProjectService projectService;

    @Autowired
    private JwtUtil jwtUtil;

    /**
     * Get all projects for the authenticated user
     * @param page page number (0-based)
     * @param size page size
     * @param request HTTP request to extract user ID from JWT
     * @return page of projects
     */
    @GetMapping
    public ResponseEntity<Map<String, Object>> getUserProjects(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            HttpServletRequest request) {

        // Validate pagination parameters
        if (page < 0) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Page number cannot be negative"));
        }
        if (size <= 0 || size > 100) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Page size must be between 1 and 100"));
        }

        try {
            Long userId = getUserIdFromRequest(request);
            Pageable pageable = PageRequest.of(page, size);
            Page<ProjectDto> projects = projectService.getUserProjects(userId, pageable);

            Map<String, Object> response = new HashMap<>();
            response.put("content", projects.getContent());
            response.put("totalElements", projects.getTotalElements());
            response.put("totalPages", projects.getTotalPages());
            response.put("currentPage", projects.getNumber());
            response.put("size", projects.getSize());

            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to fetch projects: " + e.getMessage()));
        }
    }

    /**
     * Get a specific project by ID
     * @param id the project ID
     * @param request HTTP request to extract user ID from JWT
     * @return the project
     */
    @GetMapping("/{id}")
    public ResponseEntity<?> getProject(@PathVariable Long id, HttpServletRequest request) {
        // Validate path parameter
        if (id == null || id <= 0) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Invalid project ID"));
        }

        try {
            Long userId = getUserIdFromRequest(request);
            Optional<ProjectDto> project = projectService.getProjectById(id);

            if (project.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            // Check if user has access to this project (owner or collaborator)
            ProjectDto projectDto = project.get();
            if (!projectDto.getOwnerId().equals(userId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("error", "Access denied"));
            }

            return ResponseEntity.ok(projectDto);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to fetch project: " + e.getMessage()));
        }
    }

    /**
     * Create a new project
     * @param projectDto the project data
     * @param request HTTP request to extract user ID from JWT
     * @return the created project
     */
    @PostMapping
    public ResponseEntity<?> createProject(@RequestBody ProjectDto projectDto, HttpServletRequest request) {
        try {
            Long userId = getUserIdFromRequest(request);
            ProjectDto createdProject = projectService.createProject(projectDto, userId);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdProject);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        } catch (RuntimeException e) {
            if (e.getMessage().contains("not found")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("error", e.getMessage()));
            }
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to create project: " + e.getMessage()));
        }
    }

    /**
     * Update an existing project
     * @param id the project ID
     * @param projectDto the updated project data
     * @param request HTTP request to extract user ID from JWT
     * @return the updated project
     */
    @PutMapping("/{id}")
    public ResponseEntity<?> updateProject(@PathVariable Long id, @RequestBody ProjectDto projectDto, HttpServletRequest request) {
        // Validate path parameter
        if (id == null || id <= 0) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Invalid project ID"));
        }

        try {
            Long userId = getUserIdFromRequest(request);
            ProjectDto updatedProject = projectService.updateProject(id, projectDto, userId);
            return ResponseEntity.ok(updatedProject);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        } catch (RuntimeException e) {
            if (e.getMessage().contains("not found")) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to update project: " + e.getMessage()));
        }
    }

    /**
     * Delete a project
     * @param id the project ID
     * @param request HTTP request to extract user ID from JWT
     * @return success message
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteProject(@PathVariable Long id, HttpServletRequest request) {
        // Validate path parameter
        if (id == null || id <= 0) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Invalid project ID"));
        }

        try {
            Long userId = getUserIdFromRequest(request);
            projectService.deleteProject(id, userId);
            return ResponseEntity.ok(Map.of("message", "Project deleted successfully"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        } catch (RuntimeException e) {
            if (e.getMessage().contains("not found")) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to delete project: " + e.getMessage()));
        }
    }

    /**
     * Extract user ID from JWT token in request
     * @param request the HTTP request
     * @return the user ID
     */
    private Long getUserIdFromRequest(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            throw new RuntimeException("Authorization header missing or invalid");
        }

        String token = authHeader.substring(7);
        return jwtUtil.extractUserId(token);
    }
}