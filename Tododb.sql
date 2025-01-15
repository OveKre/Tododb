-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: mariadb
-- Generation Time: Jan 15, 2025 at 08:45 AM
-- Server version: 11.6.2-MariaDB-ubu2404
-- PHP Version: 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Tododb`
--

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
                            `comment_id` int(10) UNSIGNED NOT NULL COMMENT 'Primary key. INT used for efficiency, UNSIGNED for only positive values.',
                            `task_id` int(10) UNSIGNED NOT NULL COMMENT 'Foreign key referencing tasks.task_id. INT UNSIGNED chosen to match parent column.',
                            `user_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Foreign key referencing users.user_id. Allows NULL for anonymous comments.',
                            `content` text NOT NULL COMMENT 'Holds the full text of the comment. TEXT chosen for variable-length content.',
                            `created_at` datetime DEFAULT current_timestamp() COMMENT 'Timestamp for when the comment was created. Uses DATETIME for precise date/time.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Stores comments for tasks';

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`comment_id`, `task_id`, `user_id`, `content`, `created_at`) VALUES
                                                                                         (1, 1, 2, 'Comment from Bob on Alice task', '2025-01-15 08:18:06'),
                                                                                         (2, 2, 3, 'Comment from Charlie on Bob task', '2025-01-15 08:18:06'),
                                                                                         (3, 3, 4, 'Comment from Diana on Charlie task', '2025-01-15 08:18:06'),
                                                                                         (4, 4, 5, 'Comment from Edward on Diana task', '2025-01-15 08:18:06'),
                                                                                         (5, 5, 1, 'Comment from Alice on Edward task', '2025-01-15 08:18:06');

-- --------------------------------------------------------

--
-- Table structure for table `labels`
--

