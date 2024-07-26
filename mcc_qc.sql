-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 26 Jul 2024 pada 15.20
-- Versi server: 10.4.19-MariaDB
-- Versi PHP: 8.0.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mcc_qc`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `comments`
--

CREATE TABLE `comments` (
  `commentId` int(11) NOT NULL,
  `motorbikeId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `commentText` text DEFAULT NULL,
  `commentDate` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `comments`
--

INSERT INTO `comments` (`commentId`, `motorbikeId`, `userId`, `commentText`, `commentDate`) VALUES
(1, 1, 1, 'Keren', '2024-07-26 09:37:06'),
(2, 1, 2, 'Motornya keren banget', '2024-07-26 09:34:18'),
(3, 1, 1, 'Iya keren banget', '2024-07-26 10:36:35'),
(4, 2, 2, 'Bagus', '2024-07-26 10:53:16'),
(5, 2, 1, 'Harley', '2024-07-26 10:56:34'),
(6, 2, 2, 'Davidsboy', '2024-07-26 10:57:36'),
(7, 3, 1, 'semoga saya kaya raya', '2024-07-26 13:09:57');

-- --------------------------------------------------------

--
-- Struktur dari tabel `msmotorbike`
--

CREATE TABLE `msmotorbike` (
  `motorbikeId` int(11) NOT NULL,
  `motorbikeName` varchar(255) NOT NULL,
  `motorbikePrice` decimal(10,2) NOT NULL,
  `motorbikeDescription` text DEFAULT NULL,
  `motorbikeImage` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `msmotorbike`
--

INSERT INTO `msmotorbike` (`motorbikeId`, `motorbikeName`, `motorbikePrice`, `motorbikeDescription`, `motorbikeImage`) VALUES
(1, 'Ultra Limited', '123456.00', 'Harley-Davidson Ultra Limited menghadirkan performa touring premium tanpa kompromi dalam perjalanan.', 'images\\1721970262260ultra_limited.png'),
(2, 'Hydra-Glide Revival', '111111.00', 'Untuk merayakan hari jadi ke-75 Hydra-Glide, kampiun era Panhead dibangkitkan dengan merilis Hydra-Glide Revival 2024 edisi terbatas.', 'images\\1721972525402hydra-glide_revival.png'),
(3, 'Nightster', '444444.00', 'Dirancang untuk menginspirasi para pengendara di semua tingkat keahlian, Harley-Davidson Nightster memperkenalkan narasi baru dalam cerita Sportster™.', 'images\\1721985732904nightster.png');

-- --------------------------------------------------------

--
-- Struktur dari tabel `msuser`
--

CREATE TABLE `msuser` (
  `userId` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `oauth_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `msuser`
--

INSERT INTO `msuser` (`userId`, `username`, `email`, `password`, `oauth_id`) VALUES
(1, 'david', 'david@gmail.com', '$2a$10$5DTjQjNIbUR2nucSARJNueadrG3BU1Hk9oepmlGfZ5JszTt5Qbwme', NULL),
(2, 'christian', 'christian@gmail.com', '$2a$10$5DTjQjNIbUR2nucSARJNueadrG3BU1Hk9oepmlGfZ5JszTt5Qbwme', NULL);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`commentId`),
  ADD KEY `motorbikeId` (`motorbikeId`),
  ADD KEY `userId` (`userId`);

--
-- Indeks untuk tabel `msmotorbike`
--
ALTER TABLE `msmotorbike`
  ADD PRIMARY KEY (`motorbikeId`);

--
-- Indeks untuk tabel `msuser`
--
ALTER TABLE `msuser`
  ADD PRIMARY KEY (`userId`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `comments`
--
ALTER TABLE `comments`
  MODIFY `commentId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `msmotorbike`
--
ALTER TABLE `msmotorbike`
  MODIFY `motorbikeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`motorbikeId`) REFERENCES `msmotorbike` (`motorbikeId`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `msuser` (`userId`) ON DELETE CASCADE;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
