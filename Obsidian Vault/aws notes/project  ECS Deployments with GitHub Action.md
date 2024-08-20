

**DavisIndex:Host**: AWS ECS ECR for Backend, for Frontend AWS S3 + CF, a few projects are on ec2, small ones, some bastion hosts.  
**ALB**: ALB Only  
**Github**: [https://github.com/davisindextech](https://github.com/davisindextech)  
**Primary Stack**: React.js for Frontend & Node.js for Backend, AWS RDS PostgreSQL and a few are on Mongo DB Atlas  
**Region**: Virginia**AWS Logins:**  
**Dev + Prod Environment:**    
 **GitHub**   

RDBMS 
	aurora postgrql
![[Pasted image 20240109121532.png]]


on:
  push:
    branches: [ staging ]
  workflow_dispatch:

name: Deploy to Backend Service

env:
  AWS_REGION: eu-west-3     # set this to your preferred AWS region, e.g. us-west-1
  ECR_REPOSITORY: iclosed-backend-service-stg           # set this to your Amazon ECR repository name
  ECS_SERVICE: iclosed-backend-stg                # set this to your Amazon ECS service name
  ECS_CLUSTER: iclosed-cluster-stg                 # set this to your Amazon ECS cluster name
  ECS_TASK_DEFINITION: .aws/task-definition-stg.json
  CONTAINER_NAME: iclosed-backend-service-stg


jobs:

  BuildAndDeploy:
    name: Deploy to Backend Service
    runs-on: ubuntu-latest
    environment: staging

    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:   
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1

      - name: Build, tag, and push image to Amazon ECR
        id: build-image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          IMAGE_TAG: latest
        run: |
          # Build a docker container and
          # push it to ECR so that it can
          # be deployed to ECS.
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG -f Dockerfile.staging .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
          echo "::set-output name=image::$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG"
      - name: Fill in the new image ID in the Amazon ECS task definition
        id: task-def
        uses: aws-actions/amazon-ecs-render-task-definition@v1
        with:
          task-definition: ${{ env.ECS_TASK_DEFINITION }}
          container-name: ${{ env.CONTAINER_NAME }}
          image: ${{ steps.build-image.outputs.image }}

      - name: Deploy Amazon ECS task definition
        uses: aws-actions/amazon-ecs-deploy-task-definition@v1
        with:
          task-definition: ${{ steps.task-def.outputs.task-definition }}
          service: ${{ env.ECS_SERVICE }}
          cluster: ${{ env.ECS_CLUSTER }}
          wait-for-service-stability: false











# Workflow to Deploy to AWS ECS

# ECS Deployments with GitHub Action

[

](https://medium.com/plans?dimension=post_audio_button&postId=dd34beed6528&source=upgrade_membership---post_audio_button----------------------------------)

![](https://miro.medium.com/v2/resize:fit:700/0*3KEFHD9av_4lTohQ)

Photo by [Luke Chesser](https://unsplash.com/@lukechesser?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)

This article aims to demonstrate how to set up a GitHub Action to continuously deploy your application to AWS ECS. AWS ECS is a serverless service that deploys containers in an easy-to-manage way. It provides a number of awesome benefits like auto-scaling, load balancing, rolling updates, and health checks.

Now, I know GitHub has a document with instructions on how to accomplish this, but I found it incomplete and lacking important details. So I created my own how-to to extend theirs. However, I did use their workflow in the document as a template so definitely reference their document as well.

[

## Deploying to Amazon Elastic Container Service - GitHub Docs

### You can deploy to Amazon Elastic Container Service (ECS) as part of your continuous deployment (CD) workflows.

docs.github.com

The TL;DR version of this article goes as follows:

1. Set up ECR in AWS
2. Push the docker image to ECR
3. Create an ECS cluster
4. Create a task definition
5. Manually deploy the application
6. Complete the workflow to continuously deploy

# Set up ECR in AWS

First, set up a registry where a GitHub Action can push application images to. I named my registry dad-jokes-dev.

![](https://miro.medium.com/v2/resize:fit:700/1*xRPTzbow8JaLibH5rcJgTA.png)

# Push the Docker Image to ECR

Next, push the image to the newly created registry to get the first application deployed and ensure everything functions correctly. In the codebase, create a .github/workflows folder, then create an aws.yml file. Keep in mind you can name this file whatever you’d like. Below is a workflow that builds a Docker image and pushes it to the newly created ECR registry. In the env section ensure to add the region and name of the ECR registry.

name: Deploy to Amazon ECS  
  
on:  
  push:  
    branches:  
      - main  
  
env:  
  AWS_REGION: us-east-1  
  ECR_REPOSITORY: dad-jokes-dev      
  
jobs:  
  deploy:  
    name: Deploy  
    runs-on: ubuntu-latest  
    environment: development  
  
    steps:  
      - name: Checkout  
        uses: actions/checkout@v3  
  
      - name: Configure AWS credentials  
        uses: aws-actions/configure-aws-credentials@0e613a0980cbf65ed5b322eb7a1e075d28913a83  
        with:  
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}  
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}  
          aws-region: ${{ env.AWS_REGION }}  
  
      - name: Login to Amazon ECR  
        id: login-ecr  
        uses: aws-actions/amazon-ecr-login@62f4f872db3836360b72999f4b87f1ff13310f3a  
  
      - name: Build, tag, and push image to Amazon ECR  
        id: build-image  
        env:  
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}  
          IMAGE_TAG: ${{ github.sha }}  
        run: |  
          # Build a docker container and  
          # push it to ECR so that it can  
          # be deployed to ECS.  
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .  
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG  
          echo "image=$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG" >> $GITHUB_OUTPUT

Before committing the file, set the AWS credentials in the GitHub repository. The workflow requires the credentials in order to successfully push the image.

![](https://miro.medium.com/v2/resize:fit:700/1*t_yj-Wema0n8f1gAJ8ryhw.png)

Finally, commit the changes and ensure the workflow is executed correctly.

![](https://miro.medium.com/v2/resize:fit:700/1*y_uo0fD9xGJcY-K6NxHD6g.png)

Navigate to the ECR registry to confirm the image is there.

![](https://miro.medium.com/v2/resize:fit:700/1*vhDui9THLVECuXtAPenheA.png)

# Create an ECS Cluster

Next, set up an ECS cluster. An ECS cluster is a grouping of EC2 instances or AWS Fargate tasks on which we’ll deploy and run our containers. I named my cluster the dad-jokes-dev and left the default settings.

![](https://miro.medium.com/v2/resize:fit:700/1*xNehYXx4AcCrP1nhm6JpOA.png)

# Create a Task Definition

Next, set up a task definition. A task definition defines the containers and resources required for the application to run. In the container details section give a name to the container, then grab the URI of the image in ECR. The name given will be needed later in the GitHub Actions workflow so keep it in mind. Another important note is to give the correct ports (I used port 8000) that are required for the application.

![](https://miro.medium.com/v2/resize:fit:700/1*-2cjUfQ37SQ9L4GEQp2S_w.png)

# Manually Deploy the Application

Now test the setup and deploy the application manually. Start by navigating to the clusters tab in ECS and create a service using the task definition. For compute configuration, choose “Launch type” and leave the default option for Fargate. For the deployment configuration, choose “Service” and then, choose the task definition with the latest revision. Then, navigate to the Networking section and ensure public IP is chosen (You can modify this later if you have specific networking requirements). Finally, create the service.

![](https://miro.medium.com/v2/resize:fit:700/1*Bi7GlSz3k0ZExw4Pqy8jPA.png)

Once the service is active, then navigate to the task tab and click on the task that’s running. You should have a public IP that will redirect you to the application. Note: you may need to add the port in the URL.

![](https://miro.medium.com/v2/resize:fit:700/1*QavHjJ7Xet0dMQXnYy3KvA.png)

The weird characters were supposed to be an emoji. :(

# Complete the Workflow to Continuously Deploy

Now we can complete the GitHub Actions workflow that we previously started. First, navigate to the task definition in AWS and copy the JSON configuration of the task and paste that into a new file in your code. I created a new folder called .aws and a file called task-definition.json in that folder.

![](https://miro.medium.com/v2/resize:fit:700/1*etwzKCejIa7IsllndLlZGQ.png)

Finally, we can complete the GitHub workflow we previously used to push the Docker image to ECR. We start by adding the following variables to the env section.

  ECS_SERVICE: dad-jokes-dev                     # name of the service  
  ECS_CLUSTER: dad-jokes-dev                     # name of the cluster  
  ECS_TASK_DEFINITION: .aws/task-definition.json # path of the JSON task definition  
  CONTAINER_NAME: "app"                          # name of the container name in the task definition

Then add the final jobs at the very end of the workflow.

      - name: Fill in the new image ID in the Amazon ECS task definition  
        id: task-def  
        uses: aws-actions/amazon-ecs-render-task-definition@c804dfbdd57f713b6c079302a4c01db7017a36fc  
        with:  
          task-definition: ${{ env.ECS_TASK_DEFINITION }}  
          container-name: ${{ env.CONTAINER_NAME }}  
          image: ${{ steps.build-image.outputs.image }}  
  
      - name: Deploy Amazon ECS task definition  
        uses: aws-actions/amazon-ecs-deploy-task-definition@df9643053eda01f169e64a0e60233aacca83799a  
        with:  
          task-definition: ${{ steps.task-def.outputs.task-definition }}  
          service: ${{ env.ECS_SERVICE }}  
          cluster: ${{ env.ECS_CLUSTER }}  
          wait-for-service-stability: true













Below is the complete file with sample values that I used.

name: Deploy to Amazon ECS  
  
on:  
  push:  
    branches:  
      - main  
  
env:  
  AWS_REGION: us-east-1  
  ECR_REPOSITORY: dad-jokes-dev  
  ECS_SERVICE: dad-jokes-dev  
  ECS_CLUSTER: dad-jokes-dev  
  ECS_TASK_DEFINITION: .aws/task-definition.json  
  CONTAINER_NAME: "app"  
  
jobs:  
  deploy:  
    name: Deploy  
    runs-on: ubuntu-latest  
    environment: development  
  
    steps:  
      - name: Checkout  
        uses: actions/checkout@v3  
  
      - name: Configure AWS credentials  
        uses: aws-actions/configure-aws-credentials@0e613a0980cbf65ed5b322eb7a1e075d28913a83  
        with:  
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}  
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}  
          aws-region: ${{ env.AWS_REGION }}  
  
      - name: Login to Amazon ECR  
        id: login-ecr  
        uses: aws-actions/amazon-ecr-login@62f4f872db3836360b72999f4b87f1ff13310f3a  
  
      - name: Build, tag, and push image to Amazon ECR  
        id: build-image  
        env:  
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}  
          IMAGE_TAG: ${{ github.sha }}  
        run: |  
          # Build a docker container and  
          # push it to ECR so that it can  
          # be deployed to ECS.  
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .  
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG  
          echo "image=$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG" >> $GITHUB_OUTPUT  
  
      - name: Fill in the new image ID in the Amazon ECS task definition  
        id: task-def  
        uses: aws-actions/amazon-ecs-render-task-definition@c804dfbdd57f713b6c079302a4c01db7017a36fc  
        with:  
          task-definition: ${{ env.ECS_TASK_DEFINITION }}  
          container-name: ${{ env.CONTAINER_NAME }}  
          image: ${{ steps.build-image.outputs.image }}  
  
      - name: Deploy Amazon ECS task definition  
        uses: aws-actions/amazon-ecs-deploy-task-definition@df9643053eda01f169e64a0e60233aacca83799a  
        with:  
          task-definition: ${{ steps.task-def.outputs.task-definition }}  
          service: ${{ env.ECS_SERVICE }}  
          cluster: ${{ env.ECS_CLUSTER }}  
          wait-for-service-stability: true

I then made a simple change to the application then committed the changes. Once, the jobs execute we can navigate to ECS again, find the new public IP and check that the application has been updated.

![](https://miro.medium.com/v2/resize:fit:700/1*lKTxD4FcxLeSeLzIc8F3Ag.png)

