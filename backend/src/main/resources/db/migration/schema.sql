-- =====================================================
-- CodeSphere Database Schema (Legacy - Use Migration Files)
-- MySQL 8.0+
-- =====================================================
-- NOTE: This file is kept for backward compatibility.
-- For new installations, use the migration files:
-- 01_create_database.sql
-- 02_insert_sample_data.sql
-- 03_create_views.sql
-- 04_create_indexes.sql
-- =====================================================

-- Create database (run this separately if needed)
-- CREATE DATABASE IF NOT EXISTS codesphere_db;
-- USE codesphere_db;

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role VARCHAR(20) DEFAULT 'STUDENT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_email (email),
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: projects
CREATE TABLE IF NOT EXISTS projects (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    owner_id BIGINT NOT NULL,
    language VARCHAR(20) DEFAULT 'java',
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_owner (owner_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: project_collaborators
CREATE TABLE IF NOT EXISTS project_collaborators (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    role VARCHAR(20) DEFAULT 'EDITOR',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_collaborator (project_id, user_id),
    INDEX idx_project (project_id),
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: code_files
CREATE TABLE IF NOT EXISTS code_files (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(500),
    content LONGTEXT,
    language VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_modified_by BIGINT,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    FOREIGN KEY (last_modified_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_project (project_id),
    UNIQUE KEY unique_file_path (project_id, file_path)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: learning_topics
CREATE TABLE IF NOT EXISTS learning_topics (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    difficulty_level VARCHAR(20) DEFAULT 'BEGINNER',
    order_index INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_difficulty (difficulty_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: exercises
CREATE TABLE IF NOT EXISTS exercises (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    topic_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    starter_code TEXT,
    solution_code TEXT,
    hints JSON,
    difficulty VARCHAR(20) DEFAULT 'BEGINNER',
    order_index INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (topic_id) REFERENCES learning_topics(id) ON DELETE CASCADE,
    INDEX idx_topic (topic_id),
    INDEX idx_difficulty (difficulty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: user_progress
CREATE TABLE IF NOT EXISTS user_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    exercise_id BIGINT NOT NULL,
    status VARCHAR(20) DEFAULT 'NOT_STARTED',
    user_code TEXT,
    is_correct BOOLEAN,
    attempts INT DEFAULT 0,
    completed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_exercise (user_id, exercise_id),
    INDEX idx_user (user_id),
    INDEX idx_exercise (exercise_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: ai_interactions
CREATE TABLE IF NOT EXISTS ai_interactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    project_id BIGINT,
    exercise_id BIGINT,
    interaction_type VARCHAR(50) NOT NULL,
    user_query TEXT,
    ai_response TEXT,
    context_code TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_type (interaction_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample learning topics
INSERT INTO learning_topics (title, description, category, difficulty_level, order_index) VALUES
('Object-Oriented Programming Basics', 'Learn about classes, objects, and basic OOP concepts', 'OOPs', 'BEGINNER', 1),
('Inheritance and Polymorphism', 'Understanding inheritance, method overriding, and polymorphism', 'OOPs', 'INTERMEDIATE', 2),
('Java Collections Framework', 'Working with ArrayList, HashMap, and other collections', 'Collections', 'BEGINNER', 1),
('Data Structures - Arrays and Lists', 'Understanding arrays and linked lists', 'DSA', 'BEGINNER', 1),
('Data Structures - Trees', 'Binary trees and tree traversal algorithms', 'DSA', 'INTERMEDIATE', 2);

-- Insert sample exercises
INSERT INTO exercises (topic_id, title, description, starter_code, solution_code, difficulty, order_index) VALUES
(1, 'Create a Student Class', 'Create a Student class with name and age attributes, and getter/setter methods', 
'public class Student {\n    // Add your code here\n}', 
'public class Student {\n    private String name;\n    private int age;\n    \n    public String getName() { return name; }\n    public void setName(String name) { this.name = name; }\n    public int getAge() { return age; }\n    public void setAge(int age) { this.age = age; }\n}', 
'BEGINNER', 1),
(3, 'Use ArrayList', 'Create an ArrayList, add some elements, and print them', 
'import java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        // Your code here\n    }\n}', 
'import java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        ArrayList<String> list = new ArrayList<>();\n        list.add(\"Hello\");\n        list.add(\"World\");\n        for(String item : list) {\n            System.out.println(item);\n        }\n    }\n}', 
'BEGINNER', 1);
