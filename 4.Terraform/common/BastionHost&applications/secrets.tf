locals {
  secret_types = ["spec/ssh", "spec/keys"]
}

resource "aws_secretsmanager_secret" "secret" {
  count = length(local.secret_types)
  name = local.secret_types[count.index]
}


resource "aws_secretsmanager_secret_version" "secretvalue" {
  count = length(local.secret_types)
  secret_id     = aws_secretsmanager_secret.secret.*.id[count.index]
  secret_string = count.index == 0 ? file("~/.sshkeys/id_rsa") : base64decode(var.dd)
}