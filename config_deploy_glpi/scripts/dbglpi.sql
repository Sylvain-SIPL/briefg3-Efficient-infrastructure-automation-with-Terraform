CREATE DATABASE glpi;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;