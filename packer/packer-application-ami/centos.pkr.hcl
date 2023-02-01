source "amazon-ebssurrogate" "x86_64" {
  source_ami = "ami-002070d43b0a4f171"

  instance_type = "t3.large"
  region        = "us-east-1"

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp2"
  }

  ami_root_device {
    source_device_name    = "/dev/sda1"
    device_name           = "/dev/sda1"
    delete_on_termination = false
    volume_size           = 10
    volume_type           = "gp2"
  }

  run_tags = {
    Name = "Packer EL8 Builder (x86_64)"
  }
  run_volume_tags = {
    Name = "Packer EL8 Builder"
  }

  communicator = "ssh"
  ssh_pty      = true
  ssh_username = "centos"
  ssh_timeout  = "5m"

  ami_name                = "centos7 with python3.9 and ansible pre-installed"
  ami_description         = "CentOS 7(x86_64) with python3.9 and ansible pre-installed"
  ami_virtualization_type = "hvm"
  ami_architecture        = "x86_64"
  ena_support             = true
  sriov_support           = true
  ami_regions             = ["us-east-1"]

  tags = {
    Name      = "centos7 with python3.9 and ansible pre-installed"
    BuildTime = timestamp()
  }
}

build {
  sources = [
    "source.amazon-ebssurrogate.x86_64",
  ]

  provisioner "shell" {
    script              = "scripts/create_base_ami.sh"
    execute_command     = "sudo -S sh '{{.Path}}'"
    inline_shebang      = "/bin/sh -e -x"
    start_retry_timeout = "5m"
  }
}

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
