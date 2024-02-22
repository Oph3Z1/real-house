CREATE TABLE IF NOT EXISTS `real_house` (
  `id` int(11) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `houseinfo` longtext DEFAULT NULL,
  `keydata` varchar(50) DEFAULT NULL,
  `rentowner` longtext DEFAULT NULL,
  `allowrent` varchar(50) DEFAULT NULL,
  `friends` longtext DEFAULT NULL,
  `payment` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;