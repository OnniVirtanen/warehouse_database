-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema warehouse_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `warehouse_db` ;

-- -----------------------------------------------------
-- Schema warehouse_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `warehouse_db` DEFAULT CHARACTER SET utf8 ;
USE `warehouse_db` ;

-- luodaan category tauul
-- -----------------------------------------------------
-- Table `warehouse_db`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`category_id`),
  INDEX idx_category_name (`category_name` ASC))
ENGINE = InnoDB;


-- luodaan product taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`product` (
  `product_id` INT NOT NULL,
  `external_id` VARCHAR(45) NULL,
  `product_name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `category` INT NULL,
  `unit_price` DECIMAL(6,2) NOT NULL,
  `image_path` VARCHAR(45) NULL,
  PRIMARY KEY (`product_id`),
  INDEX `fk_product_category1_idx` (`category` ASC) VISIBLE,
  INDEX idx_product_name (`product_name` ASC),
  CONSTRAINT `fk_product_category1`
    FOREIGN KEY (`category`)
    REFERENCES `warehouse_db`.`category` (`category_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- luodaan customer taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `contact_name` VARCHAR(45) NOT NULL,
  `billing_address` VARCHAR(100) NOT NULL,
  `shipping_address` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;

-- luodaan supplier taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`supplier` (
  `supplier_id` INT NOT NULL AUTO_INCREMENT,
  `supplier_name` VARCHAR(45) NOT NULL,
  `contact_name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`supplier_id`))
ENGINE = InnoDB;

-- luodaan employee taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`employee` (
  `employee_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `hire_date` DATE NOT NULL,
  `department` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`employee_id`))
ENGINE = InnoDB;

