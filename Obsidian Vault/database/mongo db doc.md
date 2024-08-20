official url to install from from here
https://www.mongodb.com/docs/v3.0/tutorial/install-mongodb-on-ubuntu/
MongoDB provides officially supported packages in their own repository. This repository contains the following packages:

- `mongodb-org`
    
    This package is a `metapackage` that will automatically install the four component packages listed below.
    
- `mongodb-org-server`
    
    This package contains the [`mongod`](https://www.mongodb.com/docs/v3.0/reference/program/mongod/#bin.mongod "bin.mongod") daemon and associated configuration and init scripts.
    
- `mongodb-org-mongos`
    
    This package contains the [`mongos`](https://www.mongodb.com/docs/v3.0/reference/program/mongos/#bin.mongos "bin.mongos") daemon.
    
- `mongodb-org-shell`
    
    This package contains the [`mongo`](https://www.mongodb.com/docs/v3.0/reference/program/mongo/#bin.mongo "bin.mongo") shell.
    
- `mongodb-org-tools`
    
    This package contains the following MongoDB tools: [`mongoimport`](https://www.mongodb.com/docs/v3.0/reference/program/mongoimport/#bin.mongoimport "bin.mongoimport") [`bsondump`](https://www.mongodb.com/docs/v3.0/reference/program/bsondump/#bin.bsondump "bin.bsondump"), [`mongodump`](https://www.mongodb.com/docs/v3.0/reference/program/mongodump/#bin.mongodump "bin.mongodump"), [`mongoexport`](https://www.mongodb.com/docs/v3.0/reference/program/mongoexport/#bin.mongoexport "bin.mongoexport"), [`mongofiles`](https://www.mongodb.com/docs/v3.0/reference/program/mongofiles/#bin.mongofiles "bin.mongofiles"), [`mongooplog`](https://www.mongodb.com/docs/v3.0/reference/program/mongooplog/#bin.mongooplog "bin.mongooplog"), [`mongoperf`](https://www.mongodb.com/docs/v3.0/reference/program/mongoperf/#bin.mongoperf "bin.mongoperf"), [`mongorestore`](https://www.mongodb.com/docs/v3.0/reference/program/mongorestore/#bin.mongorestore "bin.mongorestore"), [`mongostat`](https://www.mongodb.com/docs/v3.0/reference/program/mongostat/#bin.mongostat "bin.mongostat"), and [`mongotop`](https://www.mongodb.com/docs/v3.0/reference/program/mongotop/#bin.mongotop "bin.mongotop").
    
	the default `/etc/mongod.conf` configuration file
## Run MongoDB

The MongoDB instance stores its data files in `/var/lib/mongodb` and its log files in `/var/log/mongodb` by default, and runs using the `mongodb` user account. You can specify alternate log and data file directories in `/etc/mongod.conf`. See [`systemLog.path`](https://www.mongodb.com/docs/v3.0/reference/configuration-options/#systemLog.path "systemLog.path") and [`storage.dbPath`](https://www.mongodb.com/docs/v3.0/reference/configuration-options/#storage.dbPath "storage.dbPath") for additional information.

If you change the user that runs the MongoDB process, you **must** modify the access control rights to the `/var/lib/mongodb` and `/var/log/mongodb` directories to give this user access to these directories.

sudo systemctl start mongod
sudo systemctl stop mongod
sudo systemctl restart mongod

#### Begin using MongoDB.[![](https://www.mongodb.com/docs/manual/assets/link.svg)](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/#begin-using-mongodb "Permalink to this heading")

Start a [`mongosh`](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh) session on the same host machine as the [`mongod`](https://www.mongodb.com/docs/manual/reference/program/mongod/#mongodb-binary-bin.mongod). You can run [`mongosh`](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh) without any command-line options to connect to a [`mongod`](https://www.mongodb.com/docs/manual/reference/program/mongod/#mongodb-binary-bin.mongod) that is running on your localhost with default port 27017.
mongosh

for uninstall the momgodb
sudo service mongod stop
sudo apt-get purge "mongodb-org*"
sudo rm -r /var/log/mongodb
sudo rm -r /var/lib/mongodb

##### MongoDB Compass (GUI)

Easily explore and manipulate your database with Compass, the GUI for MongoDB. Intuitive and flexible, Compass provides detailed schema visualizations, real-time performance metrics, sophisticated querying abilities, and much more.


use admin
db.createUser(
  {
    user: "haroon",
    pwd: passwordPrompt(), // or cleartext password
    roles: [
      { role: "userAdminAnyDatabase", db: "admin" },
      { role: "readWriteAnyDatabase", db: "admin" }
    ]
  }
)



Connect MongoDB: 
mongosh 

List of Databases: show dbs 
Connect to Admin Database use admin - Create User Method: 
use admin

db.createUser(
  {
    user: "haroon",
    pwd: passwordPrompt(), // or cleartext password
    roles: [
      { role: "userAdminAnyDatabase", db: "admin" },
      { role: "readWriteAnyDatabase", db: "admin" }
    ]
  }
)
 
Get List of Users db.getUsers() 
Delete User: db.dropUser(“test”) 
Configuration File:       sudo nano /etc/mongod.conf 
security: 
   authorization: enabled  
Connect MongoDB with options: mongosh -u admin -p --authenticationDatabase admin 

Manage MongoDB: 

sudo systemctl start mongod
sudo systemctl status mongod
sudo systemctl enable mongod 
sudo systemctl restart mongod