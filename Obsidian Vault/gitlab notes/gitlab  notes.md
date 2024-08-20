gitlab stages:
=> you can group multipe jobs in to stages  that run in a defined  order. 
=> multiple jobs in the  same stage are executed in parallel.
=>only if all jobs in the stage succeed  the pipline moves on to the next  stage.
=>if any in stage fails the next stage is not executed and the pipeline ends. 
=>


![[Pasted image 20240121154019.png]]

bash script uses in gitlab cicd .

![[Pasted image 20240122082619.png]]

gitlab stage for only specific branch to trigger the pipeline

![[Pasted image 20240122083029.png]]


![[Pasted image 20240122083401.png]]

select for specific branch like for  main branch and other branch fail the pipline

![[Pasted image 20240122083825.png]]


![[Pasted image 20240122085240.png]]


pipeline is trigger when merge request for main branch from other branch 

![[Pasted image 20240122094531.png]]


pre-define variables in gitlab

![[Pasted image 20240124092000.png]]



![[Pasted image 20240124094223.png]]


![[Pasted image 20240124103815.png]]



![[Pasted image 20240124104121.png]]



![[Pasted image 20240124130226.png]]


## GitLab CI Runners and Executors

GitLab CI employs a different architecture, compared to the default installation of more traditional CI servers, like Jenkins. In a nutshell, the GitLab server will always delegate the work of actually running a job to a GitLab Runner, which will sit somewhere on a different server.

Here are the most important concepts you need to understand:

- **GitLab Job**: the smallest component of a pipeline, which contains one or more commands that need to be executed.
- **GitLab Runner**: this is an agent installed on a different server from the GitLab server. The GitLab Runner receives instructions from the GitLab server in regards to which jobs to run. Each runner must be registered with the GitLab server.
- **Runner Executor**: each Runner will define at least one executor. An executor is essentially the environment where the job will be executed.

**With GitLab, you can use different executors**, depending on your needs:

- Shell
- SSH
- VirtualBox
- Parallels
- Docker
- Docker Machine
- Kubernetes

There is no such thing as “the best executor”. Every executor has its own typical uses case. It is best to be familiar with all of them, to understand which one works best for you.

# How do I know which runner I am currently using?

Many people are using GitLab CI but don't know exactly what happens behind the scenes. If you don’t know where your jobs are running and which types of executors you are using here is what you need to do.

Go to GitLab and open any project with a pipeline. Inspect the pipeline and click on any pipeline stage and select a job.

