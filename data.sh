# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
sudo usermod -aG docker ec2-user
sudo chmod 666 /var/run/docker.sock
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
systemctl start docker
# Create docker-compose.yml file
cat > /home/ec2-user/docker-compose.yml <<EOL
version: '3.3'
services:
  db:
    image: mysql:8.0.19
    command: --default-authentication-plugin=mysql_native_password
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=wordpress
      - MYSQL_DATABASE=databaseword
      - MYSQL_USER=admin
      - MYSQL_PASSWORD=admin123

  wordpress:
    image: wordpress:latest
    ports:
      - "80:80"
    restart: always
    environment:
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_USER=admin
      - WORDPRESS_DB_PASSWORD=admin123
      - WORDPRESS_DB_NAME=databaseword

volumes:
  db_data:
EOL

# Change permissions for the docker-compose file
chmod 644 /home/ec2-user/docker-compose.yml

# Run Docker Compose
cd /home/ec2-user
docker-compose up -d

# Optional: Check if containers are running
docker ps
