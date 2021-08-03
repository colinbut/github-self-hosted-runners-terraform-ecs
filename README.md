# github-self-hosted-runners-terraform-ecs

## Bootstrap

### 1. ECR Repository
Create the ECR repository for storing the GitHub Runner Docker Image

```bash
aws ecr create-repository --repository-name github-runner
```

### 2. Build & Push GitHub Runner Docker Image

#### Setup direnv

This project uses [direnv](https://direnv.net/) to manage environment variables for the project. Follow the instructions on [direnv](https://direnv.net/) to install `direnv` and hook up to your shell.

Then once that is setup, create a `.envrc` file locally with your environment variables and then enable direnv loading when starting this project:

```bash
direnv allow .
```

Currently, the only environment variable setup is `AWS_ACCOUNT_ID` which denotes the AWS account for which it is used by docker commands within the `Makefile`

```bash
make build
make push
```

### 3. Add GitHub PAT Token Secret to AWS SSM Parameter Store

e.g. 

```bash
aws ssm put-parameter --name github_runner_pat_token --type SecureString --value [Your GitHub Pat Token]
```

The SSM Parameter above would be injected into the ECS Task Definition as defined as Environment Variables for the Docker Image.
