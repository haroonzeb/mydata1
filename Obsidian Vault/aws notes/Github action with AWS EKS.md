# CI/CD with Github action and AWS EKS

In the world of software engineering, CI stands for Continuous Integration, and CD stands for Continuous Delivery or Deployment. In today’s fast-paced software development landscape, it’s crucial to streamline our software deployment process. To do this, we need automation at every stage, from building and testing to deploying the application. This is where CI/CD comes in handy, automating repetitive tasks and allowing us to save time on deployments and testing, enabling us to focus on core development.

In this blog, we’ll guide you through creating a GitHub action that accomplishes several key tasks: building a Docker image, pushing it to the Amazon Elastic Container Registry (ECR), and ultimately deploying it to an Amazon Elastic Kubernetes Service (EKS) cluster. We’ll break down each step in this tutorial. It’s worth noting that our primary focus in this blog will be on CI/CD processes, so we won’t dive too deeply into the code or Docker aspects.

**Prerequisites**

1. AWS account and cli
2. Docker
3. Eksctl
4. GitHub Account

Let’s begin by setting up all the necessary resources:

1. Create an ECR repository.

- Go to the AWS console and search for “Elastic Container Registry”.
- Enter your desired repository name and click “Create Repository”.

![](https://miro.medium.com/v2/resize:fit:700/1*Kp9law8GJ6hpDkICrTfxcA.png)

2. Create an IAM user

- In the AWS console, search for “IAM Users.”
- Click “Create User.”
- Provide a username and click “Next.”

![](https://miro.medium.com/v2/resize:fit:700/1*EHZl62mVfvaLCbagxvNh2A.png)

- For this demo, we’ll attach the administrator access policy (Note: This is not recommended for production use; policies should be customized to specific needs).

![](https://miro.medium.com/v2/resize:fit:700/1*TndPTFVTaMcL-PLY96CTZg.png)

- Review and create a user.

3. Generate the access and secret key of the user that we created.

- Open the user that we created and click “create access key”.

![](https://miro.medium.com/v2/resize:fit:700/1*NvIRh_nN3Zq8VTDhG5rA6w.png)

- Select “CLI” as the Use case and click next.
- Click “Create access key”.
- Download the CSV file containing the access key and secret key for future reference. These keys will be needed when working with GitHub.

4. Setting Up the EKS cluster.

- Make sure you have the AWS CLI installed on your device. If not, you can install it by visiting [this page](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- Configure your AWS CLI by following the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-methods).
- Next, you’ll need to install Eksctl to create the EKS cluster. You can find the installation steps [here](https://eksctl.io/introduction/#installation).
- Once everything is set up, you can create your EKS cluster using the following command:

eksctl create cluster - name cluster-name \   
 - region region-name \  
 - node-type instance-type \  
 - nodes-min 2 \  
 - nodes-max 2

- For example

eksctl create cluster - name Kubernetes-demo \  
 - region us-east-1 \  
 - node-type t3.micro

Creating the cluster will take approximately 10–15 minutes.

With these prerequisites in place, we’re ready to proceed with setting up our CI/CD code.

**Code**

You can review the code repository we’ll use for this tutorial at this link: [GitHub Repository](https://github.com/dlmade/flask-kubernetes-deploy).

Now, let’s dig into setting up GitHub Actions for our CI/CD pipeline. These actions will handle tasks such as creating a Docker image, pushing it to Amazon Elastic Container Registry (ECR), and finally deploying it to Amazon Elastic Kubernetes Service (EKS) using the manifests we’ve prepared.

To get started with GitHub Actions, we’ve organized our project’s structure as follows:

**GitHub actions yaml**

- We’ve created a folder named `.github/workflows` within our project directory.
- Inside this folder, you’ll find the `deploy.yaml` file, which contains the configuration for our GitHub Actions.
- This `deploy.yaml` file is where we define how our CI/CD pipeline will function. It orchestrates the entire process, from building the Docker image to deploying the application on EKS.

name: Deploy to ECR  
  
on:  
   
  push:  
    branches: [ master ]  
  
env:  
  ECR_REPOSITORY: flask-app  
  EKS_CLUSTER_NAME: Kubernetes-demo   
  AWS_REGION: us-east-1  
  
jobs:  
    
  build:  
      
    name: Deployment  
    runs-on: ubuntu-latest  
  
    steps:  
  
    - name: Set short git commit SHA  
      id: commit  
      uses: prompt/actions-commit-hash@v2  
  
    - name: Check out code  
      uses: actions/checkout@v2  
      
    - name: Configure AWS credentials  
      uses: aws-actions/configure-aws-credentials@v1  
      with:  
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}  
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}  
        aws-region: ${{env.AWS_REGION}}  
  
    - name: Login to Amazon ECR  
      id: login-ecr  
      uses: aws-actions/amazon-ecr-login@v1  
  
    - name: Build, tag, and push image to Amazon ECR  
      env:  
        ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}          
        IMAGE_TAG: ${{ steps.commit.outputs.short }}  
      run: |  
        docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG -f docker/Dockerfile .  
        docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG  
  
    - name: Update kube config  
      run: aws eks update-kubeconfig --name $EKS_CLUSTER_NAME --region $AWS_REGION  
  
    - name: Deploy to EKS  
      env:  
        ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}          
        IMAGE_TAG: ${{ steps.commit.outputs.short }}  
      run: |  
        sed -i.bak "s|DOCKER_IMAGE|$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG|g" manifests/hello-app-deployment.yaml && \  
        kubectl apply -f manifests/hello-app-deployment.yaml  
        kubectl apply -f manifests/hello-app-service.yaml

Let’s dive into the details of the GitHub Actions YAML file provided:

- **Trigger**: This GitHub Action is triggered when someone pushes to the “master” branch (lines 3–6).
- **Environment Variables**: Defines environment variables like the ECR repository name, EKS cluster name, and AWS region (lines 8–11).
- **Jobs**: The “build” job is specified, which runs on the latest Ubuntu environment (lines 13 onwards).
- **Steps**: The steps within the job are as follows:
- **Set short git commit SHA:** This step retrieves the commit hash, which is used to tag the Docker image (lines 23–24).
- **Check out code**: The action checks out the code from the "master" branch into the CI/CD Ubuntu environment (lines 26-27).
- **Configure AWS credentials**: Configure AWS credentials using secrets from GitHub (lines 29–34). This step will fetch secrets from Git Hub. We will see how to set secrets when we will create a GitHub repo.
- **Login to Amazon ECR**: Log in to the Amazon Elastic Container Registry to push the Docker image (lines 36–38).
- **Build, tag, and push the image to Amazon ECR**: This step builds the Docker image, tags it, and pushes it to ECR (lines 40–46).
- **Update kube config**: Fetches the Kubernetes configuration to interact with the EKS cluster (lines 48–49).
- **Deploy to EKS**: This part of the script applies Kubernetes manifests to deploy the application in EKS. It replaces a placeholder (`DOCKER_IMAGE`) in the manifest with the actual image location (lines 51-58).

**Github**

Here are the steps to set up your GitHub repository, configure AWS secrets, and deploy your application:

1. **GitHub Repository Setup**:

Begin by creating a new GitHub repository on [github.com](https://github.com/).

![](https://miro.medium.com/v2/resize:fit:700/1*aMgMux-D2zjv0Z9JPLOQmw.png)

2. **Configuring AWS Secrets**:

- To enable your CI/CD pipeline to access AWS resources (ECR registry and EKS cluster), you need to add your AWS secrets. These secrets are `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
- Navigate to your GitHub repository’s settings.
- Find the “Secrets and Variables” section, Inside it, click on actions.

![](https://miro.medium.com/v2/resize:fit:700/1*Un1K2i7zZ3x1wAsrxGw3HA.png)

2.1. **Adding New Repository Secrets**:

- Click on “New Repository Secret.”
- Provide the following secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

![](https://miro.medium.com/v2/resize:fit:700/1*uNQZ9EajFN2rHvn_QTpVVw.png)

Once you’ve added the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` secrets, your repository settings should look something like this.

![](https://miro.medium.com/v2/resize:fit:700/1*mgsEVs_8LnTaAsmKY_Mm7g.png)

3. **Pushing Your Code:**

Now, we can push your code to the GitHub repository. As soon as we push our code, GitHub Actions will automatically detect it and start running your defined actions.

4. **Monitor GitHub Actions:**

You can monitor the progress of your CI/CD pipeline by visiting the “GitHub Actions” tab in your repository. Here, you’ll see the status of each step in your workflow.

![](https://miro.medium.com/v2/resize:fit:700/1*ycGBwIvzAh5mwWErHPiEag.png)

5. **Accessing Your Application:**

- After your CI/CD pipeline is successfully completed, you can go to the AWS console.
- Search for the load balancer associated with your application to find the URL or DNS name.

![](https://miro.medium.com/v2/resize:fit:700/1*7uAIH2rDKmStZOo6k37tFw.png)

- To access your app, add port 8080 to the URL (e.g., `http://your-app-url:8080`) and you'll be able to use your deployed application.

These steps will help you set up your GitHub repository, securely configure AWS secrets, and deploy your application using GitHub Actions.

**Cleaning Up All resources**

When you need to clean up all resources within your Kubernetes environment, you can use the following kubectl commands to safely remove deployments, pods, and services.

1. **Delete All Deployments**.

- To delete all deployments, you can use the following command.

kubectl delete deployments - all

This command ensures that no active deployment instances in the default namespace are left in your cluster.

2. **Delete All Pods**.

- To delete all pods, which can be either manually created or created by deployments, and hold your app containers, you can use this command:

kubectl delete pods — all

This command ensures that no active pod instances in the default namespace are left in our cluster.

3. **Delete All Services**.

- To delete services that expose our applications to the network, you can use this command.

kubectl delete services — all

4. **Deleting an Amazon EKS Cluster**

- To remove all the resources associated with the Amazon EKS cluster created through `eksctl`, including instances, networking, and other resources, you can use the following command.

eksctl delete cluster — name {your cluster name} — region {your region name}

For example

eksctl delete cluster — name Kubernetes-demo — region us-east-1

These commands will help you safely clean up and remove resources from your Kubernetes environment and Amazon EKS cluster when you’re finished using them.

Thank you for following along with this guide. We hope it has been helpful in your journey toward a well-organized and efficient CI/CD environment. If you have any questions or need further assistance, please don’t hesitate to reach out.

