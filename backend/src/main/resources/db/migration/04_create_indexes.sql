-- =====================================================
-- Additional Indexes for Performance Optimization
-- =====================================================

USE codesphere_db;

-- =====================================================
-- Composite Indexes for Common Query Patterns
-- =====================================================

-- For querying projects by owner and status
CREATE INDEX idx_projects_owner_archived ON projects(owner_id, is_archived);

-- For querying collaborators by project and role
CREATE INDEX idx_collaborators_project_role ON project_collaborators(project_id, role);

-- For querying files by project and language
CREATE INDEX idx_files_project_language ON code_files(project_id, language);

-- For querying exercises by topic and difficulty
CREATE INDEX idx_exercises_topic_difficulty ON exercises(topic_id, difficulty);

-- For querying user progress by user and status
CREATE INDEX idx_progress_user_status ON user_progress(user_id, status);

-- For querying AI interactions by user and type
CREATE INDEX idx_ai_user_type ON ai_interactions(user_id, interaction_type);

-- For querying sessions by project and active status
CREATE INDEX idx_sessions_project_active ON sessions(project_id, is_active);

-- For querying notifications by user and read status
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);

-- =====================================================
-- Indexes for Date Range Queries
-- =====================================================

-- For querying recent projects
CREATE INDEX idx_projects_updated_at ON projects(updated_at DESC);

-- For querying recent file changes
CREATE INDEX idx_files_updated_at ON code_files(updated_at DESC);

-- For querying recent AI interactions
CREATE INDEX idx_ai_created_at ON ai_interactions(created_at DESC);

-- For querying recent notifications
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

-- =====================================================
-- END OF ADDITIONAL INDEXES
-- =====================================================
