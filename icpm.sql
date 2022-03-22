-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 22, 2022 at 11:23 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `icpm`
--

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `s_no` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `address` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `TR_NAME` BEFORE INSERT ON `customer` FOR EACH ROW SET NEW.name = UPPER(NEW.name)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `employee_id` varchar(15) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `job_type` varchar(100) NOT NULL,
  `salary` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`employee_id`, `name`, `phone`, `job_type`, `salary`) VALUES
('E001', 'Ramesh', '8070605077', 'Cashier', 10000),
('E002', 'Suresh', '8172635410', 'Ice cream Creator', 10000),
('E003', 'Mahesh', '9144556677', 'Waiter', 7500),
('E004', 'Jaggesh', '7200998877', 'Supply Manager', 8500),
('E005', 'Mithilesh', '9440000776', 'Manager', 15000),
('E006', 'Siddesh', '7500550055', 'Cleaner', 5000);

-- --------------------------------------------------------

--
-- Table structure for table `ice_cream`
--

CREATE TABLE `ice_cream` (
  `item_id` int(11) NOT NULL,
  `name` varchar(25) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `price` float NOT NULL,
  `waiter_id` varchar(15) NOT NULL,
  `creator_id` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ice_cream`
--

INSERT INTO `ice_cream` (`item_id`, `name`, `description`, `price`, `waiter_id`, `creator_id`) VALUES
(1, 'Gadbad', 'A mish mash of Vanilla, Strawberry & Pineapple Ice creams, Fruits and Dry Fruits topped with Pineapple pulp.', 150, 'E003', 'E004'),
(2, 'Classic Banana Split', 'Banana drizzled with Caramel Sauce with Vanilla, Strawberry & Chocolate Ice creams topped with Pineapple crush, Chocolate Sauce & strawberry sauce, whipped cream cherries & roasted cashewnuts.', 170, 'E003', 'E004'),
(3, 'Dry Fruit Special', 'Fully loaded dry fruits like raisin, almonds, dates, and cashew with creamy vanilla ice cream fortified with cherry.', 175, 'E003', 'E004'),
(4, 'Butter Scotch Blast', 'Butterscotch ice cream, caramel and chocolate toppings and cashewnuts.', 150, 'E003', 'E004'),
(5, 'Choco Brownie Fudge', 'This piece of indulgence has a good twist of chocolate walnut brownie topped with chocolate ice cream with smooth chocolate fudge, Whipped cream, nuts and cherry.', 160, 'E003', 'E004'),
(6, 'Chocozilla', 'Brace yourself for what only seems like Charlie\'s best from the factory. Chocolate ice cream, chocolate bar, gooey chocolate cake, chocolate sauce, Laced with whipped cream, with oreo chunk sprinkles and a rich garnish of chocolate waffle, Gems, Chocos and some more chocolate bar.', 175, 'E003', 'E004'),
(7, 'Hot Chocolate Fudge', 'Vanilla ice cream dressed in some inviting hot chocolate fudge and sprinkled generously with cashew nuts.', 130, 'E003', 'E004'),
(8, 'Death By Chocolate', 'The Classic - A dangerous combination of vanilla ice cream and gallons of hot chocolate fudge, Armed with the yumminess of dark chocolate cake & roasted cashewnuts.', 200, 'E003', 'E004'),
(9, 'Fruit Salad', 'Fruit salad is a dish consisting of various kinds of fruit, sometimes served in a liquid, either their own juices or a syrup. In different forms, fruit salad can be served as an appetizer, a side salad, or a dessert.', 120, 'E003', 'E004');

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `id` int(11) NOT NULL,
  `empid` varchar(50) NOT NULL,
  `password` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`id`, `empid`, `password`) VALUES
(1, 'admin', 'admin@123');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `s_no` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` float NOT NULL,
  `time` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `new` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN 
 IF NEW.quantity<=0 THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT ="ERROR:QUANTITY MUST BE POSITIVE NUMBER!";
 END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `payment_id` int(11) NOT NULL,
  `price` float NOT NULL,
  `payment_mode` varchar(100) NOT NULL,
  `s_no` int(11) NOT NULL,
  `emp_id` varchar(11) NOT NULL,
  `time` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `payment`
--
DELIMITER $$
CREATE TRIGGER `payment updated` AFTER UPDATE ON `payment` FOR EACH ROW INSERT INTO trgr VALUES(null,NEW.payment_id,NEW.payment_mode,NEW.price,NEW.s_no,'PAYMENT UPDATED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `payment_deleted` BEFORE DELETE ON `payment` FOR EACH ROW INSERT INTO trgr VALUES(null,OLD.payment_id,OLD.payment_mode,OLD.price,OLD.s_no,'PAYMENT DELETED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `payment_made` AFTER INSERT ON `payment` FOR EACH ROW INSERT INTO trgr VALUES(null,NEW.payment_id,NEW.payment_mode,NEW.price,NEW.s_no,'PAYMENT MADE',NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `p_id` int(11) NOT NULL,
  `p_name` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` float NOT NULL,
  `emp_id` varchar(11) NOT NULL,
  `sup_id` int(11) NOT NULL,
  `time` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `sup_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`sup_id`, `name`, `address`, `phone`) VALUES
(1, 'Ideal Ice-Creams', 'Mangalore', '7200998877'),
(2, 'Amul ', 'Pune', '8070605070'),
(3, 'Nature-Fresh Dry Fruits', 'Mangaluru', '9440000777'),
(4, 'Shakti Fruits', 'Mangaluru', '9144556677');

-- --------------------------------------------------------

--
-- Table structure for table `trgr`
--

CREATE TABLE `trgr` (
  `ID` int(11) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `payment_mode` varchar(100) NOT NULL,
  `price` float NOT NULL,
  `s_no` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `trgr`
--

INSERT INTO `trgr` (`ID`, `payment_id`, `payment_mode`, `price`, `s_no`, `action`, `time`) VALUES
(15, 24, 'UPI', 1170, 58, 'PAYMENT MADE', '2022-01-31 11:35:29'),
(16, 24, 'cash', 1170, 58, 'PAYMENT UPDATED', '2022-01-31 11:43:26'),
(17, 24, 'cash', 2000, 58, 'PAYMENT UPDATED', '2022-01-31 11:44:35'),
(18, 24, 'cash', 2000, 58, 'PAYMENT DELETED', '2022-01-31 11:45:38'),
(19, 25, 'payment_mode', 170, 62, 'PAYMENT MADE', '2022-02-01 11:36:54'),
(20, 26, 'payment_mode', 640, 63, 'PAYMENT MADE', '2022-02-01 11:38:15'),
(21, 27, 'cash', 1600, 73, 'PAYMENT MADE', '2022-02-01 12:45:44'),
(22, 28, 'UPI', 670, 74, 'PAYMENT MADE', '2022-02-03 10:28:41'),
(23, 30, 'cash', 300, 76, 'PAYMENT MADE', '2022-02-03 15:26:07'),
(24, 30, 'cash', 300, 76, 'PAYMENT DELETED', '2022-02-03 15:36:38'),
(25, 31, 'cash', 20000, 77, 'PAYMENT MADE', '2022-02-03 15:53:46'),
(26, 33, 'UPI', 560, 78, 'PAYMENT MADE', '2022-02-05 08:45:33');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`s_no`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`employee_id`);

--
-- Indexes for table `ice_cream`
--
ALTER TABLE `ice_cream`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `icree` (`creator_id`),
  ADD KEY `nerwdsfrg` (`waiter_id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `nerw` (`s_no`),
  ADD KEY `new` (`item_id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `pay` (`s_no`),
  ADD KEY `pay2` (`emp_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`p_id`),
  ADD KEY `pro` (`emp_id`),
  ADD KEY `prod` (`sup_id`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`sup_id`);

--
-- Indexes for table `trgr`
--
ALTER TABLE `trgr`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `s_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT for table `ice_cream`
--
ALTER TABLE `ice_cream`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `p_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `sup_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `trgr`
--
ALTER TABLE `trgr`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ice_cream`
--
ALTER TABLE `ice_cream`
  ADD CONSTRAINT `icree` FOREIGN KEY (`creator_id`) REFERENCES `employee` (`employee_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `nerwdsfrg` FOREIGN KEY (`waiter_id`) REFERENCES `employee` (`employee_id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `nerw` FOREIGN KEY (`s_no`) REFERENCES `customer` (`s_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `new` FOREIGN KEY (`item_id`) REFERENCES `ice_cream` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `pay` FOREIGN KEY (`s_no`) REFERENCES `customer` (`s_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pay2` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`employee_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `pro` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`employee_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `prod` FOREIGN KEY (`sup_id`) REFERENCES `supplier` (`sup_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
