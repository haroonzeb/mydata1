`gcloud` is the command-line tool for Google Cloud. It comes pre-installed on Cloud Shell and supports tab-completion.

2. (Optional) You can list the active account name with this command:

      gcloud auth list

3. Click **Authorize**.

**Output:**

ACTIVE: *
ACCOUNT: student-01-bf9af7b60bad@qwiklabs.net

To set the active account, run:
    $ gcloud config set account `ACCOUNT`

4. (Optional) You can list the project ID with this command:

   gcloud config list project

## Task 1. Set the default region and zone for all resources

1. Set the default region:
    
    gcloud config set compute/region us-east1
    
    
2. In Cloud Shell, set the default zone:
    
    gcloud config set compute/zone us-east1-c

## Task 2. Create multiple web server instances

For this load balancing scenario, create three Compute Engine VM instances and install Apache on them, then add a firewall rule that allows HTTP traffic to reach the instances.

The code provided sets the zone to `us-east1-c`. Setting the tags field lets you reference these instances all at once, such as with a firewall rule. These commands also install Apache on each instance and give each instance a unique home page.

1. Create a virtual machine www1 in your default zone using the following code:
    
      gcloud compute instances create www1 \
        --zone=us-east1-c \
        --tags=network-lb-tag \
        --machine-type=e2-small \
        --image-family=debian-11 \
        --image-project=debian-cloud \
        --metadata=startup-script='#!/bin/bash
          apt-get update
          apt-get install apache2 -y
         service apache2 restart
          echo "webserver1" | tee /var/www/html/index.html'
    
    
2. Create a virtual machine www2 in your default zone using the following code:
    
      gcloud compute instances create www2 \
        --zone=us-east1-c \
        --tags=network-lb-tag \
        --machine-type=e2-small \
        --image-family=debian-11 \
        --image-project=debian-cloud \
        --metadata=startup-script='#!/bin/bash
          apt-get update
          apt-get install apache2 -y
         service apache2 restart
          echo "webserver2 " | tee /var/www/html/index.html'
    
    
3. Create a virtual machine www3 in your default zone.
    
      gcloud compute instances create www3 \
        --zone=us-east1-c  \
        --tags=network-lb-tag \
        --machine-type=e2-small \
        --image-family=debian-11 \
        --image-project=debian-cloud \
        --metadata=startup-script='#!/bin/bash
          apt-get update
          apt-get install apache2 -y
         service apache2 restart
          echo "webserver3" | tee /var/www/html/index.html'
    
    
4. Create a firewall rule to allow external traffic to the VM instances:
    
    gcloud compute firewall-rules create www-firewall-network-lb \
        --target-tags network-lb-tag --allow tcp:80

Now you need to get the external IP addresses of your instances and verify that they are running.

5. Run the following to list your instances. You'll see their IP addresses in the `EXTERNAL_IP` column:
    
    gcloud compute instances list
    
6. Verify that each instance is running with `curl`, replacing **[IP_ADDRESS]** with the IP address for each of your VMs:
    
    curl http://[IP_ADDRESS]


## Task 3. Configure the load balancing service

When you configure the load balancing service, your virtual machine instances receives packets that are destined for the static external IP address you configure. Instances made with a Compute Engine image are automatically configured to handle this IP address.

**Note:** Learn more about how to set up network load balancing from the [External TCP/UDP Network Load Balancing overview Guide](https://cloud.google.com/compute/docs/load-balancing/network/).

1. Create a static external IP address for your load balancer:
    
    gcloud compute addresses create network-lb-ip-1 \
      --region us-east1
    
    Copied!
    
    content_copy
    
    Output:
    
       Created [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-03-xxxxxxxxxxx/regions/us-east1/addresses/network-lb-ip-1].
    
2. Add a legacy HTTP health check resource:
    
    gcloud compute http-health-checks create basic-check
    
    Copied!
    
    content_copy
    
3. Add a target pool in the same region as your instances. Run the following to create the target pool and use the health check, which is required for the service to function:
    
    gcloud compute target-pools create www-pool \
      --region us-east1 --http-health-check basic-check

    
4. Add the instances to the pool:
    
    gcloud compute target-pools add-instances www-pool \
        --instances www1,www2,www3
    
5. Add a forwarding rule:
    
    gcloud compute forwarding-rules create www-rule \
        --region  us-east1 \
        --ports 80 \
        --address network-lb-ip-1 \
        --target-pool www-pool
    

    Click **Check my progress** below to verify that you've created an L4 network load balancer that points to the web servers.