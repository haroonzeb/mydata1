
##### APPLICATION  LOAD BALACER
The Application Load Balancer is a proxy-based Layer 7 load balancer that enables you to run and scale your services. The Application Load Balancer distributes HTTP and HTTPS traffic to backends hosted on a variety of Google Cloud platforms—such as Compute Engine, Google Kubernetes Engine (GKE), Cloud Storage, and Cloud Run—as well as external backends connected over the internet or by using hybrid connectivity
create load balancer
![[Pasted image 20240302153125.png]]
Start the configuration

In the Google Cloud console, go to the Load balancing page.

Go to Load balancing

{Click Create load balancer.
On the Application Load Balancer (HTTP/S) card, click Start configuration.
For Internet facing or internal only, select From Internet to my VMs.
For Global or regional, select Global external Application Load Balancer.
Click Continue.
For the name of the load balancer, enter serverless-lb.
Keep the window open to continue.}

create load balancer

![[Pasted image 20240302151527.png]]
 
 start configure https  load balaning
 ![[Pasted image 20240302151753.png]]

internet facing http LB  and other option are global or regional 

![[Pasted image 20240302152316.png]]

frontend configuration 
#### Frontend configuration

1. Click **Frontend configuration**.
2. For **Name**, enter a name.
3. To create an HTTPS load balancer, you must have an [SSL certificate](https://cloud.google.com/load-balancing/docs/ssl-certificates) (`gcloud compute ssl-certificates list`).
    
    We recommend using a Google-managed certificate as described [previously](https://cloud.google.com/load-balancing/docs/https/setup-global-ext-https-serverless#ssl_certificate_resource).
    

To configure an external Application Load Balancer, fill in the fields as follows.

Verify the following options are configured with these values:

| Property                                | Value (type a value or select an option as specified)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Protocol                                | HTTPS                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| Network Service Tier                    | Premium                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| IP version                              | IPv4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| IP address                              | example-ip                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| Port                                    | 443                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| Optional: HTTP keepalive timeout        | Enter a timeout value from 5 to 1200 seconds. The default value is 610 seconds.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| Certificate                             | Select an existing SSL certificate or create a new certificate.  <br>  <br>**To create an HTTPS load balancer**, you must have an [SSL certificate resource](https://cloud.google.com/load-balancing/docs/ssl-certificates) to use in the HTTPS proxy. You can create an SSL certificate resource using either a Google-managed SSL certificate or a self-managed SSL certificate.  <br>To create a Google-managed certificate, you must have a domain. The domain's A record must resolve to the IP address of the load balancer (in this example, example-ip). Using Google-managed certificates is recommended because Google Cloud obtains, manages, and renews these certificates automatically. If you do not have a domain, you can use a self-signed SSL certificate for testing. |
| Optional: Enable HTTP to HTTPS Redirect | Use this checkbox to enable HTTP to HTTPS redirects.<br><br>Enabling this checkbox creates an additional partial HTTP load balancer that uses the same IP address as your HTTPS load balancer and redirects HTTP requests to your load balancer's HTTPS frontend.<br><br>This checkbox can only be selected when the HTTPS protocol is selected and a reserved IP address is used.                                                                                                                                                                                                                                                                                                                                                                                                        |
|                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |

![[Pasted image 20240302152541.png]]



![[Pasted image 20240302154336.png]]

create certificate google managed certificate and domain name

![[Pasted image 20240302154742.png]]



![[Pasted image 20240302154902.png]]