CREATE TABLE `labels` (
                          `label_id` int(11) UNSIGNED NOT NULL COMMENT 'Primary key. INT is sufficient for the expected number of labels.',
                          `label_name` varchar(50) NOT NULL COMMENT 'Name/description of the label (e.g., "Urgent"). VARCHAR(50) provides ample space.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Stores labels/tags for tasks (if needed)';

--
-- Dumping data for table `labels`
--

INSERT INTO `labels` (`label_id`, `label_name`) VALUES
                                                    (1, 'Urgent'),
                                                    (2, 'Home'),
                                                    (3, 'Work'),
                                                    (4, 'Personal'),
                                                    (5, 'Important');

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
                        `log_id` int(10) UNSIGNED NOT NULL COMMENT 'Primary key. INT UNSIGNED chosen for a large number of log entries.',
                        `user_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Foreign key referencing users.user_id. INT UNSIGNED for consistency; allows NULL if not tied to a user.',
                        `action` varchar(50) NOT NULL COMMENT 'Short descriptor of the action (e.g., "USER_LOGIN"). VARCHAR(50) is sufficient.',
                        `message` text DEFAULT NULL COMMENT 'Detailed message of the action. TEXT is used to allow for longer descriptive text.',
                        `created_at` datetime DEFAULT current_timestamp() COMMENT 'Timestamp when the log entry was created.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Stores logs of user actions';

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`log_id`, `user_id`, `action`, `message`, `created_at`) VALUES
                                                                                (1, 1, 'USER_LOGIN', 'Alice logged in successfully.', '2025-01-15 08:18:06'),
                                                                                (2, 2, 'TASK_CREATED', 'Bob created a new task.', '2025-01-15 08:18:06'),
                                                                                (3, 3, 'USER_LOGOUT', 'Charlie logged out.', '2025-01-15 08:18:06'),
                                                                                (4, 4, 'TASK_UPDATED', 'Diana updated her task status to overtime.', '2025-01-15 08:18:06'),
                                                                                (5, 5, 'PASSWORD_CHANGE', 'Edward changed his password.', '2025-01-15 08:18:06');

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
                         `task_id` int(10) UNSIGNED NOT NULL COMMENT 'Primary key. INT UNSIGNED is efficient and scales to many tasks.',
                         `user_id` int(10) UNSIGNED NOT NULL COMMENT 'Foreign key linking to users.user_id. Ensures each task is associated with a user.',
                         `label_id` int(11) UNSIGNED DEFAULT NULL,
                         `title` varchar(255) NOT NULL COMMENT 'Short title or summary of the task. VARCHAR(255) is flexible for titles.',
                         `description` text DEFAULT NULL COMMENT 'Detailed description of the task. TEXT is used to store variable-length text.',
                         `status` enum('pending','completed','overtime','archived','canceled') NOT NULL DEFAULT 'pending' COMMENT 'Current state of the task. ENUM restricts values to predefined valid states.',
                         `priority` int(11) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Priority level for the task. INT UNSIGNED used to ensure non-negative values.',
                         `due_date` datetime DEFAULT NULL COMMENT 'Deadline for completing the task. DATETIME used for precise date/time.',
                         `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Timestamp when the task was created. Does not update after insertion.',
                         `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Timestamp for the last update. Automatically updates on row modification.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Stores tasks for each user';

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`task_id`, `user_id`, `label_id`, `title`, `description`, `status`, `priority`, `due_date`, `created_at`, `updated_at`) VALUES
                                                                                                                                                 (1, 1, NULL, 'Task for Alice', 'Alice task description sample text', 'pending', 1, '2025-01-17 08:18:06', '2025-01-15 08:18:06', '2025-01-15 08:18:06'),
                                                                                                                                                 (2, 2, 1, 'Task for Bob', 'Bob task description sample text', 'completed', 2, '2025-01-18 08:18:06', '2025-01-15 08:18:06', '2025-01-15 08:24:17'),
                                                                                                                                                 (3, 3, 2, 'Task for Charlie', 'Charlie task description sample text', 'pending', 3, '2025-01-19 08:18:06', '2025-01-15 08:18:06', '2025-01-15 08:24:21'),
                                                                                                                                                 (4, 4, 3, 'Task for Diana', 'Diana task description sample text', 'overtime', 2, '2025-01-16 08:18:06', '2025-01-15 08:18:06', '2025-01-15 08:24:24'),
                                                                                                                                                 (5, 5, 4, 'Task for Edward', 'Edward task description sample text', 'pending', 1, '2025-01-20 08:18:06', '2025-01-15 08:18:06', '2025-01-15 08:24:26');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
                         `user_id` int(10) UNSIGNED NOT NULL COMMENT 'Primary key. INT UNSIGNED chosen for efficiency and scalability.',
                         `username` varchar(50) NOT NULL COMMENT 'Unique username for the user. VARCHAR(50) is sufficient for typical usernames.',
                         `email` varchar(100) NOT NULL COMMENT 'User email address. VARCHAR(100) accommodates standard email sizes and ensures uniqueness.',
                         `password` varchar(255) NOT NULL COMMENT 'Hashed user password. VARCHAR(255) allows storage of various hash formats.',
                         `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Timestamp for when the account was created.',
                         `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Timestamp for the last update to the account; auto-updates on changes.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Stores user accounts';

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password`, `created_at`, `updated_at`) VALUES
                                                                                                 (1, 'alice', 'alice@example.com', 'hashed_password1', '2025-01-15 08:18:06', '2025-01-15 08:18:06'),
                                                                                                 (2, 'bob', 'bob@example.com', 'hashed_password2', '2025-01-15 08:18:06', '2025-01-15 08:18:06'),
                                                                                                 (3, 'charlie', 'charlie@example.com', 'hashed_password3', '2025-01-15 08:18:06', '2025-01-15 08:18:06'),
                                                                                                 (4, 'diana', 'diana@example.com', 'hashed_password4', '2025-01-15 08:18:06', '2025-01-15 08:18:06'),
                                                                                                 (5, 'edward', 'edward@example.com', 'hashed_password5', '2025-01-15 08:18:06', '2025-01-15 08:18:06');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
    ADD PRIMARY KEY (`comment_id`),
  ADD KEY `task_id` (`task_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `labels`
--
ALTER TABLE `labels`
    ADD PRIMARY KEY (`label_id`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
    ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
    ADD PRIMARY KEY (`task_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `priority` (`priority`),
  ADD KEY `label_id` (`label_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
    ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
    MODIFY `comment_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key. INT used for efficiency, UNSIGNED for only positive values.', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `labels`
--
ALTER TABLE `labels`
    MODIFY `label_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key. INT is sufficient for the expected number of labels.', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
    MODIFY `log_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key. INT UNSIGNED chosen for a large number of log entries.', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
    MODIFY `task_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key. INT UNSIGNED is efficient and scales to many tasks.', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
    MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary key. INT UNSIGNED chosen for efficiency and scalability.', AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
    ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
    ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
    ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `tasks_ibfk_2` FOREIGN KEY (`label_id`) REFERENCES `labels` (`label_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