![](https://miro.medium.com/v2/resize:fit:700/1*1-wH9FPpVPSH6G6E4KJb6w.png)



specific runner and shared runner

![[Pasted image 20231225183453.png]]
![[Pasted image 20231225183857.png]]

Specific run to execute  a pipeline you must  tag it and the tag is mention in yaml file of pipeline

![[Pasted image 20231225184957.png]]

![[Pasted image 20231225185123.png]]

for high availability of  runner you specify same tags like in below  example is show . 

![[Pasted image 20240127204530.png]]

different jobs run on different runer for disturbed  the load and run properly runner like docker jobs is run on docker run

![[Pasted image 20240127204855.png]]


![[Pasted image 20231225185510.png]]

![[Pasted image 20231225232114.png]]

To set up a GitLab Runner with Docker executor on an Ubuntu VM, you can follow these general steps. Make sure you have Docker installed on the Ubuntu VM before proceeding.

### 1. Install Docker on Ubuntu

bashCopy code

`sudo apt update sudo apt install -y docker.io sudo systemctl start docker sudo systemctl enable docker` 
sudo usermod -aG docker $USER

### 2. Install GitLab Runner

#### Add the GitLab Runner repository:

bashCopy code

`sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash`

#### Install GitLab Runner:

bashCopy code

`sudo apt install gitlab-runner`

### 3. Register the Runner

After installing GitLab Runner, you need to register it with your GitLab instance. Replace `YOUR_CI_TOKEN` and `YOUR_GITLAB_URL` with your actual GitLab CI token and the URL of your GitLab instance.

bashCopy code

`sudo gitlab-runner register`
sudo systemctl restart gitlab-runner
sudo gitlab-runner verify




gitlab lock the runner for spacific r

![[Pasted image 20240127212252.png]]


![[Pasted image 20231225232459.png]]

![[Pasted image 20231225233104.png]]

gitlab instance and gitlab is minor version diffence 

![[Pasted image 20240128152945.png]]


### Download the GitLab package[](https://docs.gitlab.com/ee/topics/offline/quick_start_guide.html#download-the-gitlab-package "Permalink")

You should [manually download the GitLab package](https://docs.gitlab.com/ee/update/package/index.html#upgrade-using-a-manually-downloaded-package) and relevant dependencies using a server of the same operating system type that has access to the Internet.

If your offline environment has no local network access, you must manually transport the relevant package through physical media, such as a USB drive.

In Ubuntu, this can be performed on a server with Internet access using the following commands:

```
# Download the bash script to prepare the repository
curl --silent "https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh" | sudo bash

# Download the gitlab-ee package and dependencies to /var/cache/apt/archives
sudo apt-get install --download-only gitlab-ee

# Copy the contents of the apt download folder to a mounted media device
sudo cp /var/cache/apt/archives/*.deb /path/to/mount
```

### Install the GitLab package[](https://docs.gitlab.com/ee/topics/offline/quick_start_guide.html#install-the-gitlab-package "Permalink")

Prerequisites:

- Before installing the GitLab package on your offline environment, ensure that you have installed all required dependencies first.

If you are using Ubuntu, you can install the dependency `.deb` packages you copied across with `dpkg`. Do not install the GitLab package yet.

```
# Navigate to the physical media device
sudo cd /path/to/mount

# Install the dependency packages
sudo dpkg -i <package_name>.deb
```

[Use the relevant commands for your operating system to install the package](https://docs.gitlab.com/ee/update/package/index.html#upgrade-using-a-manually-downloaded-package) but make sure to specify an `http` URL for the `EXTERNAL_URL` installation step. Once installed, we can manually configure the SSL ourselves.

It is strongly recommended to setup a domain for IP resolution rather than bind to the server’s IP address. This better ensures a stable target for our certs’ CN and makes long-term resolution simpler.

The following example for Ubuntu specifies the `EXTERNAL_URL` using HTTP and installs the GitLab package:

```
sudo EXTERNAL_URL="http://my-host.internal" dpkg -i <gitlab_package_name>.deb
```

## Enabling SSL[](https://docs.gitlab.com/ee/topics/offline/quick_start_guide.html#enabling-ssl "Permalink")

Follow these steps to enable SSL for your fresh instance. These steps reflect those for [manually configuring SSL in Omnibus’s NGINX configuration](https://docs.gitlab.com/omnibus/settings/ssl/index.html#configure-https-manually):

1. Make the following changes to `/etc/gitlab/gitlab.rb`:
    
    ```
    # Update external_url from "http" to "https"
    external_url "https://my-host.internal"
    
    # Set Let's Encrypt to false
    letsencrypt['enable'] = false
    ```
    
2. Create the following directories with the appropriate permissions for generating self-signed certificates:
    
    ```
    sudo mkdir -p /etc/gitlab/ssl
    sudo chmod 755 /etc/gitlab/ssl
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/gitlab/ssl/my-host.internal.key -out /etc/gitlab/ssl/my-host.internal.crt
    ```
    
3. Reconfigure your instance to apply the changes:
    
    ```
    sudo gitlab-ctl reconfigure
    ```
    

## Enabling the GitLab container registry[](https://docs.gitlab.com/ee/topics/offline/quick_start_guide.html#enabling-the-gitlab-container-registry "Permalink")

Follow these steps to enable the container registry. These steps reflect those for [configuring the container registry under an existing domain](https://docs.gitlab.com/ee/administration/packages/container_registry.html#configure-container-registry-under-an-existing-gitlab-domain):

1. Make the following changes to `/etc/gitlab/gitlab.rb`:
    
    ```
    # Change external_registry_url to match external_url, but append the port 4567
    external_url "https://gitlab.example.com"
    registry_external_url "https://gitlab.example.com:4567"
    ```
    
2. Reconfigure your instance to apply the changes:
    
    ```
    sudo gitlab-ctl reconfigure
    ```
    

## Allow the Docker daemon to trust the registry and GitLab Runner[](https://docs.gitlab.com/ee/topics/offline/quick_start_guide.html#allow-the-docker-daemon-to-trust-the-registry-and-gitlab-runner "Permalink")

Provide your Docker daemon with your certs by [following the steps for using trusted certificates with your registry](https://docs.gitlab.com/ee/administration/packages/container_registry.html#using-self-signed-certificates-with-container-registry):

```
sudo mkdir -p /etc/docker/certs.d/my-host.internal:5000

sudo cp /etc/gitlab/ssl/my-host.internal.crt /etc/docker/certs.d/my-host.internal:5000/ca.crt
```

Provide your GitLab Runner (to be installed next) with your certs by [following the steps for using trusted certificates with your runner](https://docs.gitlab.com/runner/install/docker.html#installing-trusted-ssl-server-certificates):

```
sudo mkdir -p /etc/gitlab-runner/certs

sudo cp /etc/gitlab/ssl/my-host.internal.crt /etc/gitlab-runner/certs/ca.crt
```

## Enabling GitLab Runner[](https://docs.gitlab.com/ee/topics/offline/quick_start_guide.html#enabling-gitlab-runner "Permalink")

[Following a similar process to the steps for installing our GitLab Runner as a Docker service](https://docs.gitlab.com/runner/install/docker.html#install-the-docker-image-and-start-the-container), we must first register our runner:

```
$ sudo docker run --rm -it -v /etc/gitlab-runner:/etc/gitlab-runner gitlab/gitlab-runner register
Updating CA certificates...
Runtime platform                                    arch=amd64 os=linux pid=7 revision=1b659122 version=12.8.0
Running in system-mode.

Please enter the gitlab-ci coordinator URL (for example, https://gitlab.com/):
https://my-host.internal
Please enter the gitlab-ci token for this runner:
XXXXXXXXXXX
Please enter the gitlab-ci description for this runner:
[eb18856e13c0]:
Please enter the gitlab-ci tags for this runner (comma separated):

Registering runner... succeeded                     runner=FSMwkvLZ
Please enter the executor: custom, docker, virtualbox, kubernetes, docker+machine, docker-ssh+machine, docker-ssh, parallels, shell, ssh:
docker
Please enter the default Docker image (for example, ruby:2.6):
ruby:2.6
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

Now we must add some additional configuration to our runner:

Make the following changes to `/etc/gitlab-runner/config.toml`:

- Add Docker socket to volumes `volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]`
- Add `pull_policy = "if-not-present"` to the executor configuration

Now we can start our runner:

```
sudo docker run -d --restart always --name gitlab-runner -v /etc/gitlab-runner:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest
90646b6587127906a4ee3f2e51454c6e1f10f26fc7a0b03d9928d8d0d5897b64
```

### Authenticating the registry against the host OS[](https://docs.gitlab.com/ee/topics/offline/quick_start_guide.html#authenticating-the-registry-against-the-host-os "Permalink")

As noted in [Docker registry authentication documentation](https://docs.docker.com/registry/insecure/#docker-still-complains-about-the-certificate-when-using-authentication), certain versions of Docker require trusting the certificate chain at the OS level.

In the case of Ubuntu, this involves using `update-ca-certificates`:

```
sudo cp /etc/docker/certs.d/my-host.internal\:5000/ca.crt /usr/local/share/ca-certificates/my-host.internal.crt

sudo update-ca-certificates
```

If all goes well, this is what you should see:

```
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
```






![[Pasted image 20231225234908.png]]


![[Pasted image 20231225235045.png]]

![[Pasted image 20240120114806.png]]

![[Pasted image 20240120115724.png]]



![[Pasted image 20240120115412.png]]

![[Pasted image 20240120115958.png]]


![[Pasted image 20240120120131.png]]


![[Pasted image 20240120120301.png]]

![[Pasted image 20240120123421.png]]
 

![[Pasted image 20231226103656.png]]

![[Pasted image 20231226104258.png]]


![[Pasted image 20231226104628.png]]