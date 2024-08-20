how to used ssl cerificate of thirdparty for nginx

![[Pasted image 20240209202530.png]]


server {
    listen 443 ssl;
    ssl_certificate /home/ubuntu/nginx_bundle_cert.crt;
    ssl_certificate_key /home/ubuntu/private.key;

    root /home/ubuntu/Pules;

    server_name xario.ai www.xario.ai;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
	add_header 'Access-Control-Allow-Origin' 'https://pulse.gpt4chain.io';
    }
    
    location /.well-known/pki-validation/ {
        alias /var/www/html/.well-known/pki-validation/;
        try_files $uri =404;
    }
}


### install nginx 
1. Update your server
sudo apt-get update
​
​2. Then add following lines to nginx.list file by
sudo nano /etc/apt/sources.list.d/nginx.list

Add following files: 
deb https://nginx.org/packages/ubuntu/ focal nginx
deb-src https://nginx.org/packages/ubuntu/ focal nginx

3. Again Update your system
sudo apt update

4. Then we will add a key to the server and we will update it and then we will install nginx
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62

5. Then we will install nginx
sudo apt update
sudo apt-get install nginx


To create a new user in MariaDB with remote access, you can follow these steps:

1. **Connect to MariaDB:** Open a terminal and connect to your MariaDB server using the `mysql` command-line client:
    
    
    `mysql -u root -p`
    
    Enter the root password when prompted.
    
2. **Create a New User:** Replace `'new_remote_user'`, `'new_password'`, and `'%'` with your desired username, password, and the appropriate host (in this case, `%` means any host, allowing remote access from any IP address):
    
    sqlCopy code
    
    `CREATE USER 'new_remote_user'@'%' IDENTIFIED BY 'new_password';`
    
3. **Grant Privileges:** Grant the necessary privileges to the new user. Adjust the privileges according to your requirements:
    
    sqlCopy code
    
    `GRANT ALL PRIVILEGES ON *.* TO 'new_remote_user'@'%' WITH GRANT OPTION;`
    
    The `WITH GRANT OPTION` allows the user to grant privileges to other users.
    
4. **Flush Privileges:** After creating the user and granting privileges, flush the privileges to apply the changes:
    
    sqlCopy code
    
    `FLUSH PRIVILEGES;`
    
5. **Update Firewall Rules (if applicable):** If you have a firewall enabled on your server, ensure that it allows incoming traffic on the MariaDB port (default is 3306).


### Create Nginx Configuration Files:

#### For Site 1 (`/etc/nginx/sites-available/site1`):

nginxCopy code

server {
    listen 80 default_server;
    server_name _;

    # Your configuration goes here
    # For example:
    root /var/www/default;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}


#### For Site 2 (`/etc/nginx/sites-available/site2`):

nginxCopy code

server {
    listen 80 default_server;
    server_name _;

    # Your configuration goes here
    # For example:
    root /var/www/default;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}

### 2. Create Symbolic Links:

Create symbolic links to these configuration files in the `sites-enabled` directory:

bashCopy code

`sudo ln -s /etc/nginx/sites-available/site1 /etc/nginx/sites-enabled/ sudo ln -s /etc/nginx/sites-available/site2 /etc/nginx/sites-enabled/`

### 3. Verify Configuration Syntax:

Before restarting Nginx, it's a good idea to check the configuration syntax:


`sudo nginx -t`

If there are no errors, you should see `syntax is okay` and `test is successful`.

### 4. Restart Nginx:

Restart Nginx to apply the new configurations:


`sudo systemctl restart nginx`

To remove the symbolic link you created, you can use the `unlink` command. Assuming you want to remove the symbolic link for `site2`, you can do the following:


`sudo unlink /etc/nginx/sites-enabled/site2`


1. **Assign ownership to the web server user:**
    
    - For Nginx, the user is often `www-data`.
    - For Apache, the user is typically `www-data` as well.
    
    
    
    `sudo chown -R www-data:www-data /var/www/html`
    
2. **Set directory permissions to 755 (rwxr-xr-x):**
    
    
    
    `sudo chmod 755 /var/www/html`
    
3. **Set file permissions to 644 (rw-r--r--):**
    
    
    
    `sudo chmod 644 /var/www/html/*`

OTHEER  COMPEMENTS

scp -r /home/haroon/earthcoast/public_html/ root@64.23.136.113:/var/www/html/

This command tells `scp` to recursively copy the contents of the `public_html` directory to the specified destination on the remote machine.

Certainly! If you want to extract the contents of the `backup-earthcoast.com-1-26-2024.tar.gz` file to a specific folder, you can use the `-C` option with the `tar` command. Here's an example:


`tar -xvzf backup-earthcoast.com-1-26-2024.tar.gz -C /path/to/your/folder`

Replace `/path/to/your/folder` with the actual path to the folder where you want to extract the contents. This command will extract the files to the specified directory.

Make sure the directory exists before running the command, or you can create it using the `mkdir` command:

bashCopy code

`mkdir /path/to/your/folder tar -xvzf backup-earthcoast.com-1-26-2024.tar.gz -C /path/to/your/folder`

This will create the specified folder if it doesn't exist and then extract the contents into that folder.