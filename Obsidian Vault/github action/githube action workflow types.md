

![[Pasted image 20240727214258.png]]


 
![[Screenshot from 2024-02-08 19-35-01 1.png]]


![[Screenshot from 2024-02-08 21-42-09.png]]

GitHub Actions is a powerful tool for automating software development workflows. As a DevOps engineer, understanding the various types of GitHub Action workflows can help streamline processes, enhance CI/CD pipelines, and improve collaboration across teams. Here's an overview of the primary types of GitHub Action workflows:

### 1. **CI/CD Workflows**

CI/CD workflows are the backbone of modern DevOps practices, enabling continuous integration and continuous deployment. They automate the process of testing, building, and deploying code.

- **Continuous Integration (CI)**: These workflows run automated tests and build processes every time code is pushed to a repository or a pull request is made. This ensures that the new code integrates well with the existing codebase without breaking anything.
    
    - Example: Running unit tests and linting on every pull request.
- **Continuous Deployment (CD)**: These workflows extend CI by automatically deploying the tested code to production or staging environments. This ensures rapid and reliable releases.
    
    - Example: Deploying a web application to a production server after all tests pass.

### 2. **Scheduled Workflows**

Scheduled workflows are triggered at specific intervals using cron syntax. They are useful for tasks that need to run periodically.

- **Example Use Cases**:
    - Running nightly builds and tests.
    - Generating and publishing reports.
    - Automated database backups.

### 3. **Manual Workflows (Workflow Dispatch)**

Manual workflows are triggered manually by a user through the GitHub UI. This is useful for workflows that need to be run on demand rather than automatically.

- **Example Use Cases**:
    - Manually deploying to a staging environment.
    - Running maintenance scripts or data migrations.

### 4. **Event-driven Workflows**

These workflows are triggered by specific events that occur within the GitHub ecosystem. They provide flexibility in automating a wide range of activities.

- **Common Events**:
    - **push**: Triggered when code is pushed to a repository.
    - **pull_request**: Triggered when a pull request is opened, synchronized, or reopened.
    - **release**: Triggered when a release is published, edited, or deleted.
    - **issue**: Triggered when an issue is opened, edited, or closed.
    - **fork**: Triggered when a repository is forked.

### 5. **External Event Workflows (Webhooks)**

These workflows are triggered by external events through webhooks. This allows integration with external systems and services.

- **Example Use Cases**:
    - Triggering a workflow when an external system sends a webhook event (e.g., a deployment system notifying of a successful deployment).
    - Integrating with third-party services like Slack or Jira.

### Example GitHub Action Workflow File

Below is an example of a simple CI workflow defined in a `.github/workflows/ci.yml` file:

name: CI 
on: push:
branches: [ main ] pull_request: branches: [ main ] 
jobs: 
build: runs-on: ubuntu-latest 
steps: - name: Checkout code uses: actions/checkout@v2 - name: Set up Node.js uses: actions/setup-node@v2 with: node-version: '14' - name: Install dependencies run: npm install - name: Run tests run: npm test

### Best Practices

- **Modularity**: Break down workflows into reusable actions to avoid duplication and simplify maintenance.
- **Secrets Management**: Use GitHub Secrets to store sensitive information securely.
- **Matrix Builds**: Use matrix strategies to run jobs in parallel for different environments or configurations.
- **Caching**: Utilize caching to speed up workflow runs by reusing dependencies and build outputs.