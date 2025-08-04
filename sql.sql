CREATE TABLE `lucas_refund` (
  `admin` varchar(60) NOT NULL, -- Degene die de refund uitschrijft
  `steam_id` varchar(60) DEFAULT NULL, -- Degene die hem moet ontvangen
  `refund_code` varchar(60) DEFAULT NULL, -- De code van de refund
  `itemName` varchar(100) NOT NULL, -- Wapens / Geld / Bank
  `amount` int(11) NOT NULL, -- De hoeveelheid van de type
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;