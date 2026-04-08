package com.cursorai.dto;

import java.time.LocalDateTime;

/**
 * Project DTO
 * 
 * Data Transfer Object for Project entity.
 * Used to transfer project data between layers without exposing entity details.
 */
public class ProjectDto {

    private Long id;
    private String name;
    private String description;
    private Long ownerId;
    private String language;
    private Boolean isPublic;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public ProjectDto() {
    }

    public ProjectDto(Long id, String name, String description, Long ownerId, String language, Boolean isPublic) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.ownerId = ownerId;
        this.language = language;
        this.isPublic = isPublic;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Long ownerId) {
        this.ownerId = ownerId;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public Boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
