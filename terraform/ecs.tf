resource "aws_ecs_cluster" "github_runner_ecs_cluster" {
  name = "github_runner"

  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "github_runner_ecs_task_def" {
  family                   = "github_runner"
  cpu                      = "1"
  memory                   = "0.5"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.ecs_task_def_execution_role.arn
  network_mode       = "awsvpc"

  container_definitions = jsonencode([
    {
      name  = "github_runner_image_def"
      image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/github-runner"
      environment = [
        {
          github_runner_pat_token = var.github_runner_pat_token
        }
      ]
    }
  ])
}

resource "aws_iam_role" "ecs_task_def_execution_role" {
  name        = "github_runner_ecs_task_def_execution_role"
  description = ""

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "ECSAssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = ""
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = "ssm:GetParameter*"
          Effect   = "Allow"
          Sid      = "Get_SSM_Params"
          Resource = "*"
        }
      ]
    })
  }
}
