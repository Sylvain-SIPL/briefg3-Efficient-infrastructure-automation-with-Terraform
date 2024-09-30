CREATE DATABASE prestashop;
CREATE USER 'prestauser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON prestashop.* TO 'prestauser'@'localhost';
FLUSH PRIVILEGES;