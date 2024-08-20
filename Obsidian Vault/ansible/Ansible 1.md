## What Is Ansible Architecture?

The Ansible comes as Agentless architecture with a push-based mechanism. It means there is no need for pre-installation of software on worker nodes to connect to the manager node.

The system one which Ansible is installed is treated as the Manager Node and the Other systems that are managed by Manager Node For establishing the connection to worker nodes, Ansible Manager uses some kind of protocol, for [Linux](https://www.geeksforgeeks.org/introduction-to-linux-operating-system/) systems ssh protocol and for Windows systems WinRM protocol is mostly used in behind.

![Ansible Architecture](https://media.geeksforgeeks.org/wp-content/uploads/20240417114541/Ansible-cheat-sheet.gif)

The information of worker nodes such as username, password, [IP address,](https://www.geeksforgeeks.org/what-is-an-ip-address/) and protocol are specified in a file in Ansible manager known as Inventory.

## Ansible Keywords

Ansible keywords are the fundamental elements that are used for structuring and defining the automation of tasks in the [Playbooks](https://www.geeksforgeeks.org/what-is-an-ansible-playbook/) with YAML syntax. These are the elements that helps in organizing the tasks and helps in orchestrating the automation process effectively.

|Ansible Keywords|Description|
|---|---|
|play|It termed for defining the set of tasks that to be executed On remote hosts.|
|task|An Action performed by ansible on remote hosts.|
|role|it is an organized structure directory with files containing a predefined set of tasks, handlers, variables and files|
|Module|These are Reusable, Standalone ansible scripts sued to perform tasks on Worker nodes.|
|vars|It is used for defining the variables that can be used through out the playbook for dynamic configurations.|
|register|This keyword helps in capturing the ouptut of the tasks and stores in a variable for later use in playbook.|
|notify|This keyword used to trigger the handlers when specific conditions are matched such as service state changes.|

## Ansible Modules

In ansible modules are the reusable scripts that helps in carrying out specific tasks on remote systems such as managing the packages, files, services or executing commands. It helps in automating the infrastructure management efficiently, consistently at scale.

|Ansible Modules|Usage|
|---|---|
|apt|This module manages the packages on Debian and Ubuntu Systems.|
|yum|This module manages the packages on Red Hat/ Cent [OS](https://www.geeksforgeeks.org/what-is-an-operating-system/) systems|
|copy|This module helps in copying the files from local or Remote system to Destination system.|
|file|This module manages the files and directories in local or Remote system.|
|service|This module manages the services in the ansible|
|shell|This module helps in executing shell commands on remote hosts.|
|template|This module help in using the Jinja2 templates allowing dynamic content usage.|
|cron|This module helps in managing the cron jobs, including the creation, modification and removal.|
|git|This module helps in managing the repositories allowing tasks such as cloning, pulling and pushing.|

## Ansible Installation Commands

Installation of Ansible with commands varies slightly with respective operating systems. Every operating system comes with different package manager, so installation commands also keeps on varying. The following helps in finding installation command with respective operating system.

|Operating System|Commands|
|---|---|
|Ubuntu/Debian|sudo apt-get install ansible|
|Red Hat/CentOS|sudo yum install ansible|
|Using Pip software|sudo pip install ansible|

## Ansible Playbook

- An Ansible playbook is a YAML file that contains a series of tasks that to be executed on remote hosts.
- Defining a task in playbook known as play and A playbook can have more than one play.
- The Execution of playbook provides the output in color-coded signifying the information such as
![[Pasted image 20240708195150.png]]

|Color|Description|
|---|---|
|Green|Successfully Run and Configured|
|Cyan/Blue|No Changess|
|Yellow/Orange|Skipped|
|Red|Error Raised|

## Ansible Playbook Command – Options

ansible-playbook -i inventory_path -u remote_user -k -f 3 -T 20 -t my_tag -M module_path myplaybook.yaml

- Here the options are detailed as follows:

|Options|Description|
|---|---|
|-i|It used for specifying inventory path where the worker nodes information specified ****inventory**** file exists.|
|-u|Used for specifying the user to connect over SSH (remotely) and run play.|
|-k|It used for asking password which used for while SSH Authentication|
|-f|It used for allocating forks that helps in number of tasks to execute parallel on remote hosts.|
|-T|It used for setting time-out for remote connection establishment. It prevents in hanging the manager Node in Unreachable connections.|
|-t|It is used to specify the tags, which helps to run the tasks that only contains this tags|
|-M|It is used for defining module path that helps in loading local module.|
|-b|It helps with running the play with elevated privileges ( uses become )|
|-K|It used for prompting the enter password that required for escalation privilege (such as sudo password )|

## Ansible Adhoc Commands

Ansible Adhoc commands are the manual way of running the ansible commands for local or remote hosts configuration.

| Functions                                     | Commands                                                                   |
| --------------------------------------------- | -------------------------------------------------------------------------- |
| Checking Connectivity To Hosts (Worker Nodes) | ansible <group> -m ping                                                    |
| Executing The Command On Hosts                | ansible <group> -a “<command>”                                             |
| Executing Shell Commands On Hosts             | ansible <group> -m shell -a “<command>”                                    |
| Gathering Facts From All Hosts                | ansible all -m setup                                                       |
| Copying A File To All Hosts                   | ansible all -m copy -a “src=file.txt dest=dest.txt”                        |
| Restarting A Service On All Hosts             | ansible all -m service -a “name=<service_name> state=restarted”            |
| demo= group                                   | ansible  demo -a "touch file1"<br>ansible  demo -a "sudo install nginx -y" |
ansible  demo -a "touch file1"
ansible  demo -a "sudo install nginx -y"

## Ansible Playbook Commands

Ansible playbook commands are the one that used while running the playbook. On using options we can enhance extra functionality while executing the play run. The following tables illustrates some of functionality and its commands.

|Functions|Commands|
|---|---|
|Execute The Playbook|ansible-playbook playbook.yml|
|Check The Playbook Syntax|ansible-playbook playbook.yml –syntax-check|
|Check The Mode of Playbook ( Dry Run )|ansible-playbook playbook.yml –check|
|Execute The Playbook Start At Task|ansible-playbook playbook.yml –start-at-task <task_name>|
|Limit Playbook Execution To Specific Hosts|ansible-playbook playbook.yml -l <host/group>|
|Skip Tasks With Specified Tags|ansible-playbook playbook.yml –skip-tags <tag>|

## Ansible Vault Commands

The [ansible vault](https://www.geeksforgeeks.org/what-is-ansible-vault/) commands are used for storing the senstive data instead of exposing them in playbooks directly.

|Functions|Ansible Vault Commands|
|---|---|
|Encrypt Vault File|ansible-vault encrypt file.yml|
|Edit An Encrypted File|ansible-vault edit file.yml|
|Decrypt Vault File|ansible-vault decrypt file.yml|
|View Vault File|ansible-vault view file.yml|
|Encrypt A String|ansible-vault encrypt_string ‘your_secret_string’|
|Rekey An Encrypted File|ansible-vault rekey file.yml|

## Ansible Role Commands

[Ansible Roles](https://www.geeksforgeeks.org/a-brief-introduction-to-ansible-roles-for-linux-system-administration/) are an effective way of organizing and reusing the Ansible content. The following are the some effective ansible Role Commands explaining its functionality.

|Functions|Ansible Role Commands|
|---|---|
|Initialize The Role|ansible-galaxy init role_name|
|Install The Role|ansible-galaxy install author.role_name|

## Ansible Inventory Commands

[Ansible inventory](https://www.geeksforgeeks.org/ansible-configuration-and-inventory-files/) commands helps in providing the essential functionalities for managing and interacting with inventory.

|Functions|Ansible Inventory Commands|
|---|---|
|Listing Hosts|ansible-inventory –list|
|Graphical View|ansible-inventory –graph|
|Filter The Hosts By Pattern|ansible all -i inventory.ini –pattern ‘web*’|
|Updating Dynamic Inventory|ansible-inventory –refresh|

## Ansible Connectivity Checking Commands

Ansible Connectivity Commands helps in checking the connectivity with hosts systems and accessibility of hosts in your inventory.

|Functions|Ansible Connectivity Commands|
|---|---|
|Ping The Hosts|ansible all -m ping|
|Check SSH Connectivity|ansible all -m ping -c paramiko|
|Verify The Connectivity To Specific Host|ansible <hostname> -m ping|

## Ansible Galaxy Commands

Ansible Galaxy is a community hub for sharing Ansible roles, collections and other content. It act as a centralized repository where users are able to discover, download and contribute to Ansible content making easier of infrastructure automation.

|Functions|Ansible Galaxy Commands|
|---|---|
|Search Role|ansible-galaxy search role_name|
|Install a Role|ansible-galaxy install author.role_name|
|Listing Install Roles|ansible-galaxy list|
|Creating A Requirements File For Roles|ansible-galaxy install -r requirements.yml|

## Ansible Document Commands

Ansible Document Commands helps in knowing more information about particular modules and playbook such as its providing functionalities, syntax and options.

|Functions|Commands|
|---|---|
|To See The Documentation Of The Module|ansible-doc module_name|
|To See Information On Playbooks|ansible-doc playbook|

## Ansible Playbook Commands For Assign Variables

Ansible playbook commands for assigning variables enables the users to provide dynamic values to tasks and playbooks.

|Functions|Commands|
|---|---|
|Defining Variables In Playbook|vars:<br><br>var_name: value|
|For Adding Variables To Playbooks|ansible-playbook playbook.yml –extra-vars “var_name=value”|
|For Providing File Containing Variables|ansible-playbook playbook.yml -e @vars.yml|

## Ansible Navigator Commands

Ansible Navigator provides a set of commands that support the navigation and exploration with ansible resources.

|Functions|Commands|
|---|---|
|List Available Actions|ansible-navigator actions|
|Search Modules|ansible-navigator search-modules <keyword>|
|Execute Playbooks|ansible-navigator run playbook.yml|
|Viewing Inventory|ansible-navigator inventory|
|Interacting With Ansible Collections|ansible-navigator collection|

## Ansible Troubleshooting Commands

Ansible Troubleshooting commands in helps in better understanding of the issue and resolving them efficiently.

|Functions|Commands|
|---|---|
|To Increase The Verbosity Of Playbook Execution|ansible-playbook playbook.yml -v|
|To Check Syntax Of Playbook|ansible-playbook playbook.yml –syntax-check|
|Gathering Facts From Hosts|ansible all -m setup|