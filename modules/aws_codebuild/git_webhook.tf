resource "aws_codebuild_webhook" "git_webhook" {
    project_name = aws_codebuild_project.best-codebuild-ever.name
    filter_group {
      
      filter {
        type = "EVENT"
        pattern = "PUSH"
      }

      filter{
          type = "HEAD_REF"
          pattern = "^refs/heads/main$"
      }
    
    }   
}

