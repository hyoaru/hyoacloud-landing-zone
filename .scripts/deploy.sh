#!/bin/sh
set -euo pipefail

SCRIPTS_DIR=$(cd $(dirname $0) && pwd)
PROJECT_ROOT=$(cd "$SCRIPTS_DIR/.." && pwd)

artifacts_bucket=$(
  aws ssm get-parameter \
    --name "/iac/landing-zone/artifacts-bucket-name" \
    --query "Parameter.Value" \
    --output text
)

packaged_template_path="/tmp/landing-zone-packaged-stack.yaml"

aws cloudformation package \
  --template-file "$PROJECT_ROOT/stack.yaml" \
  --s3-bucket $artifacts_bucket \
  --output-template-file $packaged_template_path \
  >/dev/null

aws cloudformation deploy \
  --stack-name "landing-zone" \
  --template-file $packaged_template_path
