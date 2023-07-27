#!/bin/bash

# coolkey is what cyber.mil sugests

sudo apt update -y
sudo apt upgrade -y
sudo apt install firefox -y
sudo apt install coolkey -y
sudo apt install pcscd -y

mkdir $HOME/.mozilla/certificates
mkdir $HOME/tmp

cd $HOME/tmp

wget https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/unclass-certificates_pkcs7_v5-6_dod.zip
unzip -o unclass-certificates_pkcs7_v5-6_dod.zip

# need to get location of .so file
libloc=$(sudo find / -name "libcoolkeypk11.so" 2>/dev/null | head -n 1)
certfolder=$HOME/.mozilla/certificates/

echo $libloc

certutil -d $certfolder -N --empty-password
modutil -dbdir sql:$certfolder -add "CAC Module" -libfile $libloc

for i in $(find Certificates_PKCS7_v5.6_DoD/ -name "*.p7b"); do
    # certutil -A -n $i -t TC,C,T -d $certfolder -a -i $i
    echo $i
    echo "end"
    done

rm -rf $HOME/tmp/

# /usr/lib/mozilla/certificates
# /usr/lib64/mozilla/certificates
# ~/.mozilla/certificates