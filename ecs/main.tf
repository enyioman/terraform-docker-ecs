data "aws_ecr_repository" "project_ecr_repo" {
  name = "ecr-project-repo"
}

resource "aws_ecs_cluster" "project_cluster" {
  name = "project-cluster"
}

resource "aws_ecs_service" "project_service" {
  name            = "project-service"
  cluster         = aws_ecs_cluster.project_cluster.id
  task_definition = aws_ecs_task_definition.project_task.arn
  launch_type     = "FARGATE"
  desired_count   = 3

  network_configuration {
    subnets          = ["${aws_subnet.public_1.id}", "${aws_subnet.public_2.id}"]
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "project_task" {
  family                   = "project-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "project-task",
      "image": "${data.aws_ecr_repository.project_ecr_repo.repository_url}",
      "essential": true,
      "cpu": 256,
      "memory": 512,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ]
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

data "aws_iam_policy_document" "ecs-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}




# resource "aws_ecs_cluster" "cluster" {
#   name = "kp-ecs-cluster"

#   setting {
#     name  = "containerInsights"
#     value = "disabled"
#   }
# }

# resource "aws_ecs_cluster_capacity_providers" "cluster" {
#   cluster_name = aws_ecs_cluster.cluster.name

#   capacity_providers = ["FARGATE_SPOT", "FARGATE"]

#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = "FARGATE_SPOT"
#   }
# }


# module "ecs-fargate" {
#   source  = "umotif-public/ecs-fargate/aws"
#   version = "~> 6.1.0"

#   name_prefix        = "ecs-fargate-P19"
#   vpc_id             = aws_vpc.TF_KP19.id
#   private_subnet_ids = [aws_subnet.private_subnet_1a_KP19.id, aws_subnet.private_subnet_1b_KP19.id]

#   cluster_id = aws_ecs_cluster.cluster.id

#   task_container_image   = "centos:latest"
#   task_definition_cpu    = 256
#   task_definition_memory = 512

#   task_container_port             = 80
#   task_container_assign_public_ip = true

#   load_balanced = false

#   target_groups = [
#     {
#       target_group_name = "tg-fargate-KP19"
#       container_port    = 80
#     }
#   ]

#   health_check = {
#     port = "traffic-port"
#     path = "/"
#   }

#   tags = {
#     Environment = "test"
#     Project     = "P19"
#   }
# }
