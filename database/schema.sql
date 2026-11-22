SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
CREATE TABLE `academic_groups` (
  `id` char(36) NOT NULL,
  `university_id` char(36) NOT NULL,
  `canonical_code` varchar(40) NOT NULL,
  `admission_year` smallint NOT NULL,
  `academic_year` varchar(9) NOT NULL,
  `archived_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `announcement_materials` (
  `announcement_id` char(36) NOT NULL,
  `material_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `api_tokens` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `name` varchar(80) NOT NULL,
  `token_prefix` varchar(16) NOT NULL,
  `token_hash` char(64) NOT NULL,
  `scopes` json NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `expires_at` datetime(6) NOT NULL,
  `last_used_at` datetime(6) DEFAULT NULL,
  `revoked_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `assessments` (
  `id` char(36) NOT NULL,
  `subject_id` char(36) NOT NULL,
  `external_id` varchar(100) NOT NULL,
  `title` varchar(180) NOT NULL,
  `topic` varchar(240) DEFAULT NULL,
  `weight` decimal(12,6) DEFAULT NULL,
  `max_score` decimal(16,6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `audit_events` (
  `id` char(36) NOT NULL,
  `actor_user_id` char(36) DEFAULT NULL,
  `target_group_id` char(36) DEFAULT NULL,
  `action` varchar(80) NOT NULL,
  `target_type` varchar(40) DEFAULT NULL,
  `target_id` char(36) DEFAULT NULL,
  `occurred_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `result` varchar(40) NOT NULL,
  `correlation_id` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `bars_academic_watch` (
  `user_id` char(36) NOT NULL,
  `resource` varchar(16) NOT NULL,
  `next_check_at` datetime(6) NOT NULL,
  `observed_state` json DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `bars_accounts` (
  `login_key` char(64) NOT NULL,
  `login` varchar(100) NOT NULL,
  `user_id` char(36) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `verified_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `bars_auth_flows` (
  `token_hash` char(64) NOT NULL,
  `browser_hash` char(64) NOT NULL,
  `ciphertext` mediumtext NOT NULL,
  `expires_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `bars_rating_points` (
  `user_id` char(36) NOT NULL,
  `semester` varchar(50) NOT NULL,
  `metric` varchar(20) NOT NULL,
  `observed_date` date NOT NULL,
  `value` decimal(16,6) NOT NULL,
  `observed_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `buildings` (
  `id` char(36) NOT NULL,
  `university_id` char(36) NOT NULL,
  `name` varchar(120) NOT NULL,
  `address` varchar(240) NOT NULL,
  `lat` decimal(10,7) DEFAULT NULL,
  `lon` decimal(10,7) DEFAULT NULL,
  `source_url` varchar(500) DEFAULT NULL,
  `location_verified` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `calendar_exports` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `provider` varchar(40) NOT NULL,
  `external_calendar_id` varchar(191) DEFAULT NULL,
  `event_key` varchar(191) NOT NULL,
  `last_etag` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `calendar_subscriptions` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `membership_id` char(36) DEFAULT NULL,
  `token_hash` char(64) NOT NULL,
  `include_homework` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `expires_at` datetime(6) NOT NULL,
  `revoked_at` datetime(6) DEFAULT NULL,
  `ruz_group` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `class_meetings` (
  `id` char(36) NOT NULL,
  `provider` varchar(40) NOT NULL,
  `provider_external_id` varchar(100) NOT NULL,
  `group_id` char(36) NOT NULL,
  `term_id` char(36) NOT NULL,
  `subject_id` char(36) NOT NULL,
  `room_id` char(36) DEFAULT NULL,
  `subgroup_id` char(36) DEFAULT NULL,
  `start_at` datetime(6) NOT NULL,
  `end_at` datetime(6) NOT NULL,
  `class_type` varchar(40) NOT NULL,
  `topic` varchar(240) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'scheduled',
  `source` varchar(40) NOT NULL,
  `last_synced_at` datetime(6) NOT NULL,
  `revision` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `consent_events` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `purpose` varchar(60) NOT NULL,
  `policy_version` varchar(30) NOT NULL,
  `granted_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `revoked_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `content_reports` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `target_type` varchar(30) NOT NULL,
  `target_id` char(36) NOT NULL,
  `reason` varchar(500) NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `dashboard_widgets` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `widget_type` varchar(30) NOT NULL,
  `position` int NOT NULL,
  `is_visible` tinyint(1) NOT NULL DEFAULT '1',
  `options_json` json DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `drive_sync_entries` (
  `id` char(36) NOT NULL,
  `root_id` char(36) NOT NULL,
  `remote_id` varchar(160) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `parent_id` varchar(160) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `material_id` char(36) DEFAULT NULL,
  `local_file_id` char(36) DEFAULT NULL,
  `base_file_id` char(36) DEFAULT NULL,
  `replaces_id` char(36) DEFAULT NULL,
  `upload_file_id` char(36) DEFAULT NULL,
  `upload_session` text,
  `name` varchar(240) NOT NULL,
  `mime_type` varchar(120) DEFAULT NULL,
  `size_bytes` bigint UNSIGNED DEFAULT NULL,
  `sha256` char(64) DEFAULT NULL,
  `local_metadata` char(64) DEFAULT NULL,
  `remote_version` varchar(40) DEFAULT NULL,
  `remote_modified_at` varchar(40) DEFAULT NULL,
  `synced_at` datetime(6) DEFAULT NULL,
  `last_direction` varchar(12) DEFAULT NULL,
  `state` varchar(24) NOT NULL DEFAULT 'pending',
  `resolution` varchar(16) DEFAULT NULL,
  `error_code` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `drive_sync_events` (
  `id` bigint UNSIGNED NOT NULL,
  `run_id` char(36) NOT NULL,
  `entry_id` char(36) DEFAULT NULL,
  `direction` varchar(12) NOT NULL,
  `event` varchar(32) NOT NULL,
  `name` varchar(240) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `drive_sync_roots` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `group_id` char(36) NOT NULL,
  `term_id` char(36) NOT NULL,
  `account_key` char(64) NOT NULL,
  `folder_id` varchar(160) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `folder_name` varchar(255) NOT NULL,
  `page_token` text,
  `auto_sync` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `last_success_at` datetime(6) DEFAULT NULL,
  `backup_hash` char(64) DEFAULT NULL,
  `next_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `tree_ready` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `drive_sync_runs` (
  `id` char(36) NOT NULL,
  `root_id` char(36) NOT NULL,
  `direction` varchar(12) NOT NULL,
  `initiator` varchar(12) NOT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'pending',
  `stage` varchar(16) NOT NULL DEFAULT 'start',
  `progress` json NOT NULL,
  `checkpoint` json NOT NULL,
  `error_code` varchar(60) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `started_at` datetime(6) DEFAULT NULL,
  `finished_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `drive_sync_versions` (
  `root_id` char(36) NOT NULL,
  `file_id` char(36) NOT NULL,
  `remote_id` varchar(160) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `revision_id` varchar(160) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `favorite_subjects` (
  `user_id` char(36) NOT NULL,
  `subject_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `google_backup_jobs` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `status` varchar(40) NOT NULL,
  `started_at` datetime(6) DEFAULT NULL,
  `finished_at` datetime(6) DEFAULT NULL,
  `manifest_version` int NOT NULL DEFAULT '1',
  `remote_file_id` varchar(191) DEFAULT NULL,
  `error_redacted` varchar(240) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `google_connections` (
  `user_id` char(36) NOT NULL,
  `google_subject` varchar(191) DEFAULT NULL,
  `scopes` json NOT NULL,
  `tokens_encrypted` mediumtext NOT NULL,
  `expiry` datetime(6) DEFAULT NULL,
  `revoked_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `google_drive_copies` (
  `material_file_id` char(36) NOT NULL,
  `recipient_user_id` char(36) NOT NULL,
  `account_key` char(64) NOT NULL,
  `drive_id` varchar(160) DEFAULT NULL,
  `web_view_link` varchar(512) DEFAULT NULL,
  `folder_drive_id` varchar(160) DEFAULT NULL,
  `sha256` char(64) NOT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'pending',
  `attempts` int UNSIGNED NOT NULL DEFAULT '0',
  `last_error_code` varchar(60) DEFAULT NULL,
  `upload_session_encrypted` text,
  `upload_offset` bigint UNSIGNED NOT NULL DEFAULT '0',
  `synced_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `google_drive_folders` (
  `user_id` char(36) NOT NULL,
  `account_key` char(64) NOT NULL,
  `folder_key` varchar(100) NOT NULL,
  `parent_key` varchar(100) DEFAULT NULL,
  `drive_id` varchar(160) DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'pending',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `group_announcements` (
  `id` char(36) NOT NULL,
  `group_id` char(36) NOT NULL,
  `term_id` char(36) NOT NULL,
  `author_user_id` char(36) NOT NULL,
  `title` varchar(180) NOT NULL,
  `body` text NOT NULL,
  `revision` int NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL,
  `subject_id` char(36) DEFAULT NULL,
  `related_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `group_memberships` (
  `id` char(36) NOT NULL,
  `group_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `term_id` char(36) NOT NULL,
  `role` varchar(24) NOT NULL DEFAULT 'student',
  `verified_source` varchar(240) NOT NULL,
  `verified_at` datetime(6) NOT NULL,
  `valid_from` datetime(6) NOT NULL,
  `valid_to` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `group_rating_profiles` (
  `user_id` char(36) NOT NULL,
  `group_id` char(36) DEFAULT NULL,
  `term_id` char(36) DEFAULT NULL,
  `visibility` enum('average','grades','hidden') NOT NULL,
  `generation` char(36) NOT NULL,
  `average_score` decimal(4,2) DEFAULT NULL,
  `subjects_json` json DEFAULT NULL,
  `absence_count` int unsigned DEFAULT NULL,
  `attendance_observed_at` datetime DEFAULT NULL,
  `observed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `headman_attendance_drafts` (
  `id` char(36) NOT NULL,
  `group_id` char(36) NOT NULL,
  `term_id` char(36) NOT NULL,
  `class_draft_id` char(36) NOT NULL,
  `creator_user_id` char(36) NOT NULL,
  `roster_snapshot` json NOT NULL,
  `marks_json` json NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'local_draft',
  `revision` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `headman_class_drafts` (
  `id` char(36) NOT NULL,
  `group_id` char(36) NOT NULL,
  `term_id` char(36) NOT NULL,
  `creator_user_id` char(36) NOT NULL,
  `source_meeting_id` char(36) DEFAULT NULL,
  `payload_json` json NOT NULL,
  `state` varchar(30) NOT NULL DEFAULT 'local_draft',
  `revision` int NOT NULL DEFAULT '1',
  `submitted_external_id` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `ruz_lesson_id` char(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `homework` (
  `id` char(36) NOT NULL,
  `group_id` char(36) DEFAULT NULL,
  `term_id` char(36) DEFAULT NULL,
  `subject_id` char(36) DEFAULT NULL,
  `linked_meeting_id` char(36) DEFAULT NULL,
  `author_user_id` char(36) NOT NULL,
  `title` varchar(180) NOT NULL,
  `description` text NOT NULL,
  `due_at` datetime(6) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'published',
  `revision` int NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL,
  `ruz_lesson_id` char(64) DEFAULT NULL,
  `ruz_lesson_date` date DEFAULT NULL,
  `ruz_subject_title` varchar(240) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `homework_attachments` (
  `homework_id` char(36) NOT NULL,
  `material_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `homework_comments` (
  `id` char(36) NOT NULL,
  `homework_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `body` text NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `homework_completions` (
  `homework_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `completed_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `homework_examples` (
  `id` char(36) NOT NULL,
  `homework_id` char(36) NOT NULL,
  `uploader_user_id` char(36) NOT NULL,
  `material_id` char(36) NOT NULL,
  `title` varchar(180) NOT NULL,
  `description` text NOT NULL,
  `published_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `homework_versions` (
  `id` char(36) NOT NULL,
  `homework_id` char(36) NOT NULL,
  `editor_user_id` char(36) NOT NULL,
  `old_data` json NOT NULL,
  `new_data` json NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `idempotency_keys` (
  `user_id` char(36) NOT NULL,
  `key_hash` char(64) NOT NULL,
  `request_hash` char(64) NOT NULL,
  `response_json` mediumtext,
  `response_status` smallint DEFAULT NULL,
  `expires_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `lesson_teachers` (
  `meeting_id` char(36) NOT NULL,
  `teacher_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `login_links` (
  `id` char(36) NOT NULL,
  `email` varchar(191) NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `used_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `materials` (
  `id` char(36) NOT NULL,
  `owner_user_id` char(36) NOT NULL,
  `group_id` char(36) DEFAULT NULL,
  `term_id` char(36) DEFAULT NULL,
  `subject_id` char(36) DEFAULT NULL,
  `visibility` varchar(16) NOT NULL,
  `title` varchar(180) NOT NULL,
  `description` text NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL,
  `category` varchar(20) NOT NULL DEFAULT 'materials',
  `course_title` varchar(240) DEFAULT NULL,
  `library_subject` varchar(16) DEFAULT NULL,
  `library_variant` char(64) DEFAULT NULL,
  `library_teacher` varchar(180) DEFAULT NULL,
  `drive_root_id` char(36) DEFAULT NULL,
  `drive_parent_id` varchar(160) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  KEY `material_drive_folder` (`drive_root_id`,`drive_parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `material_files` (
  `id` char(36) NOT NULL,
  `material_id` char(36) NOT NULL,
  `storage_key` char(36) NOT NULL,
  `original_name` varchar(240) NOT NULL,
  `mime_type` varchar(120) NOT NULL,
  `size_bytes` bigint UNSIGNED NOT NULL,
  `checksum_sha256` char(64) NOT NULL,
  `version` int NOT NULL,
  `scan_status` varchar(24) NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `material_lessons` (
  `material_id` char(36) NOT NULL,
  `meeting_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `mpei_mail_connections` (
  `session_id` char(36) NOT NULL,
  `generation` char(36) NOT NULL,
  `ciphertext` text NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `poll_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `uid_validity` bigint UNSIGNED NOT NULL,
  `uid_next` bigint UNSIGNED NOT NULL,
  `last_synced_at` datetime(6) DEFAULT NULL,
  `next_check_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `note_materials` (
  `note_id` char(36) NOT NULL,
  `material_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `recipient_user_id` char(36) NOT NULL,
  `type` varchar(40) NOT NULL,
  `title` varchar(180) NOT NULL,
  `body` varchar(500) NOT NULL,
  `related_type` varchar(40) DEFAULT NULL,
  `related_id` char(36) DEFAULT NULL,
  `dedupe_key` varchar(191) NOT NULL,
  `received_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `read_at` datetime(6) DEFAULT NULL,
  `expires_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `oauth_states` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `provider` varchar(32) NOT NULL,
  `hashed_nonce` char(64) NOT NULL,
  `verifier_encrypted` text NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `used_at` datetime(6) DEFAULT NULL,
  `session_id` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `official_attendance_snapshots` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `meeting_id` char(36) NOT NULL,
  `status` varchar(40) NOT NULL,
  `source_updated_at` datetime(6) DEFAULT NULL,
  `observed_at` datetime(6) NOT NULL,
  `source` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `official_grade_snapshots` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `subject_id` char(36) NOT NULL,
  `assessment_id` char(36) NOT NULL,
  `snapshot_time` datetime(6) NOT NULL,
  `raw_score` decimal(16,6) DEFAULT NULL,
  `max_score` decimal(16,6) DEFAULT NULL,
  `source_hash` char(64) NOT NULL,
  `source` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `personal_notes` (
  `id` char(36) NOT NULL,
  `owner_user_id` char(36) NOT NULL,
  `subject_id` char(36) DEFAULT NULL,
  `meeting_id` char(36) DEFAULT NULL,
  `title` varchar(180) NOT NULL,
  `body` mediumtext NOT NULL,
  `revision` int NOT NULL DEFAULT '1',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `provider_connections` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `provider` varchar(40) NOT NULL,
  `external_id` varchar(191) DEFAULT NULL,
  `connection_status` varchar(40) NOT NULL,
  `scopes` json NOT NULL,
  `last_verified_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `provider_credentials` (
  `id` char(36) NOT NULL,
  `connection_id` char(36) NOT NULL,
  `ciphertext` mediumtext NOT NULL,
  `key_version` varchar(20) NOT NULL,
  `expires_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `push_subscriptions` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `endpoint_hash` char(64) NOT NULL,
  `endpoint_ciphertext` text NOT NULL,
  `keys_encrypted` text NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `last_success_at` datetime(6) DEFAULT NULL,
  `last_mail_success_at` datetime(6) DEFAULT NULL,
  `session_id` char(36) DEFAULT NULL,
  `subscribed_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `ranking_snapshots` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `term_id` char(36) NOT NULL,
  `source` varchar(40) NOT NULL,
  `value` decimal(16,6) DEFAULT NULL,
  `criteria` varchar(240) DEFAULT NULL,
  `observed_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `rate_limits` (
  `bucket` char(64) NOT NULL,
  `window_start` bigint NOT NULL,
  `hits` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `rooms` (
  `id` char(36) NOT NULL,
  `building_id` char(36) NOT NULL,
  `official_room_code` varchar(40) NOT NULL,
  `floor` smallint DEFAULT NULL,
  `location_verified` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `student_subgroups` (
  `id` char(36) NOT NULL,
  `group_id` char(36) NOT NULL,
  `term_id` char(36) NOT NULL,
  `name` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `subgroup_memberships` (
  `subgroup_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `subjects` (
  `id` char(36) NOT NULL,
  `group_id` char(36) NOT NULL,
  `term_id` char(36) NOT NULL,
  `provider` varchar(40) NOT NULL,
  `external_id` varchar(100) NOT NULL,
  `title` varchar(180) NOT NULL,
  `short_title` varchar(60) DEFAULT NULL,
  `topics` json DEFAULT NULL,
  `archived_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `subject_title_history` (
  `id` char(36) NOT NULL,
  `subject_id` char(36) NOT NULL,
  `title` varchar(180) NOT NULL,
  `valid_from` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `sync_runs` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `provider` varchar(40) NOT NULL,
  `resource` varchar(40) NOT NULL,
  `trigger_type` varchar(24) NOT NULL,
  `started_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `ended_at` datetime(6) DEFAULT NULL,
  `status` varchar(40) NOT NULL,
  `rows_changed` int NOT NULL DEFAULT '0',
  `error_code` varchar(60) DEFAULT NULL,
  `redacted_message` varchar(240) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `teachers` (
  `id` char(36) NOT NULL,
  `university_id` char(36) NOT NULL,
  `provider` varchar(40) NOT NULL,
  `external_id` varchar(100) NOT NULL,
  `name` varchar(180) NOT NULL,
  `department` varchar(180) DEFAULT NULL,
  `contacts_allowed` json DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `terms` (
  `id` char(36) NOT NULL,
  `university_id` char(36) NOT NULL,
  `academic_year` varchar(9) NOT NULL,
  `season` varchar(16) NOT NULL,
  `begins_at` date NOT NULL,
  `ends_at` date NOT NULL,
  `archived_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `universities` (
  `id` char(36) NOT NULL,
  `code` varchar(40) NOT NULL,
  `name` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `email` varchar(191) DEFAULT NULL,
  `external_subject` varchar(191) DEFAULT NULL,
  `provider` varchar(40) DEFAULT NULL,
  `display_name` varchar(120) NOT NULL,
  `app_role` varchar(20) NOT NULL DEFAULT 'student',
  `email_verified_at` datetime(6) DEFAULT NULL,
  `university_verified_at` datetime(6) DEFAULT NULL,
  `official_authorized_until` datetime(6) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `fixture` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `last_login_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `user_preferences` (
  `user_id` char(36) NOT NULL,
  `preferences` json NOT NULL,
  `revision` int NOT NULL DEFAULT '1',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `user_profiles` (
  `user_id` char(36) NOT NULL,
  `preferred_locale` varchar(8) NOT NULL DEFAULT 'ru',
  `privacy_ack_at` datetime(6) DEFAULT NULL,
  `avatar_jpeg` mediumblob,
  `avatar_version` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `user_sessions` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `session_token_hash` char(64) NOT NULL,
  `device_label` varchar(100) NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `authenticated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `expires_at` datetime(6) NOT NULL,
  `revoked_at` datetime(6) DEFAULT NULL,
  `last_seen_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
ALTER TABLE `academic_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `university_id` (`university_id`,`canonical_code`,`admission_year`,`academic_year`);
ALTER TABLE `announcement_materials`
  ADD PRIMARY KEY (`announcement_id`,`material_id`),
  ADD KEY `material_id` (`material_id`);
ALTER TABLE `api_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token_hash` (`token_hash`),
  ADD KEY `user_id` (`user_id`,`revoked_at`);
ALTER TABLE `assessments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subject_id` (`subject_id`,`external_id`);
ALTER TABLE `audit_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `actor_user_id` (`actor_user_id`,`occurred_at`),
  ADD KEY `target_group_id` (`target_group_id`,`occurred_at`);
ALTER TABLE `bars_academic_watch`
  ADD PRIMARY KEY (`user_id`,`resource`);
ALTER TABLE `bars_accounts`
  ADD PRIMARY KEY (`login_key`),
  ADD KEY `user_id` (`user_id`);
ALTER TABLE `bars_auth_flows`
  ADD PRIMARY KEY (`token_hash`),
  ADD KEY `expires_at` (`expires_at`);
ALTER TABLE `bars_rating_points`
  ADD PRIMARY KEY (`user_id`,`semester`,`metric`,`observed_date`);
ALTER TABLE `buildings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `university_id` (`university_id`);
ALTER TABLE `calendar_exports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`provider`,`event_key`);
ALTER TABLE `calendar_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token_hash` (`token_hash`),
  ADD KEY `membership_id` (`membership_id`),
  ADD KEY `user_id` (`user_id`,`revoked_at`);
ALTER TABLE `class_meetings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `provider` (`provider`,`group_id`,`term_id`,`provider_external_id`),
  ADD KEY `group_id` (`group_id`,`term_id`,`start_at`),
  ADD KEY `term_id` (`term_id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `subgroup_id` (`subgroup_id`);
ALTER TABLE `consent_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);
ALTER TABLE `content_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);
ALTER TABLE `dashboard_widgets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`widget_type`);
ALTER TABLE `drive_sync_entries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `drive_sync_file` (`root_id`,`remote_id`),
  ADD UNIQUE KEY `drive_sync_local` (`root_id`,`local_file_id`),
  ADD KEY `drive_sync_material` (`material_id`),
  ADD KEY `drive_sync_replacement` (`root_id`,`replaces_id`,`upload_file_id`),
  ADD KEY `local_file_id` (`local_file_id`),
  ADD KEY `base_file_id` (`base_file_id`);
ALTER TABLE `drive_sync_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `drive_sync_event_run` (`run_id`,`id`),
  ADD KEY `entry_id` (`entry_id`);
ALTER TABLE `drive_sync_roots`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `drive_sync_remote` (`account_key`,`folder_id`),
  ADD KEY `drive_sync_owner` (`user_id`,`active`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `term_id` (`term_id`);
ALTER TABLE `drive_sync_runs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `drive_sync_run_history` (`root_id`,`created_at`);
ALTER TABLE `drive_sync_versions`
  ADD PRIMARY KEY (`root_id`,`file_id`),
  ADD KEY `file_id` (`file_id`);
ALTER TABLE `favorite_subjects`
  ADD PRIMARY KEY (`user_id`,`subject_id`),
  ADD KEY `subject_id` (`subject_id`);
ALTER TABLE `google_backup_jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);
ALTER TABLE `google_connections`
  ADD PRIMARY KEY (`user_id`);
ALTER TABLE `google_drive_copies`
  ADD PRIMARY KEY (`material_file_id`,`recipient_user_id`),
  ADD KEY `drive_copies_recipient` (`recipient_user_id`,`account_key`,`status`);
ALTER TABLE `google_drive_folders`
  ADD PRIMARY KEY (`user_id`,`account_key`,`folder_key`);
ALTER TABLE `group_announcements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `term_id` (`term_id`),
  ADD KEY `author_user_id` (`author_user_id`),
  ADD KEY `group_id` (`group_id`,`term_id`,`created_at`),
  ADD KEY `fk_announcement_subject` (`subject_id`);
ALTER TABLE `group_memberships`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `group_id` (`group_id`,`user_id`,`term_id`,`valid_from`),
  ADD KEY `term_id` (`term_id`),
  ADD KEY `user_id` (`user_id`,`valid_to`),
  ADD KEY `group_id_2` (`group_id`,`term_id`,`valid_to`);
ALTER TABLE `group_rating_profiles`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `group_rating_board` (`group_id`,`term_id`,`average_score`),
  ADD KEY `group_rating_term` (`term_id`);
ALTER TABLE `headman_attendance_drafts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `term_id` (`term_id`),
  ADD KEY `class_draft_id` (`class_draft_id`),
  ADD KEY `creator_user_id` (`creator_user_id`);
ALTER TABLE `headman_class_drafts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `group_id` (`group_id`,`term_id`,`source_meeting_id`),
  ADD UNIQUE KEY `headman_ruz` (`group_id`,`term_id`,`ruz_lesson_id`),
  ADD KEY `term_id` (`term_id`),
  ADD KEY `creator_user_id` (`creator_user_id`),
  ADD KEY `source_meeting_id` (`source_meeting_id`);
ALTER TABLE `homework`
  ADD PRIMARY KEY (`id`),
  ADD KEY `term_id` (`term_id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `linked_meeting_id` (`linked_meeting_id`),
  ADD KEY `group_id` (`group_id`,`term_id`,`due_at`,`id`),
  ADD KEY `author_user_id` (`author_user_id`,`updated_at`),
  ADD KEY `homework_ruz` (`author_user_id`,`ruz_lesson_date`,`ruz_lesson_id`);
ALTER TABLE `homework_attachments`
  ADD PRIMARY KEY (`homework_id`,`material_id`),
  ADD KEY `material_id` (`material_id`);
ALTER TABLE `homework_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `homework_id` (`homework_id`,`created_at`);
ALTER TABLE `homework_completions`
  ADD PRIMARY KEY (`homework_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);
ALTER TABLE `homework_examples`
  ADD PRIMARY KEY (`id`),
  ADD KEY `homework_id` (`homework_id`),
  ADD KEY `uploader_user_id` (`uploader_user_id`),
  ADD KEY `material_id` (`material_id`);
ALTER TABLE `homework_versions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `homework_id` (`homework_id`),
  ADD KEY `editor_user_id` (`editor_user_id`);
ALTER TABLE `idempotency_keys`
  ADD PRIMARY KEY (`user_id`,`key_hash`);
ALTER TABLE `lesson_teachers`
  ADD PRIMARY KEY (`meeting_id`,`teacher_id`),
  ADD KEY `teacher_id` (`teacher_id`);
ALTER TABLE `login_links`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token_hash` (`token_hash`);
ALTER TABLE `materials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `term_id` (`term_id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `group_id` (`group_id`,`term_id`,`updated_at`),
  ADD KEY `owner_user_id` (`owner_user_id`,`updated_at`);
ALTER TABLE `material_files`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `storage_key` (`storage_key`),
  ADD UNIQUE KEY `material_id` (`material_id`,`version`);
ALTER TABLE `material_lessons`
  ADD PRIMARY KEY (`material_id`,`meeting_id`),
  ADD KEY `meeting_id` (`meeting_id`);
ALTER TABLE `mpei_mail_connections`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `mpei_mail_due` (`poll_enabled`,`next_check_at`),
  ADD KEY `mpei_mail_expiry` (`expires_at`);
ALTER TABLE `note_materials`
  ADD PRIMARY KEY (`note_id`,`material_id`),
  ADD KEY `material_id` (`material_id`);
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `recipient_user_id` (`recipient_user_id`,`dedupe_key`),
  ADD KEY `recipient_user_id_2` (`recipient_user_id`,`created_at`,`id`);
ALTER TABLE `oauth_states`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `hashed_nonce` (`hashed_nonce`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_oauth_browser_session` (`session_id`);
ALTER TABLE `official_attendance_snapshots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meeting_id` (`meeting_id`),
  ADD KEY `user_id` (`user_id`,`observed_at`);
ALTER TABLE `official_grade_snapshots`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`assessment_id`,`source_hash`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `assessment_id` (`assessment_id`),
  ADD KEY `user_id_2` (`user_id`,`subject_id`,`snapshot_time`);
ALTER TABLE `personal_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `meeting_id` (`meeting_id`),
  ADD KEY `owner_user_id` (`owner_user_id`,`updated_at`);
ALTER TABLE `provider_connections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`provider`);
ALTER TABLE `provider_credentials`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `connection_id` (`connection_id`);
ALTER TABLE `push_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `endpoint_hash` (`endpoint_hash`),
  ADD KEY `user_id` (`user_id`);
ALTER TABLE `ranking_snapshots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `term_id` (`term_id`),
  ADD KEY `user_id` (`user_id`,`term_id`,`observed_at`);
ALTER TABLE `rate_limits`
  ADD PRIMARY KEY (`bucket`,`window_start`);
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `building_id` (`building_id`,`official_room_code`);
ALTER TABLE `student_subgroups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `group_id` (`group_id`,`term_id`,`name`),
  ADD KEY `term_id` (`term_id`);
ALTER TABLE `subgroup_memberships`
  ADD PRIMARY KEY (`subgroup_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `group_id` (`group_id`,`term_id`,`provider`,`external_id`),
  ADD KEY `term_id` (`term_id`);
ALTER TABLE `subject_title_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subject_id` (`subject_id`);
ALTER TABLE `sync_runs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`,`started_at`);
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `university_id` (`university_id`,`provider`,`external_id`);
ALTER TABLE `terms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `university_id` (`university_id`,`academic_year`,`season`);
ALTER TABLE `universities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `provider` (`provider`,`external_subject`);
ALTER TABLE `user_preferences`
  ADD PRIMARY KEY (`user_id`);
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`user_id`);
ALTER TABLE `user_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `session_token_hash` (`session_token_hash`),
  ADD KEY `user_id` (`user_id`,`revoked_at`,`expires_at`);
ALTER TABLE `drive_sync_events`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;
ALTER TABLE `academic_groups`
  ADD CONSTRAINT `academic_groups_ibfk_1` FOREIGN KEY (`university_id`) REFERENCES `universities` (`id`);
ALTER TABLE `announcement_materials`
  ADD CONSTRAINT `announcement_materials_ibfk_1` FOREIGN KEY (`announcement_id`) REFERENCES `group_announcements` (`id`),
  ADD CONSTRAINT `announcement_materials_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`);
ALTER TABLE `api_tokens`
  ADD CONSTRAINT `api_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `assessments`
  ADD CONSTRAINT `assessments_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`);
ALTER TABLE `bars_academic_watch`
  ADD CONSTRAINT `fk_bars_academic_watch_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `bars_rating_points`
  ADD CONSTRAINT `bars_rating_points_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `buildings`
  ADD CONSTRAINT `buildings_ibfk_1` FOREIGN KEY (`university_id`) REFERENCES `universities` (`id`);
ALTER TABLE `calendar_exports`
  ADD CONSTRAINT `calendar_exports_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `calendar_subscriptions`
  ADD CONSTRAINT `calendar_subscriptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `calendar_subscriptions_ibfk_2` FOREIGN KEY (`membership_id`) REFERENCES `group_memberships` (`id`);
ALTER TABLE `class_meetings`
  ADD CONSTRAINT `class_meetings_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`),
  ADD CONSTRAINT `class_meetings_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`),
  ADD CONSTRAINT `class_meetings_ibfk_3` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  ADD CONSTRAINT `class_meetings_ibfk_4` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
  ADD CONSTRAINT `class_meetings_ibfk_5` FOREIGN KEY (`subgroup_id`) REFERENCES `student_subgroups` (`id`);
ALTER TABLE `consent_events`
  ADD CONSTRAINT `consent_events_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `content_reports`
  ADD CONSTRAINT `content_reports_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
ALTER TABLE `dashboard_widgets`
  ADD CONSTRAINT `dashboard_widgets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `drive_sync_entries`
  ADD CONSTRAINT `drive_sync_entries_ibfk_1` FOREIGN KEY (`root_id`) REFERENCES `drive_sync_roots` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `drive_sync_entries_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `drive_sync_entries_ibfk_3` FOREIGN KEY (`local_file_id`) REFERENCES `material_files` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `drive_sync_entries_ibfk_4` FOREIGN KEY (`base_file_id`) REFERENCES `material_files` (`id`) ON DELETE SET NULL;
ALTER TABLE `drive_sync_events`
  ADD CONSTRAINT `drive_sync_events_ibfk_1` FOREIGN KEY (`run_id`) REFERENCES `drive_sync_runs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `drive_sync_events_ibfk_2` FOREIGN KEY (`entry_id`) REFERENCES `drive_sync_entries` (`id`) ON DELETE SET NULL;
ALTER TABLE `drive_sync_roots`
  ADD CONSTRAINT `drive_sync_roots_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `drive_sync_roots_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`),
  ADD CONSTRAINT `drive_sync_roots_ibfk_3` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`);
ALTER TABLE `drive_sync_runs`
  ADD CONSTRAINT `drive_sync_runs_ibfk_1` FOREIGN KEY (`root_id`) REFERENCES `drive_sync_roots` (`id`) ON DELETE CASCADE;
ALTER TABLE `drive_sync_versions`
  ADD CONSTRAINT `drive_sync_versions_ibfk_1` FOREIGN KEY (`root_id`) REFERENCES `drive_sync_roots` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `drive_sync_versions_ibfk_2` FOREIGN KEY (`file_id`) REFERENCES `material_files` (`id`) ON DELETE CASCADE;
ALTER TABLE `favorite_subjects`
  ADD CONSTRAINT `favorite_subjects_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favorite_subjects_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`);
ALTER TABLE `google_backup_jobs`
  ADD CONSTRAINT `google_backup_jobs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `google_connections`
  ADD CONSTRAINT `google_connections_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `google_drive_copies`
  ADD CONSTRAINT `drive_copies_file_fk` FOREIGN KEY (`material_file_id`) REFERENCES `material_files` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `drive_copies_user_fk` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `google_drive_folders`
  ADD CONSTRAINT `drive_folders_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `group_announcements`
  ADD CONSTRAINT `fk_announcement_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  ADD CONSTRAINT `group_announcements_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`),
  ADD CONSTRAINT `group_announcements_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`),
  ADD CONSTRAINT `group_announcements_ibfk_3` FOREIGN KEY (`author_user_id`) REFERENCES `users` (`id`);
ALTER TABLE `group_memberships`
  ADD CONSTRAINT `group_memberships_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`),
  ADD CONSTRAINT `group_memberships_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `group_memberships_ibfk_3` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`);
ALTER TABLE `group_rating_profiles`
  ADD CONSTRAINT `group_rating_group` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `group_rating_semester` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `group_rating_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `headman_attendance_drafts`
  ADD CONSTRAINT `headman_attendance_drafts_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`),
  ADD CONSTRAINT `headman_attendance_drafts_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`),
  ADD CONSTRAINT `headman_attendance_drafts_ibfk_3` FOREIGN KEY (`class_draft_id`) REFERENCES `headman_class_drafts` (`id`),
  ADD CONSTRAINT `headman_attendance_drafts_ibfk_4` FOREIGN KEY (`creator_user_id`) REFERENCES `users` (`id`);
ALTER TABLE `headman_class_drafts`
  ADD CONSTRAINT `headman_class_drafts_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`),
  ADD CONSTRAINT `headman_class_drafts_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`),
  ADD CONSTRAINT `headman_class_drafts_ibfk_3` FOREIGN KEY (`creator_user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `headman_class_drafts_ibfk_4` FOREIGN KEY (`source_meeting_id`) REFERENCES `class_meetings` (`id`);
ALTER TABLE `homework`
  ADD CONSTRAINT `homework_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`),
  ADD CONSTRAINT `homework_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`),
  ADD CONSTRAINT `homework_ibfk_3` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  ADD CONSTRAINT `homework_ibfk_4` FOREIGN KEY (`linked_meeting_id`) REFERENCES `class_meetings` (`id`),
  ADD CONSTRAINT `homework_ibfk_5` FOREIGN KEY (`author_user_id`) REFERENCES `users` (`id`);
ALTER TABLE `homework_attachments`
  ADD CONSTRAINT `homework_attachments_ibfk_1` FOREIGN KEY (`homework_id`) REFERENCES `homework` (`id`),
  ADD CONSTRAINT `homework_attachments_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`);
ALTER TABLE `homework_comments`
  ADD CONSTRAINT `homework_comments_ibfk_1` FOREIGN KEY (`homework_id`) REFERENCES `homework` (`id`),
  ADD CONSTRAINT `homework_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
ALTER TABLE `homework_completions`
  ADD CONSTRAINT `homework_completions_ibfk_1` FOREIGN KEY (`homework_id`) REFERENCES `homework` (`id`),
  ADD CONSTRAINT `homework_completions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `homework_examples`
  ADD CONSTRAINT `homework_examples_ibfk_1` FOREIGN KEY (`homework_id`) REFERENCES `homework` (`id`),
  ADD CONSTRAINT `homework_examples_ibfk_2` FOREIGN KEY (`uploader_user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `homework_examples_ibfk_3` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`);
ALTER TABLE `homework_versions`
  ADD CONSTRAINT `homework_versions_ibfk_1` FOREIGN KEY (`homework_id`) REFERENCES `homework` (`id`),
  ADD CONSTRAINT `homework_versions_ibfk_2` FOREIGN KEY (`editor_user_id`) REFERENCES `users` (`id`);
ALTER TABLE `idempotency_keys`
  ADD CONSTRAINT `idempotency_keys_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `lesson_teachers`
  ADD CONSTRAINT `lesson_teachers_ibfk_1` FOREIGN KEY (`meeting_id`) REFERENCES `class_meetings` (`id`),
  ADD CONSTRAINT `lesson_teachers_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`);
ALTER TABLE `materials`
  ADD CONSTRAINT `materials_ibfk_1` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `materials_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`),
  ADD CONSTRAINT `materials_ibfk_3` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`),
  ADD CONSTRAINT `materials_ibfk_4` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`);
ALTER TABLE `material_files`
  ADD CONSTRAINT `material_files_ibfk_1` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`);
ALTER TABLE `material_lessons`
  ADD CONSTRAINT `material_lessons_ibfk_1` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`),
  ADD CONSTRAINT `material_lessons_ibfk_2` FOREIGN KEY (`meeting_id`) REFERENCES `class_meetings` (`id`);
ALTER TABLE `mpei_mail_connections`
  ADD CONSTRAINT `mpei_mail_session` FOREIGN KEY (`session_id`) REFERENCES `user_sessions` (`id`) ON DELETE CASCADE;
ALTER TABLE `note_materials`
  ADD CONSTRAINT `note_materials_ibfk_1` FOREIGN KEY (`note_id`) REFERENCES `personal_notes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `note_materials_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`);
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `oauth_states`
  ADD CONSTRAINT `fk_oauth_browser_session` FOREIGN KEY (`session_id`) REFERENCES `user_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `oauth_states_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `official_attendance_snapshots`
  ADD CONSTRAINT `official_attendance_snapshots_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `official_attendance_snapshots_ibfk_2` FOREIGN KEY (`meeting_id`) REFERENCES `class_meetings` (`id`);
ALTER TABLE `official_grade_snapshots`
  ADD CONSTRAINT `official_grade_snapshots_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `official_grade_snapshots_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  ADD CONSTRAINT `official_grade_snapshots_ibfk_3` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`);
ALTER TABLE `personal_notes`
  ADD CONSTRAINT `personal_notes_ibfk_1` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `personal_notes_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  ADD CONSTRAINT `personal_notes_ibfk_3` FOREIGN KEY (`meeting_id`) REFERENCES `class_meetings` (`id`);
ALTER TABLE `provider_connections`
  ADD CONSTRAINT `provider_connections_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `provider_credentials`
  ADD CONSTRAINT `provider_credentials_ibfk_1` FOREIGN KEY (`connection_id`) REFERENCES `provider_connections` (`id`) ON DELETE CASCADE;
ALTER TABLE `push_subscriptions`
  ADD CONSTRAINT `push_subscriptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `ranking_snapshots`
  ADD CONSTRAINT `ranking_snapshots_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ranking_snapshots_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`);
ALTER TABLE `rooms`
  ADD CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`);
ALTER TABLE `student_subgroups`
  ADD CONSTRAINT `student_subgroups_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`),
  ADD CONSTRAINT `student_subgroups_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`);
ALTER TABLE `subgroup_memberships`
  ADD CONSTRAINT `subgroup_memberships_ibfk_1` FOREIGN KEY (`subgroup_id`) REFERENCES `student_subgroups` (`id`),
  ADD CONSTRAINT `subgroup_memberships_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `subjects`
  ADD CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `academic_groups` (`id`),
  ADD CONSTRAINT `subjects_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `terms` (`id`);
ALTER TABLE `subject_title_history`
  ADD CONSTRAINT `subject_title_history_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`);
ALTER TABLE `sync_runs`
  ADD CONSTRAINT `sync_runs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `teachers`
  ADD CONSTRAINT `teachers_ibfk_1` FOREIGN KEY (`university_id`) REFERENCES `universities` (`id`);
ALTER TABLE `terms`
  ADD CONSTRAINT `terms_ibfk_1` FOREIGN KEY (`university_id`) REFERENCES `universities` (`id`);
ALTER TABLE `user_preferences`
  ADD CONSTRAINT `user_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_sessions`
  ADD CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
CREATE TABLE `mpei_mail_folders` (
  `user_id` char(36) NOT NULL,
  `mailbox_key` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `folder` varchar(8) NOT NULL,
  `uid_validity` int unsigned NOT NULL DEFAULT 0,
  `next_uid` bigint unsigned NOT NULL DEFAULT 0,
  `scan_before` bigint unsigned NOT NULL DEFAULT 0,
  `unread_total` int unsigned DEFAULT NULL,
  `can_move` tinyint(1) NOT NULL DEFAULT 0,
  `checked_at` datetime(6) DEFAULT NULL,
  `scanned_at` datetime(6) DEFAULT NULL,
  `next_sync_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`mailbox_key`,`folder`),
  KEY `mpei_folder_due` (`next_sync_at`),
  CONSTRAINT `mpei_folder_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `mpei_mail_messages` (
  `user_id` char(36) NOT NULL,
  `mailbox_key` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `folder` varchar(8) NOT NULL,
  `uid_validity` int unsigned NOT NULL,
  `uid` int unsigned NOT NULL,
  `received_at` datetime(6) DEFAULT NULL,
  `unread` tinyint(1) NOT NULL DEFAULT 0,
  `flagged` tinyint(1) NOT NULL DEFAULT 0,
  `envelope` text NOT NULL,
  `body_ciphertext` mediumtext DEFAULT NULL,
  `body_checked_at` datetime(6) DEFAULT NULL,
  `move_copy` json DEFAULT NULL,
  PRIMARY KEY (`user_id`,`mailbox_key`,`folder`,`uid_validity`,`uid`),
  KEY `mpei_message_date` (`user_id`,`mailbox_key`,`folder`,`uid_validity`,`received_at`,`uid`),
  KEY `mpei_body_due` (`user_id`,`mailbox_key`,`folder`,`uid_validity`,`body_checked_at`,`uid`),
  CONSTRAINT `mpei_message_folder` FOREIGN KEY (`user_id`,`mailbox_key`,`folder`)
    REFERENCES `mpei_mail_folders` (`user_id`,`mailbox_key`,`folder`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `mpei_mail_drafts` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `mailbox_key` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `revision` int unsigned NOT NULL DEFAULT 1,
  `sending` tinyint(1) NOT NULL DEFAULT 0,
  `ciphertext` mediumtext NOT NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `mpei_draft_owner` (`user_id`,`mailbox_key`,`updated_at`),
  CONSTRAINT `mpei_draft_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `mpei_mail_draft_parts` (
  `draft_id` char(36) NOT NULL,
  `file_id` char(36) NOT NULL,
  `part` int unsigned NOT NULL,
  `ciphertext` mediumblob NOT NULL,
  PRIMARY KEY (`draft_id`,`file_id`,`part`),
  CONSTRAINT `mpei_part_draft` FOREIGN KEY (`draft_id`) REFERENCES `mpei_mail_drafts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `push_deliveries` (
  `subscription_id` char(36) NOT NULL,
  `notification_id` char(36) NOT NULL,
  `delivered_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`subscription_id`,`notification_id`),
  KEY `push_delivery_time` (`delivered_at`),
  CONSTRAINT `push_delivery_device` FOREIGN KEY (`subscription_id`) REFERENCES `push_subscriptions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `push_delivery_notice` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `drive_sync_folders` (
  `root_id` char(36) NOT NULL,
  `remote_id` varchar(160) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `parent_id` varchar(160) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `name` text NOT NULL,
  `restricted` tinyint(1) NOT NULL DEFAULT 0,
  `scan_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`root_id`,`remote_id`),
  KEY `drive_folder_children` (`root_id`,`parent_id`),
  FOREIGN KEY (`root_id`) REFERENCES `drive_sync_roots` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `drive_sync_repairs` (
  `root_id` char(36) NOT NULL,
  `file_id` char(36) NOT NULL,
  `next_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`root_id`,`file_id`),
  KEY `drive_repair_due` (`next_at`,`root_id`),
  FOREIGN KEY (`root_id`) REFERENCES `drive_sync_roots` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`file_id`) REFERENCES `material_files` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
ALTER TABLE `drive_sync_events` ADD COLUMN `error_code` varchar(60) DEFAULT NULL;
COMMIT;