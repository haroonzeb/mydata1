### Ansible Playbook

An Ansible playbook is a YAML file that contains a list of tasks to be executed on managed hosts. Each task is a module call that Ansible runs. Playbooks are designed to be human-readable and can be used to manage configurations, deploy applications, and orchestrate tasks on remote machines.

**Example of an Ansible Playbook:**

yaml

Copy code

`--- - name: Install and configure web server   hosts: webservers   become: yes    vars:     http_port: 80     max_clients: 200    tasks:     - name: Install Apache       apt:         name: apache2         state: present      - name: Write the Apache config file       template:         src: /path/to/httpd.j2         dest: /etc/httpd.conf      - name: Ensure Apache is running       service:         name: httpd         state: started`

### Handlers

Handlers are special tasks in Ansible that are triggered by other tasks. Handlers are run only once, after all tasks in a particular play have completed.

**Example of an Ansible Handler:**

yaml

Copy code

`tasks:   - name: Install Apache     apt:       name: apache2       state: present     notify:       - Restart Apache  handlers:   - name: Restart Apache     service:       name: apache2       state: restarted`

In this example, if the task "Install Apache" results in a change (e.g., installing the Apache package), the handler "Restart Apache" will be triggered.

### Variables

Variables in Ansible are used to store values that can be reused throughout a playbook. Variables can be defined in playbooks, inventory files, or in separate variable files.

**Example of Using Variables:**

yaml

Copy code

`--- - name: Configure web server   hosts: webservers   vars:     http_port: 8080     server_name: myserver    tasks:     - name: Create configuration file       template:         src: httpd.conf.j2         dest: /etc/httpd.conf       vars:         http_port: "{{ http_port }}"         server_name: "{{ server_name }}"`

### Dry Run

A dry run in Ansible (also called a "check mode") allows you to simulate the execution of a playbook without making any actual changes to the managed systems. This is useful for verifying what changes would be made without applying them.

**Running a Playbook in Dry Run Mode:**

sh

Copy code

`ansible-playbook playbook.yml --check`

### Loops

Loops in Ansible are used to execute a task multiple times with different items. This can be achieved using the `loop` keyword or other loop structures like `with_items`.

**Example of Using Loops:**

yaml

Copy code

`--- - name: Install multiple packages   hosts: webservers   tasks:     - name: Install packages       apt:         name: "{{ item }}"         state: present       loop:        
   - apache2         
   - mysql-server        
   - php`

In this example, the task "Install packages" will be executed three times, once for each item in the loop (apache2, mysql-server, and php).

### Summary

- **Ansible Playbook:** A YAML file with tasks for configuration, deployment, or orchestration.
- **Handlers:** Tasks triggered by other tasks, executed once after all tasks.
- **Variables:** Store and reuse values throughout a playbook.
- **Dry Run:** Simulate execution without making changes using `--check`.
- **Loops:** Execute tasks multiple times with different items using `loop` or similar constructs.