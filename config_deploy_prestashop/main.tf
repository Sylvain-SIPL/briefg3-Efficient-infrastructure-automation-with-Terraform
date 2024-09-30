variable "ssh_key" {}
variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_port" {}

resource "null_resource" "ssh_target" {
  connection {
    type        = "ssh"
    port        = var.ssh_port
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file(var.ssh_key)
  }

  provisioner "file" {
    source = "scripts/mysql_secure_installation.sh"
    destination = "/tmp/mysql_secure_installation.sh"
  }
    
  provisioner "file" {
    source = "scripts/dbpresta.sql"
    destination = "/tmp/dbpresta.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install apache2 mariadb-server php php-mysql libapache2-mod-php php-cli php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip expect wget rsync unzip",
      "sudo systemctl enable mariadb",
      "sudo systemctl start mariadb",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "sudo mv /var/www/html/index.html /var/www/html/index.html.bak",
      "chmod +x /tmp/mysql_secure_installation.sh",
      "expect /tmp/mysql_secure_installation.sh",
      "sudo wget https://download.prestashop.com/download/releases/prestashop_1.7.7.8.zip",
      "sudo unzip -o prestashop_1.7.7.8.zip",
      "sudo unzip -o prestashop.zip -d /var/www/html/",
      "sudo chown -R www-data:www-data /var/www/html/",
      "sudo chmod -R 755 /var/www/html/",
      "sudo mysql -uroot -proot123 < /tmp/dbpresta.sql",
      "sudo systemctl restart apache2",
    ]
  }

}