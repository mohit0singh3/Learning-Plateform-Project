# Complete Database Design Documentation

## Overview

This document provides a comprehensive guide to the MySQL database design for the CodeSphere platform.

## Database Information

- **Database Name**: `codesphere_db`
- **Character Set**: `utf8mb4`
- **Collation**: `utf8mb4_unicode_ci`
- **Engine**: InnoDB (for foreign keys and transactions)

## Table Summary

| Table Name | Purpose | Records (Est.) |
|------------|---------|----------------|
| users | User accounts | 1K - 100K |
| projects | Code projects | 10K - 1M |
| project_collaborators | User-project relationships | 50K - 10M |
| code_files | Code files in projects | 100K - 100M |
| learning_topics | Learning topics | 100 - 1K |
| exercises | Coding exercises | 1K - 10K |
| user_progress | User exercise progress | 100K - 10M |
| ai_interactions | AI interaction logs | 1M - 100M |
| sessions | Active user sessions | 1K - 100K |
| file_history | File version history | 1M - 1B |
| notifications | User notifications | 100K - 10M |

## Entity Relationship Diagram

```
┌─────────────┐
│    users    │
└──────┬──────┘
       │
       ├─────────────────────────────────┐
       │                                 │
       ▼                                 ▼
┌──────────────────┐          ┌──────────────────┐
│    projects       │          │ project_         │
│  (owner_id)       │          │ collaborators     │
└──────┬────────────┘          └──────────────────┘
       │                                 │
       │                                 │
       ▼                                 │
┌─────────────┐                         │
│ code_files  │                         │
└─────────────┘                         │
                                         │
       ┌─────────────────────────────────┘
       │
       ▼
┌─────────────┐
│  sessions   │
└─────────────┘

┌─────────────┐
│    users    │
└──────┬──────┘
       │
       ├──────────────────┐
       │                  │
       ▼                  ▼
┌─────────────┐   ┌─────────────┐
│user_progress│   │ai_interactions│
└──────┬──────┘   └─────────────┘
       │
       │
       ▼
┌─────────────┐
│ exercises   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│learning_    │
│topics       │
└─────────────┘
```

## Detailed Table Specifications

### 1. users

**Purpose**: Store user accounts and authentication data

**Key Fields**:
- `id`: Primary key
- `username`: Unique username (indexed)
- `email`: Unique email (indexed)
- `password_hash`: BCrypt hashed password
- `role`: ENUM (STUDENT, INSTRUCTOR, ADMIN)

**Indexes**:
- Primary key on `id`
- Unique index on `username`
- Unique index on `email`
- Index on `role`
- Index on `is_active`

**Relationships**:
- One-to-many with `projects` (owner)
- Many-to-many with `projects` via `project_collaborators`
- One-to-many with `user_progress`
- One-to-many with `ai_interactions`
- One-to-many with `sessions`

### 2. projects

**Purpose**: Store code projects for collaboration

**Key Fields**:
- `id`: Primary key
- `owner_id`: Foreign key to `users.id`
- `name`: Project name (fulltext indexed)
- `language`: Programming language
- `is_public`: Visibility flag
- `settings`: JSON for project settings

**Indexes**:
- Primary key on `id`
- Foreign key index on `owner_id`
- Index on `language`
- Index on `is_public`
- Fulltext index on `name`, `description`

**Relationships**:
- Many-to-one with `users` (owner)
- One-to-many with `code_files`
- One-to-many with `project_collaborators`
- One-to-many with `sessions`

### 3. project_collaborators

**Purpose**: Many-to-many relationship between users and projects

**Key Fields**:
- `id`: Primary key
- `project_id`: Foreign key to `projects.id`
- `user_id`: Foreign key to `users.id`
- `role`: ENUM (OWNER, EDITOR, VIEWER)
- Unique constraint on (`project_id`, `user_id`)

**Indexes**:
- Primary key on `id`
- Foreign key indexes
- Unique index on (`project_id`, `user_id`)
- Index on `role`

