variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}
variable "ssh_port" {}
resource "null_resource" "ssh_target" {
    connection {
		type	=	"ssh"
		user	=	var.ssh_user
		host	=	var.ssh_host
		port    =   var.ssh_port
		private_key = file(var.ssh_key)
    }

provisioner "file" {
    source = "scripts/mysql_secure_installation.sh"
    destination = "/tmp/mysql_secure_installation.sh"
  }
    
provisioner "file" {
    source = "scripts/dbglpi.sql"
    destination = "/tmp/dbglpi.sql"
  }


# installation
  provisioner "remote-exec" {
    inline=[
      "sudo apt-get update",
      "sudo apt-get -y install apache2 mariadb-server php php-mysql libapache2-mod-php php-cli expect wget rsync php-curl php-gd php-intl php-xml php-json php-xmlrpc expect wget rsync unzip",
      "sudo systemctl enable mariadb",
      "sudo systemctl start mariadb",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "sudo mv /var/www/html/index.html /var/www/html/index.html.bak",
      "chmod +x /tmp/mysql_secure_installation.sh",
      "expect /tmp/mysql_secure_installation.sh",
      "wget -c https://github.com/glpi-project/glpi/releases/download/10.0.7/glpi-10.0.7.tgz",
      "tar -xzvf glpi-10.0.7.tgz",
      "sudo rsync -av glpi/* /var/www/html/",
      "sudo chown -R www-data:www-data /var/www/html/",
      "sudo chmod -R 755 /var/www/html/",
      "sudo mysql -uroot -proot123 < /tmp/dbglpi.sql",
      "sudo systemctl restart apache2",
    ]
  }
}





















