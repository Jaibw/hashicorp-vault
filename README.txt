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


export VAULT_ADDR=http://PublicIPs
echo "export VAULT_ADDR=http://PublicIPs" >> ~/.bashrc 
vault login   ## with root token 

vault secrets disable project01
vault secrets disable project02

vault secrets enable -path=project01 kv 
vault secrets enable -path=project02 kv 

cat > project01-policy.hcl <<EOF
path "project01/database" {
    capabilities = ["create", "read"]
}
EOF

cat project01-policy.hcl 
vault policy write project01-policy project01-policy.hcl
vault token create -policy="project01-policy"

vault login   ## give your new token 
vault kv put project01/database db=127.0.0.1
vault kv put project02/database db=127.0.0.1

vault login   ## with root token 
vault kv put project02/database db=127.0.0.1


vault login
vault auth enable userpass
vault write auth/userpass/users/user01 password=password -policy="project01-policy"
## Open Vault Web interface with Username and try to login with user01 password

vault auth enable github
vault write auth/github/config organization=demo-001
vault write auth/github/map/teams/development value=dev-policy
vault write auth/github/map/users/jaibw value=dev-policy
vault auth list
## Open Vault Web interface with GitHub and try with shared token on notepad 

sudo apt install jq 
export VAULTIP=###.###.###.###
export VAULTTOKEN=s.###########

vault secrets disable project01
vault secrets enable -path=project01 kv
vault kv put project01/database db=127.0.0.1

curl --location --request GET "$VAULTIP/v1/project01/database" --header "Authorization: Bearer $VAULTTOKEN" | jq '.data'

curl --location --request POST "$VAULTIP/v1/project01/database" --header "Authorization: Bearer $VAULTTOKEN"  --header 'Content-Type: application/json' --data-raw '{
    "dbname": "demo1",
    "dbuser": "root1",
    "password": "password1",
    "dbport": "3306"
}'


curl --location --request GET "$VAULTIP/v1/project01/database" --header "Authorization: Bearer $VAULTTOKEN" | jq '.data'

cat > payload.json <<EOF
{
"dbname": "alpha",
"dbport": "31006",
"dbuser": "random1",
"password": "p@ssw0rd"
}
EOF

cat payload.json 

curl --location --request POST "$VAULTIP/v1/project01/database" --header "Authorization: Bearer $VAULTTOKEN" --header 'Content-Type: application/json' --data @payload.json

curl --location --request GET "$VAULTIP/v1/project01/database" --header "Authorization: Bearer $VAULTTOKEN" | jq '.data'



vault secrets enable aws

vault write aws/config/root \
    access_key=############### \
    secret_key=############################################ \
    region=us-east-1

vault write aws/roles/my-role \
    credential_type=iam_user \
    policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOF

vault read aws/creds/my-role 



vault secrets enable -version=2 -path=project06  kv
vault kv put project06/db host=127.0.0.1
vault kv put project06/db host=192.168.0.1
vault kv put project06/db host=10.0.0.1
vault kv get project06/db
vault kv get -version=2 project06/db
vault kv get -version=3 project06/db
vault kv get -version=1 project06/db

export VAULTIP=##.##.##.##
export VAULTTOKEN=s.############################
curl --location --request GET "$VAULTIP/v1/project06/data/db?version=1" --header "Authorization: Bearer $VAULTTOKEN" | jq '.data.data'
curl --location --request GET "$VAULTIP/v1/project06/data/db?version=2" --header "Authorization: Bearer $VAULTTOKEN" | jq '.data.data'
curl --location --request GET "$VAULTIP/v1/project06/data/db?version=3" --header "Authorization: Bearer $VAULTTOKEN" | jq '.data.data'
