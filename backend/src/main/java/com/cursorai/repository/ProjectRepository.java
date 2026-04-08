package com.cursorai.repository;

import com.cursorai.model.Project;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

/**
 * Project Repository
 * 
 * Data access layer for Project entity.
 * Provides CRUD operations and custom query methods.
 */
@Repository
public interface ProjectRepository extends JpaRepository<Project, Long> {

    /**
     * Find all projects owned by a user
     * @param ownerId the owner's user ID
     * @param pageable pagination information
     * @return Page of projects
     */
    Page<Project> findByOwnerId(Long ownerId, Pageable pageable);

    /**
     * Find all projects where user is a collaborator
     * @param userId the user ID
     * @param pageable pagination information
     * @return Page of projects
     */
    @Query("SELECT p FROM Project p JOIN p.collaborators c WHERE c.userId = :userId")
    Page<Project> findProjectsByCollaborator(@Param("userId") Long userId, Pageable pageable);

    /**
     * Find all public projects
     * @param pageable pagination information
     * @return Page of public projects
     */
    Page<Project> findByIsPublicTrue(Pageable pageable);

    /**
     * Find projects by language
     * @param language the programming language
     * @param pageable pagination information
     * @return Page of projects
     */
    Page<Project> findByLanguage(String language, Pageable pageable);
}
