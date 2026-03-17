#!/bin/sh
set -euo pipefail

SCRIPTS_DIR=$(cd $(dirname $0) && pwd)
PROJECT_ROOT=$(cd "$SCRIPTS_DIR/.." && pwd)
BUILD_DIR="$PROJECT_ROOT/.aws-cfn"

if [ -f "$PROJECT_ROOT/.env" ]; then
  echo "Loading environment variables from .env"
  export $(grep -v '^#' "$PROJECT_ROOT/.env" | xargs)
else
  echo "Error: .env file not found at $PROJECT_ROOT/.env"
  exit 1
fi

STACK_NAME="HyoacloudLandingZone"
CHANGE_SET_NAME="$STACK_NAME-ChangeSet-$(date +%s)"
REGION="ap-southeast-1"
PACKAGED_TEMPLATE="$BUILD_DIR/template.yaml"

echo "Deploying the project: $STACK_NAME in region: $REGION using change set: $CHANGE_SET_NAME"
aws cloudformation create-change-set \
  --stack-name "$STACK_NAME" \
  --change-set-name "$CHANGE_SET_NAME" \
  --template-body "file://$PACKAGED_TEMPLATE" \
  --region "$REGION" \
  --parameters \
    ParameterKey=LogArchiveCoreAccountEmail,ParameterValue="$LOG_ARCHIVE_CORE_ACCOUNT_EMAIL" \
    ParameterKey=SecurityCoreAccountEmail,ParameterValue="$SECURITY_CORE_ACCOUNT_EMAIL" \
    ParameterKey=ToolingCoreAccountEmail,ParameterValue="$TOOLING_CORE_ACCOUNT_EMAIL" \
    ParameterKey=ProductionWorkloadAccountEmail,ParameterValue="$PRODUCTION_WORKLOAD_ACCOUNT_EMAIL" \
    ParameterKey=StagingWorkloadAccountEmail,ParameterValue="$STAGING_WORKLOAD_ACCOUNT_EMAIL" \
    ParameterKey=IdentityCenterInstanceArn,ParameterValue="$IDENTITY_CENTER_INSTANCE_ARN" \
    ParameterKey=IdentityCenterIdentityStoreId,ParameterValue="$IDENTITY_CENTER_IDENTITY_STORE_ID" \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
  > /dev/null
echo

echo "Waiting for change set to be ready"
aws cloudformation wait change-set-create-complete \
  --stack-name "$STACK_NAME" \
  --change-set-name "$CHANGE_SET_NAME"
echo

echo "Previewing changes in the change set: $CHANGE_SET_NAME for stack: $STACK_NAME"
AWS_PAGER="" aws cloudformation describe-change-set \
  --stack-name "$STACK_NAME" \
  --change-set-name "$CHANGE_SET_NAME" \
  --query "Changes[*].ResourceChange" \
  --output table
echo

read -p "Do you want to execute this change set? (y/N) " is_confirm
if [ "$is_confirm" = "y" ] || [ "$is_confirm" = "Y" ]; then
    echo "Executing Change Set..."
    aws cloudformation execute-change-set \
      --stack-name "$STACK_NAME" \
      --change-set-name "$CHANGE_SET_NAME"

    echo "Waiting for stack update to complete."
    aws cloudformation wait stack-update-complete \
      --stack-name "$STACK_NAME"

    echo "Deployment executed successfully."
else
    echo "Change Set not executed. Exiting."
fi

echo