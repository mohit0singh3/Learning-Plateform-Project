package com.cursorai.repository;

import com.cursorai.model.CodeFile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * CodeFile Repository
 * 
 * Data access layer for CodeFile entity.
 * Provides CRUD operations and custom query methods.
 */
@Repository
public interface CodeFileRepository extends JpaRepository<CodeFile, Long> {

    /**
     * Find all files in a project
     * @param projectId the project ID
     * @return List of code files
     */
    List<CodeFile> findByProjectId(Long projectId);

    /**
     * Find file by project ID and file path
     * @param projectId the project ID
     * @param filePath the file path
     * @return Optional containing CodeFile if found
     */
    Optional<CodeFile> findByProjectIdAndFilePath(Long projectId, String filePath);

    /**
     * Check if file exists in project
     * @param projectId the project ID
     * @param filePath the file path
     * @return true if file exists
     */
    boolean existsByProjectIdAndFilePath(Long projectId, String filePath);
}
