

 mysql user= earthuser1  
 password = coast123
ip: 64.23.136.113, 209.38.172.22 reserved ip
prosal db= earthcoast_proposaldb33
main db = earthcost_ecdb88to7
dns  = proposal.earthcoast.com
dns = earthcoast.com

server {
    # listen [::]:80 default_server; # Commented out as it's not needed for IPv4-only setups

    root /home/earthcoast/public_html;
    index index.php index.html index.htm;
    # index index.php

    server_name earthcoast.com;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }


 du -sh earthcoast

server {
  listen [::]:80 default_server;
    listen 80;
    root /home/earthcoast/public_html/proposal;
    index index.php index.html index.htm;

    server_name proposal.earthcoast.com;

    location / {
        try_files $uri $uri/ /index.php?$args;
 }
    location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $request_filename;
    include fastcgi_params;
}
}





server {
     # listen [::]:80 default_server; # Commented out as it's not needed for IPv4-only setups
    root /home/earthcoast/public_html;
    index index.php index.html index.htm;
    # index index.php

    server_name earthcoast.com;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
  
    


server {
     # listen [::]:80 default_server; # Commented out as it's not needed for IPv4-only setups
    root /home/earthcoast/public_html;
    index index.php index.html index.htm;
    # index index.php

    server_name earthcoast.com;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
  
    



    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/earthcoast.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/earthcoast.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = earthcoast.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;

    server_name earthcoast.com;
    return 404; # managed by Certbot


























![[Pasted image 20240109115843.png]]



![[Pasted image 20240109115940.png]]


