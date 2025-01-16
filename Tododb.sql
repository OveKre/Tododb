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
                            `comment_id` int(10) UNSIGNED NOT NULL,
                            `task_id` int(10) UNSIGNED NOT NULL,
                            `user_id` int(10) UNSIGNED DEFAULT NULL,
                            `content` text NOT NULL,
                            `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `labels`
--

CREATE TABLE `labels` (
                          `label_id` int(11) UNSIGNED NOT NULL,
                          `label_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
                        `log_id` int(10) UNSIGNED NOT NULL,
                        `user_id` int(10) UNSIGNED DEFAULT NULL,
                        `action` varchar(50) NOT NULL,
                        `message` text DEFAULT NULL,
                        `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
                         `task_id` int(10) UNSIGNED NOT NULL,
                         `user_id` int(10) UNSIGNED NOT NULL,
                         `title` varchar(255) NOT NULL,
                         `description` text DEFAULT NULL,
                         `status` enum('pending', 'completed', 'overtime', 'archived', 'canceled') NOT NULL DEFAULT 'pending',
                         `priority` int(11) UNSIGNED NOT NULL DEFAULT 1,
                         `due_date` datetime DEFAULT NULL,
                         `created_at` datetime NOT NULL DEFAULT current_timestamp(),
                         `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `task_labels`
--

CREATE TABLE `task_labels` (
                               `task_id` int(10) UNSIGNED NOT NULL,
                               `label_id` int(11) UNSIGNED NOT NULL,
                               PRIMARY KEY (`task_id`, `label_id`),
                               FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`) ON DELETE CASCADE,
                               FOREIGN KEY (`label_id`) REFERENCES `labels` (`label_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
                         `user_id` int(10) UNSIGNED NOT NULL,
                         `username` varchar(50) NOT NULL,
                         `email` varchar(100) NOT NULL,
                         `password` varchar(255) NOT NULL,
                         `created_at` datetime NOT NULL DEFAULT current_timestamp(),
                         `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Primary keys, indexes, and auto increments
--

ALTER TABLE `comments`
    ADD PRIMARY KEY (`comment_id`),
  ADD KEY `task_id` (`task_id`),
  ADD KEY `user_id` (`user_id`);

ALTER TABLE `labels`
    ADD PRIMARY KEY (`label_id`);

ALTER TABLE `logs`
    ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

ALTER TABLE `tasks`
    ADD PRIMARY KEY (`task_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `priority` (`priority`);

ALTER TABLE `users`
    ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

ALTER TABLE `comments`
    MODIFY `comment_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `labels`
    MODIFY `label_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `logs`
    MODIFY `log_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `tasks`
    MODIFY `task_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `users`
    MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
