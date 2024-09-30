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
    source = "scripts/dbwordpress.sql"
    destination = "/tmp/dbwordpress.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install apache2 mariadb-server php php-mysql libapache2-mod-php php-cli expect wget rsync",
      "sudo systemctl enable mariadb",
      "sudo systemctl start mariadb",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "sudo mv /var/www/html/index.html /var/www/html/index.html.bak",
      "chmod +x /tmp/mysql_secure_installation.sh",
      "expect /tmp/mysql_secure_installation.sh",
      "wget -c http://wordpress.org/latest.tar.gz",
      "tar -xzvf latest.tar.gz",
      "sudo rsync -av wordpress/* /var/www/html/",
      "sudo chown -R www-data:www-data /var/www/html/",
      "sudo chmod -R 755 /var/www/html/",
      "sudo mysql -uroot -proot123 < /tmp/dbwordpress.sql",
      "sudo systemctl restart apache2",
    ]
  }

}