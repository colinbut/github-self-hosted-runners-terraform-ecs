variable "github_repo_url" {
  description = "The URL of the GitHub Repo for which to setup GitHub Self Hosted Runners for"
  type        = string
}

variable "runner_name" {
  description = "The name to give to the GitHub Runner so you can easily identify it"
  type        = string
}

variable "labels" {
  description = "A list of additional labels to attach to the runner instance"
  type        = list(string)
}

variable "subnets" {
  description = "The subnets of the VPC to place the GitHub Runners in"
  type        = list(string)
}
