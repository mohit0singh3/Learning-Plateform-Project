# Database Schema Design

## Overview

This document describes the MySQL database schema for the CodeSphere platform.

## Entity Relationship Diagram (Conceptual)

```
users ──┬── project_collaborators ──┬── projects
        │                           │
        │                           └── code_files
        │
        ├── user_progress ──┬── learning_topics
        │                   └── exercises
        │
        └── ai_interactions
```

## Tables

### 1. users

Stores user account information and authentication data.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique user ID |
| username | VARCHAR(50) | UNIQUE, NOT NULL | Username for login |
| email | VARCHAR(100) | UNIQUE, NOT NULL | User email address |
| password_hash | VARCHAR(255) | NOT NULL | Hashed password (BCrypt) |
| full_name | VARCHAR(100) | | User's full name |
| role | VARCHAR(20) | DEFAULT 'STUDENT' | User role (STUDENT, INSTRUCTOR, ADMIN) |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Account creation time |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last update time |
| is_active | BOOLEAN | DEFAULT TRUE | Account status |

**Indexes:**
- PRIMARY KEY (id)
- UNIQUE KEY (username)
- UNIQUE KEY (email)
- INDEX idx_email (email)

---

### 2. projects

Stores code projects/sessions that users can collaborate on.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique project ID |
| name | VARCHAR(100) | NOT NULL | Project name |
| description | TEXT | | Project description |
| owner_id | BIGINT | FOREIGN KEY (users.id), NOT NULL | Project owner/creator |
| language | VARCHAR(20) | DEFAULT 'java' | Programming language |
| is_public | BOOLEAN | DEFAULT FALSE | Public/private project |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last update time |

**Indexes:**
- PRIMARY KEY (id)
- FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
- INDEX idx_owner (owner_id)
- INDEX idx_created_at (created_at)

---

### 3. project_collaborators

Junction table for many-to-many relationship between users and projects.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique record ID |
| project_id | BIGINT | FOREIGN KEY (projects.id), NOT NULL | Project ID |
| user_id | BIGINT | FOREIGN KEY (users.id), NOT NULL | Collaborator user ID |
| role | VARCHAR(20) | DEFAULT 'EDITOR' | Role (OWNER, EDITOR, VIEWER) |
| joined_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When user joined project |

**Indexes:**
- PRIMARY KEY (id)
- FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
- UNIQUE KEY unique_collaborator (project_id, user_id)
- INDEX idx_project (project_id)
- INDEX idx_user (user_id)

---

### 4. code_files

Stores individual code files within projects.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique file ID |
| project_id | BIGINT | FOREIGN KEY (projects.id), NOT NULL | Parent project ID |
| filename | VARCHAR(255) | NOT NULL | File name |
| file_path | VARCHAR(500) | | File path within project |
| content | LONGTEXT | | File content/code |
| language | VARCHAR(20) | | Programming language |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last update time |
| last_modified_by | BIGINT | FOREIGN KEY (users.id) | User who last modified |

**Indexes:**
- PRIMARY KEY (id)
- FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
- FOREIGN KEY (last_modified_by) REFERENCES users(id) ON DELETE SET NULL
- INDEX idx_project (project_id)
- UNIQUE KEY unique_file_path (project_id, file_path)

---

### 5. learning_topics

Stores available learning topics/categories.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique topic ID |
| title | VARCHAR(200) | NOT NULL | Topic title |
| description | TEXT | | Topic description |
| category | VARCHAR(50) | | Category (e.g., "OOPs", "DSA", "Collections") |
| difficulty_level | VARCHAR(20) | DEFAULT 'BEGINNER' | Difficulty (BEGINNER, INTERMEDIATE, ADVANCED) |
| order_index | INT | DEFAULT 0 | Display order |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |

**Indexes:**
- PRIMARY KEY (id)
- INDEX idx_category (category)
- INDEX idx_difficulty (difficulty_level)

