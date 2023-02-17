CREATE TABLE `hn_multijob` (
	`id` VARCHAR(11) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`jobs` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`active` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB