## Install Hashicorp Vault on Ubuntu 20.04 

sudo apt update 
sudo apt install unzip -y 
wget https://releases.hashicorp.com/vault/1.5.0/vault_1.5.0_linux_amd64.zip
unzip vault_1.5.0_linux_amd64.zip 
ls
sudo mv vault /usr/bin
vault -h 
vault -version


## Install on Windows 
Open the powershell and run: 
wget -Uri https://releases.hashicorp.com/vault/1.5.0/vault_1.5.0_windows_amd64.zip -OutFile "vault_1.5.0_windows_amd64.zip" -Verbose
Expand-Archive .\vault_1.5.0_windows_amd64.zip -DestinationPath C:\Windows\
vault -h 
vault -version

