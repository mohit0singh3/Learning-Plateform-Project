-- =====================================================
-- CodeSphere Platform - Master Database Schema Script
-- MySQL 8.0+
-- =====================================================
-- This is the master script that runs all migrations
-- Run this script to set up the complete database
-- =====================================================

-- Source all migration files in order
SOURCE 01_create_database.sql;
SOURCE 02_insert_sample_data.sql;
SOURCE 03_create_views.sql;
SOURCE 04_create_indexes.sql;

-- =====================================================
-- Alternative: Run individual files manually
-- =====================================================
-- 1. mysql -u root -p < 01_create_database.sql
-- 2. mysql -u root -p < 02_insert_sample_data.sql
-- 3. mysql -u root -p < 03_create_views.sql
-- 4. mysql -u root -p < 04_create_indexes.sql
-- =====================================================