### 4. code_files

**Purpose**: Store code files within projects

**Key Fields**:
- `id`: Primary key
- `project_id`: Foreign key to `projects.id`
- `file_path`: Unique within project
- `content`: LONGTEXT for file content
- `language`: Auto-detected language
- Unique constraint on (`project_id`, `file_path`)

**Indexes**:
- Primary key on `id`
- Foreign key index on `project_id`
- Unique index on (`project_id`, `file_path`)
- Index on `language`
- Fulltext index on `content` (first 1000 chars)

### 5. learning_topics

**Purpose**: Store learning topics/categories

**Key Fields**:
- `id`: Primary key
- `category`: Topic category
- `difficulty_level`: ENUM (BEGINNER, INTERMEDIATE, ADVANCED)
- `order_index`: Display order

**Indexes**:
- Primary key on `id`
- Index on `category`
- Index on `difficulty_level`
- Fulltext index on `title`, `description`

### 6. exercises

**Purpose**: Store coding exercises

**Key Fields**:
- `id`: Primary key
- `topic_id`: Foreign key to `learning_topics.id`
- `starter_code`: Initial code template
- `solution_code`: Solution for validation
- `test_cases`: JSON array
- `hints`: JSON array

**Indexes**:
- Primary key on `id`
- Foreign key index on `topic_id`
- Index on `difficulty`
- Fulltext index on `title`, `description`

### 7. user_progress

**Purpose**: Track user progress in exercises

**Key Fields**:
- `id`: Primary key
- `user_id`: Foreign key to `users.id`
- `exercise_id`: Foreign key to `exercises.id`
- `status`: ENUM (NOT_STARTED, IN_PROGRESS, COMPLETED, SKIPPED)
- `user_code`: User's submitted code
- `is_correct`: Validation result
- Unique constraint on (`user_id`, `exercise_id`)

**Indexes**:
- Primary key on `id`
- Foreign key indexes
- Unique index on (`user_id`, `exercise_id`)
- Index on `status`

### 8. ai_interactions

**Purpose**: Log AI assistant interactions

**Key Fields**:
- `id`: Primary key
- `user_id`: Foreign key to `users.id` (nullable)
- `interaction_type`: ENUM (CODE_SUGGESTION, ERROR_EXPLANATION, etc.)
- `user_query`: User's question
- `ai_response`: AI's response
- `tokens_used`: For cost tracking
- `rating`: User rating (1-5)

**Indexes**:
- Primary key on `id`
- Foreign key indexes (nullable)
- Index on `interaction_type`
- Index on `created_at`

### 9. sessions

**Purpose**: Track active WebSocket sessions

**Key Fields**:
- `id`: Primary key
- `user_id`: Foreign key to `users.id`
- `project_id`: Foreign key to `projects.id`
- `session_token`: Unique session identifier
- `socket_id`: WebSocket socket ID
- `is_active`: Active status flag

**Indexes**:
- Primary key on `id`
- Foreign key indexes
- Unique index on `session_token`
- Index on `socket_id`
- Index on `is_active`

### 10. file_history

**Purpose**: Track file change history (optional)

**Key Fields**:
- `id`: Primary key
- `file_id`: Foreign key to `code_files.id`
- `content_snapshot`: File content at this point
- `change_type`: ENUM (CREATE, UPDATE, DELETE, RENAME)

**Indexes**:
- Primary key on `id`
- Foreign key index on `file_id`
- Index on `created_at`

### 11. notifications

**Purpose**: Store user notifications

**Key Fields**:
- `id`: Primary key
- `user_id`: Foreign key to `users.id`
- `type`: Notification type
- `is_read`: Read status
- `created_at`: Notification timestamp

**Indexes**:
- Primary key on `id`
- Foreign key index on `user_id`
- Index on `is_read`
- Index on `created_at`

## Views

### user_project_summary
Summary of projects with collaborator and file counts.

