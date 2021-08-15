# Github Self Hosted Runners Terraform ECS

This project showcase capturing running GitHub Self Hosted Runners in ECS (Fargate Mode) in code using Terraform.

This project contains a dependency of another GitHub project of mine: [github-self-hosted-runner-docker-image](https://github.com/colinbut/github-self-hosted-runner-docker-image) which represents the Docker image of the GitHub Runner.

## Bootstrap

### 1. Add GitHub PAT Token Secret to AWS SSM Parameter Store

The Docker image which is used to spin up the Docker container within the ECS Task accepts Environment Variable representing the GitHub Pat Token which is injected into the Container at runtime on ECS Task start up and the way the ECS Task does this is by pulling it from SSM Parameter Store so will need to add the SSM parameter as follows:

e.g. 

```bash
aws ssm put-parameter --name github_runner_pat_token --type SecureString --value [Your GitHub Pat Token]
```

The SSM Parameter above would be injected into the ECS Task Definition as defined as Environment Variables for the Docker Image.

### 2. Deploy Infrastructure

The next step need to deploy the ECS Cluster along with the ECS Service & ECS Task Definition plus all other required AWS resources that goes along with it.

```bash
make init
make plan
make apply
```

### 3. Run ECS Task

After deploying the Infrastructure you can run the ECS task directly by:

from `awscli` run:

```bash
aws ecs --region eu-west-1 run-task --count 1 --cluster github_runner --task-definition github-runner-task:3 --network-configuration "awsvpcConfiguration={subnets=['subnet-85da92cd','subnet-2d255d4b','subnet-e14ef4bb'],securityGroups=['sg-2274d256'],assignPublicIp='ENABLED'}" --launch-type FARGATE
```

replace subnet ids with your subnet ids for your VPC since need to run the ECS Docker Container within a VPC.

## Authors

Colin But