---

### 6. exercises

Stores coding exercises for interactive learning.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique exercise ID |
| topic_id | BIGINT | FOREIGN KEY (learning_topics.id), NOT NULL | Associated topic |
| title | VARCHAR(200) | NOT NULL | Exercise title |
| description | TEXT | NOT NULL | Exercise description |
| starter_code | TEXT | | Initial code template |
| solution_code | TEXT | | Solution code (for validation) |
| hints | JSON | | Array of hints (JSON format) |
| difficulty | VARCHAR(20) | DEFAULT 'BEGINNER' | Difficulty level |
| order_index | INT | DEFAULT 0 | Order within topic |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |

**Indexes:**
- PRIMARY KEY (id)
- FOREIGN KEY (topic_id) REFERENCES learning_topics(id) ON DELETE CASCADE
- INDEX idx_topic (topic_id)
- INDEX idx_difficulty (difficulty)

---

### 7. user_progress

Tracks user progress in learning exercises.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique record ID |
| user_id | BIGINT | FOREIGN KEY (users.id), NOT NULL | User ID |
| exercise_id | BIGINT | FOREIGN KEY (exercises.id), NOT NULL | Exercise ID |
| status | VARCHAR(20) | DEFAULT 'NOT_STARTED' | Status (NOT_STARTED, IN_PROGRESS, COMPLETED) |
| user_code | TEXT | | User's submitted code |
| is_correct | BOOLEAN | | Whether solution is correct |
| attempts | INT | DEFAULT 0 | Number of attempts |
| completed_at | TIMESTAMP | NULL | Completion timestamp |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation time |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last update time |

**Indexes:**
- PRIMARY KEY (id)
- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
- FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
- UNIQUE KEY unique_user_exercise (user_id, exercise_id)
- INDEX idx_user (user_id)
- INDEX idx_exercise (exercise_id)

---

### 8. ai_interactions

Logs AI assistant interactions for analytics and improvement.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique interaction ID |
| user_id | BIGINT | FOREIGN KEY (users.id) | User who requested AI help |
| project_id | BIGINT | FOREIGN KEY (projects.id) | Associated project (if any) |
| exercise_id | BIGINT | FOREIGN KEY (exercises.id) | Associated exercise (if any) |
| interaction_type | VARCHAR(50) | NOT NULL | Type (CODE_SUGGESTION, ERROR_EXPLANATION, CONCEPT_EXPLANATION, HINT) |
| user_query | TEXT | | User's question/request |
| ai_response | TEXT | | AI's response |
| context_code | TEXT | | Relevant code context |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Interaction timestamp |

**Indexes:**
- PRIMARY KEY (id)
- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
- FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL
- FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE SET NULL
- INDEX idx_user (user_id)
- INDEX idx_type (interaction_type)
- INDEX idx_created_at (created_at)

---

## SQL Creation Script

See `backend/src/main/resources/db/migration/schema.sql` for the complete SQL script.

## Relationships Summary

1. **users** ↔ **projects**: One-to-Many (owner) + Many-to-Many (collaborators via project_collaborators)
2. **projects** ↔ **code_files**: One-to-Many
3. **users** ↔ **user_progress**: One-to-Many
4. **exercises** ↔ **user_progress**: One-to-Many
5. **learning_topics** ↔ **exercises**: One-to-Many
6. **users** ↔ **ai_interactions**: One-to-Many
7. **projects** ↔ **ai_interactions**: One-to-Many (optional)
8. **exercises** ↔ **ai_interactions**: One-to-Many (optional)

## Notes

- All timestamps use MySQL TIMESTAMP type with automatic defaults
- Foreign keys use CASCADE DELETE where appropriate (e.g., deleting a project deletes its files)
- SET NULL is used for optional relationships (e.g., last_modified_by)
- Indexes are created for frequently queried columns
- Password hashing is handled in the application layer (BCrypt)
