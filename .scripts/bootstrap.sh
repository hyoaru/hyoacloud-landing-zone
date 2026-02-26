#!/bin/sh
set -euo pipefail

SCRIPTS_DIR=$(cd $(dirname $0) && pwd)
PROJECT_ROOT=$(cd "$SCRIPTS_DIR/.." && pwd)
BOOTSTRAP_DIR=$(cd "$PROJECT_ROOT/bootstrap" && pwd)

aws cloudformation deploy \
  --stack-name "bootstrap-artifacts-storage" \
  --template-file "$BOOTSTRAP_DIR/artifacts-storage.yaml" \
  --region "ap-southeast-1"
