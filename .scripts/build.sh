#!/bin/sh
set -euo pipefail

SCRIPTS_DIR=$(cd $(dirname $0) && pwd)
PROJECT_ROOT=$(cd "$SCRIPTS_DIR/.." && pwd)
BUILD_DIR="$PROJECT_ROOT/.aws-cfn"

REGION="ap-southeast-1"
ARTIFACTS_BUCKET="hyoacloud-landing-zone-cfn-artifacts"

rm -Rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "Building the project"
aws cloudformation package \
  --s3-bucket "$ARTIFACTS_BUCKET" \
  --template-file "$PROJECT_ROOT/src/template.yaml" \
  --output-template-file "$BUILD_DIR/template.yaml" \
  --region "$REGION" > /dev/null \
  && echo
  
echo "Successfully built the project"
echo
