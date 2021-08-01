# github-self-hosted-runners-terraform-ecs

## Bootstrap

### ECR Repository
Create the ECR repository for storing the GitHub Runner Docker Image

```bash
aws ecr create-repository --repository-name github-runner
```

### Build & Push GitHub Runner Docker Image

```bash
make build
```

# TODO

- [ ] Setup ECS manually  
- [ ] Automate ECS (Task Definition/ECS Cluster) using Terraform
