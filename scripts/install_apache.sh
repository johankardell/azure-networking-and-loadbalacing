#! /bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2

host=$(hostname)
echo "<h1>Deployed via Terraform</h1><br>Currently serving content from $host" | sudo tee /var/www/html/index.html