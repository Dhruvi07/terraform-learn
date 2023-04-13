provider "aws"{
    region = "ap-south-1"
    access_key = "${var.aws_accesskey}"
    secret_key = "${var.aws_secretkey}"
}

resource "tls_private_key" "key-example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terraform-key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.key-example.public_key_openssh
  provisioner "local-exec" {
    command = "echo ${tls_private_key.key-example.private_key_openssh} > terraform.pem"
  }
}

resource "aws_instance" "tf-prac" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.aws_ins_type}"
  tags = {
    Name = "terraform practice"
  }
  key_name = "${aws_key_pair.terraform-key.key_name}"
}