-- luodaan location taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`location` (
  `location_id` INT NOT NULL AUTO_INCREMENT,
  `location_name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NULL,
  `aisle` VARCHAR(10) NOT NULL,
  `shelf` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`location_id`),
  UNIQUE INDEX `location_id_UNIQUE` (`location_id` ASC) VISIBLE)
ENGINE = InnoDB;

-- luodaan inventory taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`inventory` (
  `inventory_id` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `location_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `last_updated` TIMESTAMP NOT NULL,
  PRIMARY KEY (`inventory_id`),
  INDEX `fk_inventory_location1_idx` (`location_id` ASC) VISIBLE,
  INDEX `fk_inventory_product1_idx` (`product_id` ASC) VISIBLE,
  INDEX idx_inventory_quantity (`quantity` ASC),
  CONSTRAINT `fk_inventory_location1`
    FOREIGN KEY (`location_id`)
    REFERENCES `warehouse_db`.`location` (`location_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_inventory_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `warehouse_db`.`product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- luodaan purchase_order taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`purchase_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`purchase_order` (
  `purchase_order_id` INT NOT NULL AUTO_INCREMENT,
  `supplier_id` INT NOT NULL,
  `order_date` DATE NOT NULL,
  `expected_delivery_date` DATE NOT NULL,
  `order_status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`purchase_order_id`),
  INDEX `fk_purchase_order_supplier1_idx` (`supplier_id` ASC) VISIBLE,
  CONSTRAINT `fk_purchase_order_supplier1`
    FOREIGN KEY (`supplier_id`)
    REFERENCES `warehouse_db`.`supplier` (`supplier_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Luodaan purchase_order_item taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`purchase_order_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`purchase_order_item` (
  `purchase_order_item_id` INT NOT NULL AUTO_INCREMENT,
  `purchase_order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `unit_price` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`purchase_order_item_id`),
  INDEX idx_purchase_order_item_quantity (`quantity` ASC),
  INDEX `fk_purchase_order_item_purchase_order1_idx` (`purchase_order_id` ASC) VISIBLE,
  INDEX `fk_purchase_order_item_product1_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `fk_purchase_order_item_purchase_order1`
    FOREIGN KEY (`purchase_order_id`)
    REFERENCES `warehouse_db`.`purchase_order` (`purchase_order_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_purchase_order_item_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `warehouse_db`.`product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- luodaan sales_order taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`sales_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`sales_order` (
  `sales_order_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `employee_id` INT NOT NULL,
  `order_date` DATE NOT NULL,
  `shipping_date` DATE NOT NULL,
  `order_status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`sales_order_id`),
  INDEX `fk_sales_order_customer1_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_sales_order_employee1_idx` (`employee_id` ASC) VISIBLE,
  CONSTRAINT `fk_sales_order_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `warehouse_db`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sales_order_employee1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `warehouse_db`.`employee` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- luodaan sales_order_item taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`sales_order_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`sales_order_item` (
  `sales_order_item_id` INT NOT NULL AUTO_INCREMENT,
  `sales_order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `unit_price` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`sales_order_item_id`),
  INDEX `fk_sales_order_item_sales_order1_idx` (`sales_order_id` ASC) VISIBLE,
  INDEX `fk_sales_order_item_product1_idx` (`product_id` ASC) VISIBLE,
  INDEX idx_sales_order_item_quantity (`quantity` ASC),
  CONSTRAINT `fk_sales_order_item_sales_order1`
    FOREIGN KEY (`sales_order_id`)
    REFERENCES `warehouse_db`.`sales_order` (`sales_order_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_sales_order_item_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `warehouse_db`.`product` (`product_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- luodaan shipment taulu
-- -----------------------------------------------------
-- Table `warehouse_db`.`shipment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_db`.`shipment` (
  `shipment_id` INT NOT NULL AUTO_INCREMENT,
  `sales_order_id` INT NOT NULL,
  `carrier` VARCHAR(45) NOT NULL,
  `tracking_number` VARCHAR(45) NOT NULL,
  `shipment_status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`shipment_id`),
  INDEX `fk_shipment_sales_order1_idx` (`sales_order_id` ASC) VISIBLE,
  CONSTRAINT `fk_shipment_sales_order1`
    FOREIGN KEY (`sales_order_id`)
    REFERENCES `warehouse_db`.`sales_order` (`sales_order_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Lisää dataa tauluun category
INSERT INTO `warehouse_db`.`category` (`category_name`, `description`)
VALUES ('Mikrokontrollerit', 'Mikrokontrollerit ja ohjainpiirit'),
       ('Sähkötarvikkeet', 'Sähkö- ja johdotustarvikkeet'),
       ('Elektroniikkatyökalut', 'Työkalut elektroniikka- ja huoltotöihin');

-- Lisää dataa tauluun product
INSERT INTO `warehouse_db`.`product` (`product_id`, `product_name`, `description`, `category`, `unit_price`, `image_path`)
VALUES (1, 'Arduino Uno', 'Mikrokontrolleri kehitysalusta', 1, 19.90, '/images/arduino_uno.jpg'),
       (2, 'Juotosasema', 'Säädettävän lämpötilan juotosasema', 3, 49.99, '/images/juotosasema.jpg'),
       (3, 'Johtosarja', 'Eri värisiä ja pituisia johtoja', 2, 9.95, '/images/johtosarja.jpg');

-- Lisää dataa tauluun customer
INSERT INTO `warehouse_db`.`customer` (`first_name`, `last_name`, `contact_name`, `billing_address`, `shipping_address`, `phone`, `email`)
VALUES ('Matti', 'Virtanen', 'Matti Virtanen', 'Kotikatu 1, 00100 Helsinki', 'Kotikatu 1, 00100 Helsinki', '0401234567', 'matti.virtanen@email.com'),
       ('Liisa', 'Lahtinen', 'Liisa Lahtinen', 'Puistokatu 5, 00200 Espoo', 'Puistokatu 5, 00200 Espoo', '0509876543', 'liisa.lahtinen@email.com'),
       ('Antti', 'Korhonen', 'Antti Korhonen', 'Mäkitie 8, 00300 Vantaa', 'Mäkitie 8, 00300 Vantaa', '0451230987', 'antti.korhonen@email.com');

-- Lisää dataa tauluun supplier
INSERT INTO `warehouse_db`.`supplier` (`supplier_name`, `contact_name`, `address`, `phone`, `email`)
VALUES ('Elektroniikkavarasto Oy', 'Timo Tikkunen', 'Teollisuuskatu 1, 00500 Helsinki', '0441234567', 'timo.tikkunen@elektroniikkavarasto.fi'),
       ('Piirilevyt Oy', 'Anneli Piirainen', 'Kivenlahdentie 2, 02100 Espoo', '0409876543', 'anneli.piirainen@piirilevyt.fi'),
       ('Komponentti Ky', 'Kari Komppa', 'Koivukuja 3, 01500 Vantaa', '0411230987', 'kari.komppa@komponentti.fi');

-- Lisää dataa tauluun employee
INSERT INTO `warehouse_db`.`employee` (`first_name`, `last_name`, `title`, `hire_date`, `department`)
VALUES ('Mikko', 'Mäkinen', 'Myyntipäällikkö', '2020-02-01', 'Myynti'),
       ('Laura', 'Leppänen', 'Varastopäällikkö', '2019-08-15', 'Varasto'),
       ('Petri', 'Peltola', 'Tekninen tuki', '2021-01-03', 'Asiakastuki');

-- Lisää dataa tauluun location
INSERT INTO `warehouse_db`.`location` (`location_name`, `description`, `aisle`, `shelf`)
VALUES ('Mikrokontrollerihylly', 'Mikrokontrollerit ja ohjaimet', 'A1', 'S1'),
       ('Sähkötarvikkeet-hylly', 'Sähkö- ja johdotustarvikkeet', 'B1', 'S1'),
       ('Työkaluhylly', 'Työkalut ja tarvikkeet', 'C1', 'S1');

-- Lisää dataa tauluun inventory
INSERT INTO `warehouse_db`.`inventory` (`product_id`, `location_id`, `quantity`, `last_updated`)
VALUES (1, 1, 50, NOW()),
       (2, 3, 20, NOW()),
       (3, 2, 100, NOW());

-- Lisää dataa tauluun purchase_order
INSERT INTO `warehouse_db`.`purchase_order` (`supplier_id`, `order_date`, `expected_delivery_date`, `order_status`)
VALUES (1, '2023-04-01', '2023-04-05', 'Toimitettu'),
       (2, '2023-04-06', '2023-04-10', 'Toimitettu'),
       (3, '2023-04-11', '2023-04-15', 'Toimitettu');

-- Lisää dataa tauluun purchase_order_item
INSERT INTO `warehouse_db`.`purchase_order_item` (`purchase_order_id`, `product_id`, `quantity`, `unit_price`)
VALUES (1, 1, 20, 15.99),
       (2, 2, 50, 2.99),
       (3, 3, 10, 49.99);

-- Lisää dataa tauluun sales_order
INSERT INTO `warehouse_db`.`sales_order` (`customer_id`, `employee_id`, `order_date`, `shipping_date`, `order_status`)
VALUES (1, 1, '2023-04-03', '2023-04-05', 'Toimitettu'),
       (2, 1, '2023-04-07', '2023-04-09', 'Toimitettu'),
       (3, 2, '2023-04-12', '2023-04-14', 'Toimitettu');

-- Lisää dataa tauluun sales_order_item
INSERT INTO `warehouse_db`.`sales_order_item` (`sales_order_id`, `product_id`, `quantity`, `unit_price`)
VALUES (1, 1, 5, 15.99),
       (2, 2, 20, 2.99),
       (3, 3, 3, 49.99);

-- Lisää dataa tauluun shipment
INSERT INTO `warehouse_db`.`shipment` (`sales_order_id`, `carrier`, `tracking_number`, `shipment_status`)
VALUES (1, 'Posti', 'POSTI123456', 'Toimitettu'),
       (2, 'Matkahuolto', 'MH789012', 'Toimitettu'),
       (3, 'DHL', 'DHL345678', 'Toimitettu');

-- Luodaan erilaisia näkymiä
-- näkymä, jolla saa asiakkaan kaikki tilaukset
-- -----------------------------------------------------
-- View `warehouse_db`.`customer_total_orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `warehouse_db`.`customer_total_orders`;
USE `warehouse_db`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `warehouse_db`.`customer_total_orders` AS select `c`.`customer_id` AS `customer_id`,`c`.`first_name` AS `first_name`,`c`.`last_name` AS `last_name`,count(`so`.`sales_order_id`) AS `total_orders` from (`warehouse_db`.`customer` `c` join `warehouse_db`.`sales_order` `so` on(`c`.`customer_id` = `so`.`customer_id`)) group by `c`.`customer_id`;

-- näkymä, jolla saa tuotteen kpl määrästä tietoa
-- -----------------------------------------------------
-- View `warehouse_db`.`product_stock_information`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `warehouse_db`.`product_stock_information`;
USE `warehouse_db`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `warehouse_db`.`product_stock_information` AS select `p`.`product_id` AS `product_id`,`p`.`product_name` AS `product_name`,`i`.`location_id` AS `location_id`,`i`.`quantity` AS `stock_quantity` from (`warehouse_db`.`product` `p` join `warehouse_db`.`inventory` `i` on(`p`.`product_id` = `i`.`product_id`));

-- näkymä, jolla näkee tuotteen myynnit
-- -----------------------------------------------------
-- View `warehouse_db`.`product_total_sales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `warehouse_db`.`product_total_sales`;
USE `warehouse_db`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `warehouse_db`.`product_total_sales` AS select `p`.`product_id` AS `product_id`,`p`.`product_name` AS `product_name`,sum(`soi`.`quantity`) AS `total_sales` from (`warehouse_db`.`product` `p` join `warehouse_db`.`sales_order_item` `soi` on(`p`.`product_id` = `soi`.`product_id`)) group by `p`.`product_id`;

-- näkymä, jolla näkyy tuotteiden kategoriat
-- -----------------------------------------------------
-- View `warehouse_db`.`products_with_categories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `warehouse_db`.`products_with_categories`;
USE `warehouse_db`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `warehouse_db`.`products_with_categories` AS select `p`.`product_id` AS `product_id`,`p`.`product_name` AS `product_name`,`c`.`category_name` AS `category_name` from (`warehouse_db`.`product` `p` join `warehouse_db`.`category` `c` on(`p`.`category` = `c`.`category_id`));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