### user_learning_progress
User's learning progress by category.

### active_project_sessions
Currently active user sessions in projects.

### project_file_summary
Summary of files in each project.

### user_activity_summary
Comprehensive user activity summary.

## Indexing Strategy

### Primary Indexes
- All tables have primary key on `id` (BIGINT AUTO_INCREMENT)

### Foreign Key Indexes
- All foreign keys are indexed for join performance

### Composite Indexes
- Created for common query patterns (e.g., `(project_id, is_active)`)

### Fulltext Indexes
- On `projects.name`, `projects.description`
- On `code_files.content` (first 1000 chars)
- On `learning_topics.title`, `learning_topics.description`
- On `exercises.title`, `exercises.description`

## Data Types

### IDs
- `BIGINT`: For all primary keys and foreign keys (supports up to 9.2 quintillion records)

### Strings
- `VARCHAR(50)`: Short strings (usernames, roles)
- `VARCHAR(100)`: Medium strings (emails, names)
- `VARCHAR(200)`: Longer strings (titles)
- `VARCHAR(255)`: Standard string length (filenames)
- `VARCHAR(500)`: Long strings (paths, URLs)
- `TEXT`: Variable-length text (descriptions)
- `LONGTEXT`: Very long text (file content)

### Numbers
- `INT`: Standard integers (counts, indices)
- `BIGINT`: Large integers (file sizes, IDs)

### Booleans
- `BOOLEAN`: TRUE/FALSE flags

### Dates
- `TIMESTAMP`: Automatic timestamp management

### JSON
- `JSON`: Structured data (settings, test cases, hints)

### ENUMs
- Used for fixed value sets (roles, statuses, types)

## Constraints

### Primary Keys
- All tables have `id` as primary key

### Foreign Keys
- Cascade delete for dependent records
- Set NULL for optional relationships

### Unique Constraints
- `users.username`
- `users.email`
- `project_collaborators(project_id, user_id)`
- `code_files(project_id, file_path)`
- `user_progress(user_id, exercise_id)`
- `sessions.session_token`

### Check Constraints
- Can be added for data validation (MySQL 8.0.16+)

## Performance Considerations

### Indexing
- Indexes on frequently queried columns
- Composite indexes for multi-column queries
- Fulltext indexes for search functionality

### Partitioning
- Can partition large tables (e.g., `file_history`, `ai_interactions`) by date

### Archiving
- `is_archived` flag on projects for soft deletion
- Can archive old data to separate tables

### Caching
- Consider caching frequently accessed data (user sessions, project metadata)

## Security Considerations

### Password Storage
- Passwords stored as BCrypt hashes (never plain text)

### Data Access
- Foreign keys ensure referential integrity
- Application layer handles authorization

### SQL Injection
- Use parameterized queries (handled by JPA/Hibernate)

## Migration Strategy

1. Run `01_create_database.sql` - Creates all tables
2. Run `02_insert_sample_data.sql` - Inserts sample data
3. Run `03_create_views.sql` - Creates useful views
4. Run `04_create_indexes.sql` - Creates additional indexes

## Maintenance

### Regular Tasks
- Monitor index usage
- Analyze table statistics
- Optimize queries
- Archive old data
- Backup regularly

### Monitoring
- Track table sizes
- Monitor query performance
- Check index usage
- Review slow queries

## Sample Queries

### Get user's projects with file counts
```sql
SELECT * FROM user_project_summary WHERE owner_id = ?;
```

### Get user's learning progress
```sql
SELECT * FROM user_learning_progress WHERE user_id = ?;
```

### Get active sessions in a project
```sql
SELECT * FROM active_project_sessions WHERE project_id = ?;
```

## Notes

- All timestamps use MySQL TIMESTAMP with automatic defaults
- Foreign keys use CASCADE DELETE for dependent records
- SET NULL for optional relationships
- UTF8MB4 character set supports emojis and special characters
- InnoDB engine supports transactions and foreign keys
