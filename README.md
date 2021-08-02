# github-self-hosted-runners-terraform-ecs

## Bootstrap

### ECR Repository
Create the ECR repository for storing the GitHub Runner Docker Image

```bash
aws ecr create-repository --repository-name github-runner
```

### Build & Push GitHub Runner Docker Image

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
