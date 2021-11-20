resource "aws_codebuild_webhook" "git_webhook" {
    project_name = aws_codebuild_project.codebuild.name
    filter_group {
      
      filter {
        type = "EVENT"
        pattern = var.git_trigger_event
      }

      filter{
          type = "HEAD_REF"
          pattern = var.branch_pattern
      }
    
    }   
}

