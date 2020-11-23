#! /bin/bash
sudo apt-get update
sudo apt-get install -y wget
# Insert your wget command to download the Dyantrace ActiveGate binaries. The wget command will look something like this:
 wget  -O /tmp/Dynatrace-ActiveGate-Linux-x86-<version>.sh "https://<tenant>.live.dynatrace.com/api/v1/deployment/installer/gateway/unix/latest?arch=x86&flavor=default" --header="Authorization: Api-Token <your-token>"  
# Update the file name accordingly
sudo /bin/sh /tmp/Dynatrace-ActiveGate-Linux-x86-<version>.sh
echo "<h1>Azure Linux VM with Dynatrace ActiveGate</h1>" | sudo tee /var/www/html/index.html