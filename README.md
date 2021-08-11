# Github Self Hosted Runners Terraform ECS

This project showcase capturing running GitHub Self Hosted Runners in ECS (Fargate Mode) in code using Terraform.

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

### 4. Deploy Infrastructure

The next step need to deploy the ECS Cluster along with the ECS Service & ECS Task Definition plus all other required AWS resources that goes along with it.

```bash
make init
make plan
make apply
```

### 5. Run ECS Task

After deploying the Infrastructure you can run the ECS task directly by:

from `awscli` run:

```bash
aws ecs --region eu-west-1 run-task --count 1 --cluster github_runner --task-definition github-runner-task:3 --network-configuration "awsvpcConfiguration={subnets=['subnet-85da92cd','subnet-2d255d4b','subnet-e14ef4bb'],securityGroups=['sg-2274d256'],assignPublicIp='ENABLED'}" --launch-type FARGATE
```

replace subnet ids with your subnet ids for your VPC since need to run the ECS Docker Container within a VPC.

## Authors

Colin But
