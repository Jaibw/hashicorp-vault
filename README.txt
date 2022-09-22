## Install on Windows 
Open the powershell and run: 
wget -Uri https://releases.hashicorp.com/vault/1.5.0/vault_1.5.0_windows_amd64.zip -OutFile "vault_1.5.0_windows_amd64.zip" -Verbose
Expand-Archive .\vault_1.5.0_windows_amd64.zip -DestinationPath C:\Windows\
vault -h 
vault -version



## Install Hashicorp Vault on Ubuntu 20.04 

sudo apt update 
sudo apt install unzip -y 
wget https://releases.hashicorp.com/vault/1.5.0/vault_1.5.0_linux_amd64.zip
unzip vault_1.5.0_linux_amd64.zip 
ls
sudo mv vault /usr/bin
vault -h 
vault -version

wget https://releases.hashicorp.com/consul/1.7.3/consul_1.7.3_linux_amd64.zip
unzip consul_1.7.3_linux_amd64.zip 
ls
sudo mv consul /usr/bin
consul
wget https://raw.githubusercontent.com/Jaibw/hashicorp-vault/master/install/config.hcl
wget https://raw.githubusercontent.com/Jaibw/hashicorp-vault/master/install/consul.service
wget https://raw.githubusercontent.com/Jaibw/hashicorp-vault/master/install/ui.json
wget https://raw.githubusercontent.com/Jaibw/hashicorp-vault/master/install/vault.service

sed -i 's/SERVERIP_ADDRESS/172.#.#.#/' consul.service
sed -i 's/SERVERIP_ADDRESS/172.#.#.#/' config.hcl

sudo mkdir /etc/consul.d
sudo mkdir /etc/vault/
sudo mv ui.json /etc/consul.d/
sudo chown root:root /etc/consul.d/ui.json
sudo mv config.hcl /etc/vault/
sudo chown root:root /etc/vault/config.hcl

sudo cp consul.service /etc/systemd/system/consul.service
sudo chown root:root /etc/systemd/system/consul.service
sudo cp vault.service /etc/systemd/system/vault.service
sudo chown root:root /etc/systemd/system/vault.service


sudo systemctl daemon-reload
sudo systemctl start consul
sudo systemctl enable consul
sudo systemctl start vault
sudo systemctl enable vault
sudo systemctl status consul                      # press q to exit 
sudo systemctl status vault                       # press q to exit 

Try to open http://PublicIPs

export VAULT_ADDR=http://PublicIPs
echo "export VAULT_ADDR=http://PublicIPs" >> ~/.bashrc 
vault operator init                            # copy and save the output 
vault operator unseal                          # paster key1 
vault operator unseal                          # paster key2
vault operator unseal                          # paster key3
vault login #Initial_Root_Token#


### Reset Consul - Don't run it in production 
# consul kv delete -recurse vault/
# sudo systemctl restart vault 
# vault operator init 
#############################################


vault login #Initial_Root_Token#
vault secrets list 
vault secrets enable -path=app001 kv
vault secrets enable -path=app002 kv
vault secrets list 
vault kv put app001/dbname name=db_app001
vault kv get app001/dbname
# create app004 from web interface with api-config key 
vault kv get app004/api-config
vault kv delete app004/api-config
vault secrets disable app004/
vault secrets disable app001/
vault secrets disable app002/


