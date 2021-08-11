resource "aws_ecs_cluster" "github_runner_ecs_cluster" {
  name = "github_runner"

  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "github_runner_ecs_task_def" {
  family                   = "github-runner-task"
  cpu                      = "256"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.ecs_task_def_execution_role.arn
  network_mode       = "awsvpc"

  container_definitions = jsonencode([
    {
      name  = "github_runner_image_def"
      image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/github-runner"
      environment = [
        {
          name  = "GITHUB_REPO_URL"
          value = var.github_repo_url
        },
        {
          name  = "LABELS"
          value = join(",", var.labels)
        },
        {
          name  = "RUNNER_NAME"
          value = var.runner_name
        }
      ]
      secrets = [
        {
          name      = "GITHUB_REPO_PAT_TOKEN"
          valueFrom = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/github_runner_pat_token"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_task_def_log_group.name
          awslogs-region        = "${data.aws_region.current.name}"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "ecs_task_def_log_group" {
  name              = "/ecs/${var.runner_name}-ecs-task"
  retention_in_days = 90
}

resource "aws_iam_role" "ecs_task_def_execution_role" {
  name        = "github_runner_ecs_task_def_execution_role"
  description = "The GitHub Runner ECS Task Defintion Execution Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "EnableFetchSecretParamsFromSSM"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = "ssm:GetParameter*"
          Effect   = "Allow"
          Sid      = ""
          Resource = "*"
        }
      ]
    })
  }

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

resource "aws_ecs_service" "github_runner_service" {
  name            = "github-runner-service"
  cluster         = aws_ecs_cluster.github_runner_ecs_cluster.id
  task_definition = aws_ecs_task_definition.github_runner_ecs_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets             = var.subnets
    assign_public_ip    = "true"
  }
}
