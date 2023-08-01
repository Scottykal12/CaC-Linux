#!/bin/bash

# coolkey is what cyber.mil sugests

sudo apt update -y
sudo apt upgrade -y
sudo apt install firefox -y
sudo apt install coolkey -y
sudo apt install pcscd -y
sudo apt install openssl -y

sudo mkdir /usr/lib/mozilla/certificates
mkdir $HOME/tmp
mkdir $HOME/tmp/rootCAcer
sudo mkdir -p /etc/firefox/policies

sudo chmod 775 /etc/firefox -R

# sudo touch /etc/firefox/policies.json
sudo printf '{\n "policies": {\n  "ImportEnterpriseRoots": true\n }\n}' > policies.json

sudo chmod 777 /usr/lib/mozilla/certificates

cd $HOME/tmp

wget https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/unclass-certificates_pkcs7_v5-6_dod.zip
unzip -o unclass-certificates_pkcs7_v5-6_dod.zip

# need to get location of .so file
libloc=$(sudo find / -name "libcoolkeypk11.so" 2>/dev/null | head -n 1)
certfolder=/usr/lib/mozilla/certificates
# /usr/lib/mozilla/certificates
# $HOME/.mozilla/certificates/
rootCAcer=$HOME/tmp/rootCAcer

echo $libloc

certutil -d $certfolder -N --empty-password
modutil -dbdir sql:$certfolder -add "CAC Module" -libfile $libloc

for i in $(find $PWD/Certificates_PKCS7_v5.6_DoD/ -name "*Root_CA*"); do
    name=$(basename $i .der.p7b)
    openssl pkcs7 -print_certs -inform DER -in $i -out $name.cer
    certutil -A -n $name -t TC,C,T -d $certfolder -a -i $name.cer
    done

# rm -rf $HOME/tmp/

# /usr/lib/mozilla/certificates
# /usr/lib64/mozilla/certificates
# ~/.mozilla/certificates