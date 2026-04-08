package com.cursorai.service;

import com.cursorai.dto.ProjectDto;
import com.cursorai.model.Project;
import com.cursorai.repository.ProjectRepository;
import com.cursorai.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.List;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.Objects;

/**
 * Project Service
 *
 * Business logic layer for project operations.
 * Handles project creation, retrieval, updates, and deletion.
 */
@Service
@Transactional
public class ProjectService {

    @Autowired
    private ProjectRepository projectRepository;

    @Autowired
    private UserRepository userRepository;

    /**
     * Create a new project
     * @param projectDto the project data
     * @param ownerId the owner user ID
     * @return the created project DTO
     */
    public ProjectDto createProject(ProjectDto projectDto, Long ownerId) {
        // Validate input
        if (projectDto == null) {
            throw new IllegalArgumentException("Project data cannot be null");
        }
        if (projectDto.getName() == null || projectDto.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Project name cannot be null or empty");
        }
        if (ownerId == null) {
            throw new IllegalArgumentException("Owner ID cannot be null");
        }

        // Verify owner exists
        if (!userRepository.existsById(ownerId)) {
            throw new RuntimeException("Owner not found");
        }

        Project project = new Project();
        project.setName(projectDto.getName().trim());
        project.setDescription(projectDto.getDescription() != null ? projectDto.getDescription().trim() : null);
        project.setOwnerId(ownerId);
        project.setLanguage(projectDto.getLanguage() != null && !projectDto.getLanguage().trim().isEmpty()
                ? projectDto.getLanguage().trim() : "java");
        project.setIsPublic(projectDto.getIsPublic() != null ? projectDto.getIsPublic() : false);

        Project savedProject = projectRepository.save(project);

        return convertToDto(savedProject);
    }

    /**
     * Get a project by ID
     * @param id the project ID
     * @return the project DTO
     */
    public Optional<ProjectDto> getProjectById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Project ID cannot be null");
        }
        return projectRepository.findById(id).map(this::convertToDto);
    }

    /**
     * Get all projects for a user (owned + collaborated)
     * @param userId the user ID
     * @param pageable pagination info
     * @return page of project DTOs
     */
    public Page<ProjectDto> getUserProjects(Long userId, Pageable pageable) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null");
        }
        if (pageable == null) {
            throw new IllegalArgumentException("Pageable cannot be null");
        }

        // Get owned projects
        Page<Project> ownedProjectsPage = projectRepository.findByOwnerId(userId, Pageable.unpaged());
        List<Project> ownedProjects = ownedProjectsPage.getContent();

        // Get collaborated projects
        Page<Project> collaboratedProjects = projectRepository.findProjectsByCollaborator(userId, Pageable.unpaged());

        // Combine owned and collaborated projects, removing duplicates
        Set<Project> allProjects = new LinkedHashSet<>();
        allProjects.addAll(ownedProjects);
        allProjects.addAll(collaboratedProjects.getContent());

        // Convert to list and apply pagination
        List<Project> projectList = new ArrayList<>(allProjects);
        int start = (int) pageable.getOffset();
        int end = Math.min(start + pageable.getPageSize(), projectList.size());

        List<Project> paginatedProjects = projectList.subList(start, end);

        // Convert to DTOs
        List<ProjectDto> projectDtos = paginatedProjects.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());

        // Ensure non-null for static analysis
        Objects.requireNonNull(projectDtos);

        return new PageImpl<>(projectDtos, pageable, projectList.size());
    }

    /**
     * Update a project
     * @param id the project ID
     * @param projectDto the updated project data
     * @param userId the user making the update (must be owner)
     * @return the updated project DTO
     */
    public ProjectDto updateProject(Long id, ProjectDto projectDto, Long userId) {
        // Validate input
        if (id == null) {
            throw new IllegalArgumentException("Project ID cannot be null");
        }
        if (projectDto == null) {
            throw new IllegalArgumentException("Project data cannot be null");
        }
        if (projectDto.getName() == null || projectDto.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Project name cannot be null or empty");
        }
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null");
        }

        Project project = projectRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Project not found"));

        // Check if user is the owner
        if (!project.getOwnerId().equals(userId)) {
            throw new RuntimeException("Only project owner can update the project");
        }

        project.setName(projectDto.getName().trim());
        project.setDescription(projectDto.getDescription() != null ? projectDto.getDescription().trim() : null);
        project.setLanguage(projectDto.getLanguage() != null && !projectDto.getLanguage().trim().isEmpty()
                ? projectDto.getLanguage().trim() : project.getLanguage());
        project.setIsPublic(projectDto.getIsPublic() != null ? projectDto.getIsPublic() : project.getIsPublic());

        Project savedProject = projectRepository.save(project);
        return convertToDto(savedProject);
    }

    /**
     * Delete a project
     * @param id the project ID
     * @param userId the user making the deletion (must be owner)
     */
    public void deleteProject(Long id, Long userId) {
        // Validate input
        if (id == null) {
            throw new IllegalArgumentException("Project ID cannot be null");
        }
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null");
        }

        Project project = projectRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Project not found"));

        // Check if user is the owner
        if (!project.getOwnerId().equals(userId)) {
            throw new RuntimeException("Only project owner can delete the project");
        }

        projectRepository.delete(project);
    }

    /**
     * Convert Project entity to ProjectDto
     * @param project the project entity
     * @return the project DTO
     */
    private ProjectDto convertToDto(Project project) {
        ProjectDto dto = new ProjectDto();
        dto.setId(project.getId());
        dto.setName(project.getName());
        dto.setDescription(project.getDescription());
        dto.setOwnerId(project.getOwnerId());
        dto.setLanguage(project.getLanguage());
        dto.setIsPublic(project.getIsPublic());
        dto.setCreatedAt(project.getCreatedAt());
        dto.setUpdatedAt(project.getUpdatedAt());
        return dto;
    }
}