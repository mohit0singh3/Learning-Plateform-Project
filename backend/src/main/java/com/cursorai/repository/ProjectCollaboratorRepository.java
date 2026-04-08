package com.cursorai.repository;

import com.cursorai.model.ProjectCollaborator;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * ProjectCollaborator Repository
 *
 * Repository for managing project collaborators.
 */
@Repository
public interface ProjectCollaboratorRepository extends JpaRepository<ProjectCollaborator, Long> {

    /**
     * Find all collaborators for a specific project
     * @param projectId the project ID
     * @return list of project collaborators
     */
    List<ProjectCollaborator> findByProjectId(Long projectId);

    /**
     * Find all projects where a user is a collaborator
     * @param userId the user ID
     * @return list of project collaborators
     */
    List<ProjectCollaborator> findByUserId(Long userId);

    /**
     * Check if a user is a collaborator on a specific project
     * @param projectId the project ID
     * @param userId the user ID
     * @return true if user is a collaborator
     */
    boolean existsByProjectIdAndUserId(Long projectId, Long userId);

    /**
     * Find collaborator by project and user
     * @param projectId the project ID
     * @param userId the user ID
     * @return the project collaborator if found
     */
    ProjectCollaborator findByProjectIdAndUserId(Long projectId, Long userId);

    /**
     * Get all project IDs where user is a collaborator
     * @param userId the user ID
     * @return list of project IDs
     */
    @Query("SELECT pc.projectId FROM ProjectCollaborator pc WHERE pc.userId = :userId")
    List<Long> findProjectIdsByUserId(@Param("userId") Long userId);
}