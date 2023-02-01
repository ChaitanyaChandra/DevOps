yum install wget tar git -y

sudo yum -y groupinstall "Development Tools"
sudo yum install gcc openssl-devel bzip2-devel libffi-devel zlib-devel -y
cd /opt
wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
tar xzvf Python-3.9.7.tgz
cd Python-3.9.7/
sudo ./configure --enable-optimizations
sudo make altinstall
rm -rf /usr/bin/python3
ln -s /opt/Python-3.9.7/python /usr/bin/python3
alias python='/usr/bin/python3'
python -m pip install --upgrade pip
cd .. ; sudo rm Python-3.8.12.tgz

yum install git -y
python3 -m pip install ansible botocore boto3 python-jenkins