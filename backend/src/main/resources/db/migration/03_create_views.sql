-- =====================================================
-- Useful Views for Common Queries
-- =====================================================

USE codesphere_db;

-- =====================================================
-- VIEW: user_project_summary
-- Purpose: Summary of user's projects with collaborator count
-- =====================================================
CREATE OR REPLACE VIEW user_project_summary AS
SELECT 
    p.id,
    p.name,
    p.description,
    p.language,
    p.is_public,
    p.owner_id,
    u.username AS owner_username,
    COUNT(DISTINCT pc.user_id) AS collaborator_count,
    COUNT(DISTINCT cf.id) AS file_count,
    p.created_at,
    p.updated_at,
    p.last_accessed_at
FROM projects p
LEFT JOIN users u ON p.owner_id = u.id
LEFT JOIN project_collaborators pc ON p.id = pc.project_id
LEFT JOIN code_files cf ON p.id = cf.project_id
GROUP BY p.id, p.name, p.description, p.language, p.is_public, p.owner_id, u.username, p.created_at, p.updated_at, p.last_accessed_at;

-- =====================================================
-- VIEW: user_learning_progress
-- Purpose: User's learning progress summary
-- =====================================================
CREATE OR REPLACE VIEW user_learning_progress AS
SELECT 
    u.id AS user_id,
    u.username,
    lt.category,
    COUNT(DISTINCT e.id) AS total_exercises,
    COUNT(DISTINCT CASE WHEN up.status = 'COMPLETED' THEN e.id END) AS completed_exercises,
    COUNT(DISTINCT CASE WHEN up.status = 'IN_PROGRESS' THEN e.id END) AS in_progress_exercises,
    SUM(CASE WHEN up.status = 'COMPLETED' THEN up.score ELSE 0 END) AS total_score,
    SUM(CASE WHEN up.status = 'COMPLETED' THEN e.points ELSE 0 END) AS max_possible_score
FROM users u
CROSS JOIN learning_topics lt
LEFT JOIN exercises e ON lt.id = e.topic_id
LEFT JOIN user_progress up ON e.id = up.exercise_id AND up.user_id = u.id
GROUP BY u.id, u.username, lt.category;

-- =====================================================
-- VIEW: active_project_sessions
-- Purpose: Currently active user sessions in projects
-- =====================================================
CREATE OR REPLACE VIEW active_project_sessions AS
SELECT 
    s.id AS session_id,
    s.project_id,
    p.name AS project_name,
    s.user_id,
    u.username,
    u.full_name,
    s.connected_at,
    s.last_activity_at,
    TIMESTAMPDIFF(SECOND, s.connected_at, NOW()) AS session_duration_seconds
FROM sessions s
INNER JOIN projects p ON s.project_id = p.id
INNER JOIN users u ON s.user_id = u.id
WHERE s.is_active = TRUE
ORDER BY s.last_activity_at DESC;

-- =====================================================
-- VIEW: project_file_summary
-- Purpose: Summary of files in each project
-- =====================================================
CREATE OR REPLACE VIEW project_file_summary AS
SELECT 
    p.id AS project_id,
    p.name AS project_name,
    COUNT(cf.id) AS total_files,
    SUM(cf.file_size) AS total_size_bytes,
    SUM(cf.line_count) AS total_lines,
    COUNT(DISTINCT cf.language) AS languages_used,
    MAX(cf.updated_at) AS last_file_update
FROM projects p
LEFT JOIN code_files cf ON p.id = cf.project_id
GROUP BY p.id, p.name;

-- =====================================================
-- VIEW: user_activity_summary
-- Purpose: User activity summary
-- =====================================================
CREATE OR REPLACE VIEW user_activity_summary AS
SELECT 
    u.id AS user_id,
    u.username,
    COUNT(DISTINCT p.id) AS projects_owned,
    COUNT(DISTINCT pc.project_id) AS projects_collaborated,
    COUNT(DISTINCT up.exercise_id) AS exercises_attempted,
    COUNT(DISTINCT CASE WHEN up.status = 'COMPLETED' THEN up.exercise_id END) AS exercises_completed,
    COUNT(DISTINCT ai.id) AS ai_interactions,
    u.last_login_at,
    u.created_at
FROM users u
LEFT JOIN projects p ON u.id = p.owner_id
LEFT JOIN project_collaborators pc ON u.id = pc.user_id
LEFT JOIN user_progress up ON u.id = up.user_id
LEFT JOIN ai_interactions ai ON u.id = ai.user_id
GROUP BY u.id, u.username, u.last_login_at, u.created_at;

-- =====================================================
-- END OF VIEWS
-- =====================================================
