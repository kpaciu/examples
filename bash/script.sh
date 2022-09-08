echo -e "Install NGINX and php8.1-fpm"
    apt-get update
    apt-get install nginx php8.1-fpm --yes;
echo -e "configure nginx"
touch /etc/nginx/conf.d/default.conf
echo "server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /var/www/html;
        index  index.html index.htm index.nginx-debian.html;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        root           /var/www/php;
        fastcgi_pass   unix:/run/php/php8.1-fpm.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}" > /etc/nginx/conf.d/default.conf

mkdir /var/www/php
touch /var/www/php/index.php
echo "<?php
echo 'Success'; " > /var/www/php/index.php
service nginx restart


echo -e "Install additional software"
apt-get install -y php8.1-curl

echo -e "Install PostgreSQL"
apt-get install -y postgresql postgresql-client postgresql-contrib

echo -e "Configure PostgreSQL"
sudo -Hiu postgres psql -c "CREATE USER root WITH PASSWORD 'root'"
service postgresql restart
echo -e "Succesfully restart"

echo -e "Creating DB and configure it"
sudo -Hiu postgres psql -c "CREATE DATABASE test"
sudo -Hiu postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE test TO root"
echo "Done!"

echo -e "For check it"
curl localhost
curl localhost/index.php
sudo -u postgres psql -c "\l"
