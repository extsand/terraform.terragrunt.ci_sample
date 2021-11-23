#!/bin/bash

#terragrunt cache cleaner

find . -type d -name ".terragrunt-cache"
find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;


terragrunt run-all init --reconfigure
terragrunt run-all plan
terragrunt run-all apply
terragrunt run-all destroy