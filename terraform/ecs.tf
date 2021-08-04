resource "aws_ecs_cluster" "github_runner_ecs_cluster" {
  name = "github_runner"

  capacity_providers = [ "FARGATE" ]
}
