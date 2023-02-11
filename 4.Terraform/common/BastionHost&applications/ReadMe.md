* generate ssh key for EC2 
  * public key stored in keypairs (to launch instance) and private key stored in secrets (for ssh connection )
```shell
mkdir ~/.sshkeys/ ; ssh-keygen  -t  rsa -C "$HOSTNAME" -f "$HOME/.sshkeys/id_rsa" -P ""
```

