-- =====================================================
-- CodeSphere Platform - Database Schema
-- MySQL 8.0+
-- =====================================================
-- This script creates the complete database schema
-- for the CodeSphere Collaborative Coding Platform
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS codesphere_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE codesphere_db;

-- =====================================================
-- TABLE: users
-- Purpose: Store user accounts and authentication data
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique user identifier',
    username VARCHAR(50) UNIQUE NOT NULL COMMENT 'Unique username for login',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT 'User email address (unique)',
    password_hash VARCHAR(255) NOT NULL COMMENT 'BCrypt hashed password',
    full_name VARCHAR(100) COMMENT 'User full name',
    role ENUM('STUDENT', 'INSTRUCTOR', 'ADMIN') DEFAULT 'STUDENT' COMMENT 'User role in system',
    avatar_url VARCHAR(500) COMMENT 'URL to user avatar image',
    bio TEXT COMMENT 'User biography/description',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Account creation timestamp',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update timestamp',
    last_login_at TIMESTAMP NULL COMMENT 'Last login timestamp',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Account active status',
    is_email_verified BOOLEAN DEFAULT FALSE COMMENT 'Email verification status',
    
    -- Indexes for performance
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_is_active (is_active),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='User accounts and authentication information';

-- =====================================================
-- TABLE: projects
-- Purpose: Store code projects/sessions for collaboration
-- =====================================================
CREATE TABLE IF NOT EXISTS projects (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique project identifier',
    name VARCHAR(100) NOT NULL COMMENT 'Project name',
    description TEXT COMMENT 'Project description',
    owner_id BIGINT NOT NULL COMMENT 'Project owner/creator user ID',
    language VARCHAR(20) DEFAULT 'java' COMMENT 'Primary programming language',
    is_public BOOLEAN DEFAULT FALSE COMMENT 'Public visibility flag',
    is_archived BOOLEAN DEFAULT FALSE COMMENT 'Archived status',
    settings JSON COMMENT 'Project settings (JSON format)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Project creation timestamp',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update timestamp',
    last_accessed_at TIMESTAMP NULL COMMENT 'Last access timestamp',
    
    -- Foreign key constraints
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
    
    -- Indexes for performance
    INDEX idx_owner (owner_id),
    INDEX idx_language (language),
    INDEX idx_is_public (is_public),
    INDEX idx_is_archived (is_archived),
    INDEX idx_created_at (created_at),
    INDEX idx_updated_at (updated_at),
    FULLTEXT INDEX idx_name_description (name, description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Code projects for collaborative editing';

-- =====================================================
-- TABLE: project_collaborators
-- Purpose: Many-to-many relationship between users and projects
-- =====================================================
CREATE TABLE IF NOT EXISTS project_collaborators (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique collaborator record ID',
    project_id BIGINT NOT NULL COMMENT 'Project ID',
    user_id BIGINT NOT NULL COMMENT 'Collaborator user ID',
    role ENUM('OWNER', 'EDITOR', 'VIEWER') DEFAULT 'EDITOR' COMMENT 'Collaborator role',
    permissions JSON COMMENT 'Additional permissions (JSON format)',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When user joined project',
    last_accessed_at TIMESTAMP NULL COMMENT 'Last access timestamp',
    
    -- Foreign key constraints
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    -- Unique constraint: one user can only have one role per project
    UNIQUE KEY unique_collaborator (project_id, user_id),
    
    -- Indexes for performance
    INDEX idx_project (project_id),
    INDEX idx_user (user_id),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Project collaborators and their roles';

-- =====================================================
-- TABLE: code_files
-- Purpose: Store individual code files within projects
-- =====================================================
CREATE TABLE IF NOT EXISTS code_files (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique file identifier',
    project_id BIGINT NOT NULL COMMENT 'Parent project ID',
    filename VARCHAR(255) NOT NULL COMMENT 'File name',
    file_path VARCHAR(500) NOT NULL COMMENT 'File path within project',
    content LONGTEXT COMMENT 'File content/code',
    language VARCHAR(20) COMMENT 'Programming language (auto-detected)',
    file_size BIGINT DEFAULT 0 COMMENT 'File size in bytes',
    line_count INT DEFAULT 0 COMMENT 'Number of lines in file',
    encoding VARCHAR(20) DEFAULT 'utf-8' COMMENT 'File encoding',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'File creation timestamp',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update timestamp',
    last_modified_by BIGINT COMMENT 'User ID who last modified file',
    
    -- Foreign key constraints
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    FOREIGN KEY (last_modified_by) REFERENCES users(id) ON DELETE SET NULL,
    
    -- Unique constraint: one file path per project
    UNIQUE KEY unique_file_path (project_id, file_path),
    
    -- Indexes for performance
    INDEX idx_project (project_id),
    INDEX idx_language (language),
    INDEX idx_last_modified_by (last_modified_by),
    INDEX idx_updated_at (updated_at),
    FULLTEXT INDEX idx_content (content(1000))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Code files within projects';

-- =====================================================
-- TABLE: learning_topics
-- Purpose: Store available learning topics/categories
-- =====================================================
CREATE TABLE IF NOT EXISTS learning_topics (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique topic identifier',
    title VARCHAR(200) NOT NULL COMMENT 'Topic title',
    description TEXT COMMENT 'Topic description',
    category VARCHAR(50) COMMENT 'Topic category (e.g., OOPs, DSA, Collections)',
    difficulty_level ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED') DEFAULT 'BEGINNER' COMMENT 'Difficulty level',
    order_index INT DEFAULT 0 COMMENT 'Display order within category',
    icon_url VARCHAR(500) COMMENT 'Topic icon URL',
    estimated_time INT COMMENT 'Estimated completion time in minutes',
    prerequisites TEXT COMMENT 'Prerequisites for this topic',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Topic creation timestamp',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update timestamp',
    
    -- Indexes for performance
    INDEX idx_category (category),
    INDEX idx_difficulty (difficulty_level),
    INDEX idx_order_index (order_index),
    FULLTEXT INDEX idx_title_description (title, description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Learning topics and categories';

-- =====================================================
-- TABLE: exercises
-- Purpose: Store coding exercises for interactive learning
-- =====================================================
CREATE TABLE IF NOT EXISTS exercises (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique exercise identifier',
    topic_id BIGINT NOT NULL COMMENT 'Associated topic ID',
    title VARCHAR(200) NOT NULL COMMENT 'Exercise title',
    description TEXT NOT NULL COMMENT 'Exercise description',
    starter_code TEXT COMMENT 'Initial code template',
    solution_code TEXT COMMENT 'Solution code for validation',
    test_cases JSON COMMENT 'Test cases (JSON array)',
    hints JSON COMMENT 'Array of hints (JSON format)',
    difficulty ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED') DEFAULT 'BEGINNER' COMMENT 'Difficulty level',
    points INT DEFAULT 10 COMMENT 'Points awarded for completion',
    order_index INT DEFAULT 0 COMMENT 'Order within topic',
    time_limit INT COMMENT 'Time limit in minutes (optional)',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Exercise active status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Exercise creation timestamp',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update timestamp',
    
    -- Foreign key constraints
    FOREIGN KEY (topic_id) REFERENCES learning_topics(id) ON DELETE CASCADE,
    
    -- Indexes for performance
    INDEX idx_topic (topic_id),
    INDEX idx_difficulty (difficulty),
    INDEX idx_is_active (is_active),
    INDEX idx_order_index (order_index),
    FULLTEXT INDEX idx_title_description (title, description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Coding exercises for learning';

-- =====================================================
-- TABLE: user_progress
-- Purpose: Track user progress in learning exercises
-- =====================================================
CREATE TABLE IF NOT EXISTS user_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique progress record ID',
    user_id BIGINT NOT NULL COMMENT 'User ID',
    exercise_id BIGINT NOT NULL COMMENT 'Exercise ID',
    status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'SKIPPED') DEFAULT 'NOT_STARTED' COMMENT 'Progress status',
    user_code TEXT COMMENT 'User submitted code',
    is_correct BOOLEAN COMMENT 'Whether solution is correct',
    attempts INT DEFAULT 0 COMMENT 'Number of attempts',
    score INT DEFAULT 0 COMMENT 'Score achieved',
    time_spent INT DEFAULT 0 COMMENT 'Time spent in seconds',
    completed_at TIMESTAMP NULL COMMENT 'Completion timestamp',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Record creation timestamp',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update timestamp',
    
    -- Foreign key constraints
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    
    -- Unique constraint: one progress record per user-exercise pair
    UNIQUE KEY unique_user_exercise (user_id, exercise_id),
    
    -- Indexes for performance
    INDEX idx_user (user_id),
    INDEX idx_exercise (exercise_id),
    INDEX idx_status (status),
    INDEX idx_completed_at (completed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='User progress tracking for exercises';

-- =====================================================
-- TABLE: ai_interactions
-- Purpose: Log AI assistant interactions
-- =====================================================
CREATE TABLE IF NOT EXISTS ai_interactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique interaction ID',
    user_id BIGINT COMMENT 'User who requested AI help',
    project_id BIGINT COMMENT 'Associated project (if any)',
    exercise_id BIGINT COMMENT 'Associated exercise (if any)',
    interaction_type ENUM('CODE_SUGGESTION', 'ERROR_EXPLANATION', 'CONCEPT_EXPLANATION', 'HINT', 'CODE_REVIEW') NOT NULL COMMENT 'Type of interaction',
    user_query TEXT COMMENT 'User question/request',
    ai_response TEXT COMMENT 'AI response',
    context_code TEXT COMMENT 'Relevant code context',
    tokens_used INT COMMENT 'Tokens used for this interaction',
    response_time_ms INT COMMENT 'Response time in milliseconds',
    rating INT COMMENT 'User rating (1-5, optional)',
    feedback TEXT COMMENT 'User feedback (optional)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Interaction timestamp',
    
    -- Foreign key constraints
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE SET NULL,
    
    -- Indexes for performance
    INDEX idx_user (user_id),
    INDEX idx_project (project_id),
    INDEX idx_exercise (exercise_id),
    INDEX idx_type (interaction_type),
    INDEX idx_created_at (created_at),
    INDEX idx_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='AI assistant interaction logs';

-- =====================================================
-- TABLE: sessions (for WebSocket/real-time collaboration)
-- Purpose: Track active user sessions in projects
-- =====================================================
CREATE TABLE IF NOT EXISTS sessions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique session ID',
    user_id BIGINT NOT NULL COMMENT 'User ID',
    project_id BIGINT NOT NULL COMMENT 'Project ID',
    session_token VARCHAR(255) UNIQUE NOT NULL COMMENT 'Unique session token',
    socket_id VARCHAR(255) COMMENT 'WebSocket socket ID',
    ip_address VARCHAR(45) COMMENT 'User IP address',
    user_agent TEXT COMMENT 'User agent string',
    connected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Connection timestamp',
    last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last activity timestamp',
    disconnected_at TIMESTAMP NULL COMMENT 'Disconnection timestamp',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Session active status',
    
    -- Foreign key constraints
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    
    -- Indexes for performance
    INDEX idx_user (user_id),
    INDEX idx_project (project_id),
    INDEX idx_session_token (session_token),
    INDEX idx_socket_id (socket_id),
    INDEX idx_is_active (is_active),
    INDEX idx_last_activity (last_activity_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Active user sessions for real-time collaboration';

-- =====================================================
-- TABLE: file_history (optional - for version control)
-- Purpose: Track file change history
-- =====================================================
CREATE TABLE IF NOT EXISTS file_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique history record ID',
    file_id BIGINT NOT NULL COMMENT 'File ID',
    user_id BIGINT COMMENT 'User who made the change',
    content_snapshot LONGTEXT COMMENT 'File content snapshot',
    change_type ENUM('CREATE', 'UPDATE', 'DELETE', 'RENAME') DEFAULT 'UPDATE' COMMENT 'Type of change',
    change_description TEXT COMMENT 'Description of changes',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Change timestamp',
    
    -- Foreign key constraints
    FOREIGN KEY (file_id) REFERENCES code_files(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    
    -- Indexes for performance
    INDEX idx_file (file_id),
    INDEX idx_user (user_id),
    INDEX idx_created_at (created_at),
    INDEX idx_change_type (change_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='File change history for version control';

-- =====================================================
-- TABLE: notifications
-- Purpose: Store user notifications
-- =====================================================
CREATE TABLE IF NOT EXISTS notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique notification ID',
    user_id BIGINT NOT NULL COMMENT 'Recipient user ID',
    type VARCHAR(50) NOT NULL COMMENT 'Notification type',
    title VARCHAR(200) NOT NULL COMMENT 'Notification title',
    message TEXT COMMENT 'Notification message',
    related_project_id BIGINT COMMENT 'Related project ID',
    related_exercise_id BIGINT COMMENT 'Related exercise ID',
    is_read BOOLEAN DEFAULT FALSE COMMENT 'Read status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Notification timestamp',
    
    -- Foreign key constraints
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (related_project_id) REFERENCES projects(id) ON DELETE SET NULL,
    FOREIGN KEY (related_exercise_id) REFERENCES exercises(id) ON DELETE SET NULL,
    
    -- Indexes for performance
    INDEX idx_user (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at),
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='User notifications';

-- =====================================================
-- END OF TABLE CREATION
-- =====================================================
