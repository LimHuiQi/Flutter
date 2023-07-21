-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 21, 2023 at 02:16 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterit_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_items`
--

CREATE TABLE `tbl_items` (
  `item_id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL,
  `user_phone` varchar(11) NOT NULL,
  `item_brand` varchar(50) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `item_desc` varchar(255) NOT NULL,
  `item_type` varchar(50) NOT NULL,
  `item_price` decimal(20,2) NOT NULL,
  `item_interest` varchar(255) NOT NULL,
  `item_lat` varchar(50) NOT NULL,
  `item_long` varchar(50) NOT NULL,
  `item_state` varchar(50) NOT NULL,
  `item_locality` varchar(50) NOT NULL,
  `item_date` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_items`
--

INSERT INTO `tbl_items` (`item_id`, `user_id`, `user_phone`, `item_brand`, `item_name`, `item_desc`, `item_type`, `item_price`, `item_interest`, `item_lat`, `item_long`, `item_state`, `item_locality`, `item_date`) VALUES
(3, 1, '0166749235', 'Malaysia', '1sen coin', 'Year1973 malaysian old coin', 'Collectibles', 0.00, 'Interesting Collectibles', '6.439255', '100.5281517', 'Kedah', 'Changlun', '2023-07-20 07:02:32'),
(4, 1, '0166749235', 'Quarz', 'Fashion Watch', 'Yellow, good battery life', 'Fashion and clothing', 39.00, '-', '6.439255', '100.5281517', 'Kedah', 'Changlun', '2023-07-20 07:02:40'),
(5, 1, '0166749235', 'Panasonic', 'Sewing Machine', 'Small, Different sewing pattern', 'Electronics', 199.00, 'Panasonic kettle', '6.439255', '100.5281517', 'Kedah', 'Changlun', '2023-07-20 07:02:47'),
(8, 2, '01161614226', 'Mario', 'Soft Toy', 'Medium size, original', 'Toys and Games', 0.00, 'Disney soft toy', '6.439255', '100.5281517', 'Kedah', 'Changlun', '2023-07-20 07:03:10'),
(12, 1, '0166749235', 'Disney', 'buzz lightyear', 'New condition', 'Toys and Games', 99.00, '-', '6.439255', '100.5281517', 'Kedah', 'Changlun', '2023-07-21 07:26:14'),
(24, 1, '0166749235', 'Nike', 'AirForce', 'DarkBlue', 'Fashion and clothing', 1099.00, '-', '6.439255', '100.5281517', 'Kedah', 'Changlun', '2023-07-21 07:25:57'),
(25, 1, '0166749235', 'Samsung', 'Buds2 Pro', 'New, Black', 'Electronics', 559.00, 'Iphone pencil', '6.439255', '100.5281517', 'Kedah', 'Changlun', '2023-07-21 07:25:17');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orders`
--

CREATE TABLE `tbl_orders` (
  `order_id` int(10) NOT NULL,
  `item_id` int(10) NOT NULL,
  `item_brand` varchar(50) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `item_price` decimal(20,2) NOT NULL,
  `item_interest` varchar(255) NOT NULL,
  `user_id` int(10) NOT NULL,
  `user_phone` varchar(11) NOT NULL,
  `seller_id` int(10) NOT NULL,
  `order_date` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_orders`
--

INSERT INTO `tbl_orders` (`order_id`, `item_id`, `item_brand`, `item_name`, `item_price`, `item_interest`, `user_id`, `user_phone`, `seller_id`, `order_date`) VALUES
(1, 11, 'Nike', 'Air Force1', 699.00, 'Adidas Neo', 1, '0166749235', 2, '2023-07-21 05:53:05'),
(2, 9, 'Molten', 'GG7x Basketball', 200.00, 'Volleyball', 1, '0166749235', 2, '2023-07-21 06:39:03'),
(3, 1, 'OEM', 'Mini Fan', 9.90, 'USB Multi cable', 2, '01161614226', 1, '2023-07-21 07:15:45');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(10) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_phone` varchar(11) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_password` varchar(50) NOT NULL,
  `user_datereg` datetime NOT NULL DEFAULT current_timestamp(),
  `user_balance` decimal(10,2) NOT NULL,
  `user_dateupdate` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_name`, `user_phone`, `user_email`, `user_password`, `user_datereg`, `user_balance`, `user_dateupdate`) VALUES
(1, 'LIM HUI QI', '0123456789', 'limhuiqi01@gmail.com', 'f04a07abc612388d70e270d19f9f5db7a27290fc', '2023-07-20 03:37:58', 8929.00, '2023-07-21 07:47:50'),
(2, 'Jocelyn', '01161614226', 'jocelyn@gmail.com', 'f04a07abc612388d70e270d19f9f5db7a27290fc', '2023-07-06 19:02:37', 822.00, '2023-07-21 07:14:43'),
(3, 'Jackson Yee', '0123456789', 'jackson@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '2023-07-06 19:14:51', 0.00, '2023-07-20 17:58:31'),
(4, 'Lim Hui Shan', '0126185448', 'huishan@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '2023-07-06 21:53:54', 0.00, '2023-07-20 17:58:31'),
(5, 'Chloe', '0126882616', 'chloe@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '2023-07-20 03:40:37', 0.00, '2023-07-20 17:58:31');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_items`
--
ALTER TABLE `tbl_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_items`
--
ALTER TABLE `tbl_items`
  MODIFY `item_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  MODIFY `order_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
