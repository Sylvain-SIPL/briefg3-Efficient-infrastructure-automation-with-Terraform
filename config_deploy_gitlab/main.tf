variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}
resource "null_resource" "ssh_target" {
    connection {
		type	=	"ssh"
		user	=	var.ssh_user
		host	=	var.ssh_host
		private_key = file(var.ssh_key)
    }
    provisioner "remote-exec" {
		inline= [
			"sudo apt-get update",
			"sudo apt-get install -y curl openssh-server ca-certificates tzdata perl",
			"cd /tmp",
			"curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash",
			"sudo EXTERNAL_URL=\"http://${var.ssh_host}\" apt-get install -y gitlab-ee"
	 ]
    }
    
    
}
