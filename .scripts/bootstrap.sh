#!/bin/sh
set -euo pipefail

SCRIPTS_DIR=$(cd $(dirname $0) && pwd)
PROJECT_ROOT=$(cd "$SCRIPTS_DIR/.." && pwd)

STACK_NAME="HyoacloudLandingZone-Bootstrap"
REGION="ap-southeast-1"

echo "Bootstrapping the project"
aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$PROJECT_ROOT/src/bootstrap.yaml" \
  --region "$REGION" \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
echo

echo "Enabling service access for AWS services"
aws organizations enable-aws-service-access --service-principal ram.amazonaws.com
aws organizations enable-aws-service-access --service-principal sso.amazonaws.com
aws organizations enable-aws-service-access --service-principal guardduty.amazonaws.com
aws organizations enable-aws-service-access --service-principal securityhub.amazonaws.com
aws organizations enable-aws-service-access --service-principal access-analyzer.amazonaws.com
aws organizations enable-aws-service-access --service-principal config.amazonaws.com
aws organizations enable-aws-service-access --service-principal account.amazonaws.com
echo

echo "Successfully bootstrapped the project"
echo
