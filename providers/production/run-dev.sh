#!/bin/bash
echo "Deploy project - developer mode"
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply -auto-approve 