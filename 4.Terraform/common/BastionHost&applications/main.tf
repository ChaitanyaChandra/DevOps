# key pair
resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = file("~/.ssh/id_rsa.pub")
  tags       = local.tags
}

locals {
  # tags_dest      = ["instance", "volume", "network-interface", "spot--request"]
  instance_types = ["workstation", "jenkins", "sonar", "nexus"]
  roles = ["jenkins_node_setup", "jenkins_setup", "sonarqube_setup", "nexus_setup"]
}

resource "aws_iam_role" "admin" {
  name               = "${local.tags.Service}-${local.Environment}-einstancesc2-spot-role"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-ec2-admin-role"
  }), local.tags)
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.admin.name
}

resource "aws_iam_instance_profile" "profile" {
  name = "instance-profile-${local.Environment}"
  role = aws_iam_role.admin.id
}

resource "aws_spot_instance_request" "vm" {
  count = length(local.instance_types)
  key_name = aws_key_pair.deployer.key_name
  ami = "ami-07acf41a58c76cc08"
  iam_instance_profile = aws_iam_instance_profile.profile.name
  availability_zone = data.aws_availability_zones.az.names[0]
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.internet_facing.id]
  root_block_device {
    volume_size = "10"
    volume_type = "gp2"
  }
  instance_type = "t2.medium"
  wait_for_fulfillment = true

  provisioner "remote-exec" {
    connection {
      timeout     = "4m"
      type        = "ssh"
      user        = "centos"
      private_key = file("~/.ssh/id_rsa")
      host     = self.public_ip

    }

    inline = [
      "ansible-pull -U https://github.com/ChaitanyaChandra/DevOps.git 2.ANSIBLE/spec.yml -e 'ROLE=${local.roles[count.index]}' -e 'HOST=localhost' -e 'ROOT_USER=true' -c 2.ANSIBLE/ansible.cfg -d /tmp/ansible"
    ]
  }
  tags = merge(tomap({
    "Name" = "${local.tags.Service}-${local.Environment}-${local.instance_types[count.index]}"
  }), local.tags)
}