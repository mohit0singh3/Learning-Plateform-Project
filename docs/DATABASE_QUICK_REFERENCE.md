# Database Quick Reference Guide

## Quick Setup

```bash
# Option 1: Run master script
mysql -u root -p < backend/src/main/resources/db/migration/00_master_schema.sql

# Option 2: Run individual files
cd backend/src/main/resources/db/migration
mysql -u root -p cursor_ai_db < 01_create_database.sql
mysql -u root -p cursor_ai_db < 02_insert_sample_data.sql
mysql -u root -p cursor_ai_db < 03_create_views.sql
mysql -u root -p cursor_ai_db < 04_create_indexes.sql
```

## Tables Overview

| Table | Purpose | Key Relationships |
|-------|---------|-------------------|
| `users` | User accounts | Owner of projects, collaborator |
| `projects` | Code projects | Has files, has collaborators |
| `project_collaborators` | User-project links | Links users to projects |
| `code_files` | Code files | Belongs to project |
| `learning_topics` | Topics | Has exercises |
| `exercises` | Exercises | Belongs to topic |
| `user_progress` | Progress tracking | Links users to exercises |
| `ai_interactions` | AI logs | Links to users/projects/exercises |
| `sessions` | Active sessions | Links users to projects |
| `file_history` | File versions | Links to files |
| `notifications` | Notifications | Links to users |

## Common Queries

### Get User's Projects
```sql
SELECT * FROM projects WHERE owner_id = ?;
```

### Get Project Collaborators
```sql
SELECT u.*, pc.role 
FROM project_collaborators pc
JOIN users u ON pc.user_id = u.id
WHERE pc.project_id = ?;
```

### Get Project Files
```sql
SELECT * FROM code_files WHERE project_id = ? ORDER BY updated_at DESC;
```

### Get User Progress
```sql
SELECT e.*, up.status, up.score
FROM exercises e
LEFT JOIN user_progress up ON e.id = up.exercise_id AND up.user_id = ?
WHERE e.topic_id = ?;
```

### Get Active Sessions
```sql
SELECT * FROM active_project_sessions WHERE project_id = ?;
```

## Indexes Quick Reference

### Primary Indexes
- All tables: `id` (PRIMARY KEY)

### Foreign Key Indexes
- `projects.owner_id` → `users.id`
- `code_files.project_id` → `projects.id`
- `project_collaborators.project_id` → `projects.id`
- `project_collaborators.user_id` → `users.id`
- `user_progress.user_id` → `users.id`
- `user_progress.exercise_id` → `exercises.id`

### Unique Indexes
- `users.username`
- `users.email`
- `project_collaborators(project_id, user_id)`
- `code_files(project_id, file_path)`
- `user_progress(user_id, exercise_id)`

## Data Types Quick Reference

- **IDs**: `BIGINT AUTO_INCREMENT`
- **Usernames**: `VARCHAR(50)`
- **Emails**: `VARCHAR(100)`
- **Passwords**: `VARCHAR(255)` (BCrypt hash)
- **Titles**: `VARCHAR(200)`
- **Descriptions**: `TEXT`
- **File Content**: `LONGTEXT`
- **Booleans**: `BOOLEAN`
- **Timestamps**: `TIMESTAMP`
- **JSON Data**: `JSON`
- **Enums**: `ENUM(...)`

## Sample Data

After running migrations, you'll have:
- 4 sample users (john_doe, jane_smith, prof_java, admin_user)
- 12 learning topics
- 5 exercises
- 4 sample projects
- Sample code files

**Default Password**: `password123` (for all sample users)

## Views Available

1. `user_project_summary` - Projects with stats
2. `user_learning_progress` - Learning progress by category
3. `active_project_sessions` - Active sessions
4. `project_file_summary` - File stats per project
5. `user_activity_summary` - User activity overview

## Maintenance Commands

### Check Table Sizes
```sql
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS size_mb
FROM information_schema.TABLES
WHERE table_schema = 'cursor_ai_db'
ORDER BY size_mb DESC;
```

### Check Index Usage
```sql
SHOW INDEX FROM table_name;
```

### Analyze Table
```sql
ANALYZE TABLE table_name;
```

### Optimize Table
```sql
OPTIMIZE TABLE table_name;
```

## Backup & Restore

### Backup
```bash
mysqldump -u root -p cursor_ai_db > backup.sql
```

### Restore
```bash
mysql -u root -p cursor_ai_db < backup.sql
```

## Troubleshooting

### Foreign Key Errors
- Ensure parent records exist before inserting child records
- Check CASCADE DELETE settings

### Index Issues
- Run `ANALYZE TABLE` after bulk inserts
- Check index usage with `EXPLAIN`

### Performance Issues
- Check slow query log
- Review index usage
- Consider partitioning large tables

## ERD Relationships

```
users (1) ──→ (M) projects
users (M) ──→ (M) projects [via project_collaborators]
projects (1) ──→ (M) code_files
projects (1) ──→ (M) sessions
users (1) ──→ (M) user_progress
exercises (1) ──→ (M) user_progress
learning_topics (1) ──→ (M) exercises
users (1) ──→ (M) ai_interactions
code_files (1) ──→ (M) file_history
```

## File Locations

- **Schema**: `backend/src/main/resources/db/migration/01_create_database.sql`
- **Sample Data**: `backend/src/main/resources/db/migration/02_insert_sample_data.sql`
- **Views**: `backend/src/main/resources/db/migration/03_create_views.sql`
- **Indexes**: `backend/src/main/resources/db/migration/04_create_indexes.sql`
- **Documentation**: `docs/DATABASE_DESIGN.md`
