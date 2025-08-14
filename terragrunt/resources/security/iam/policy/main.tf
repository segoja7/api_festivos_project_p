
# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}



resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${local.workspace.pipeline_role_name}-policy"
  role = var.codepipeline_role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketVersioning",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ]
        Resource = [
          var.build_project_arn,
          var.db_bootstrap_project_arn,
          var.deploy_project_arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codestar-connections:UseConnection"
        ]
        Resource = var.github_connection_arn
      }
    ]
  })
}


resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${local.workspace.codebuild_role_name}-policy"
  role = var.codebuild_role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${var.cloudwatch_logs_group_arn}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:DescribeNodegroup",
          "eks:AccessKubernetesApi"
        ]
        Resource = [
          "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${var.eks_cluster_name}",
          "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:nodegroup/${var.eks_cluster_name}/*/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          var.rds_secret_arn,
          var.jwt_secret_arn,
          var.dockerhub_secret_arn
        ]
      }
    ]
  })
}