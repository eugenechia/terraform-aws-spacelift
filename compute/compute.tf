resource "aws_key_pair" "spacelift_auth" {
  key_name   = var.key_name
  public_key = file("/mnt/workspace/tf-spacelift.pub")
}

resource "aws_instance" "dev_node" {
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_id
  subnet_id              = var.subnet_id
  user_data              = file("${path.module}/userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "${var.node_name}-dev-node"
  }

  # provisioner "local-exec" {
  #   command = templatefile("${var.host_os}-ssh-config.tpl", {
  #     hostname = self.public_ip,
  #     user     = "ubuntu",
  #   identityfile = "~/.ssh/tf-spacelift" })
  #   //interpreter = ["bash", "-c"]
  # }
}