# packer-aws-centos7
Packer scripts to build a clean CentOS 7 AWS box

```
export AWS_ACCESS_KEY_ID=XXX
export AWS_SECRET_ACCESS_KEY=XXX
export AMI_DESCRIPTION="CentOS 7(x86_64) with python3.9 and ansible pre-installed"
./build.sh 'us-east-1'
```