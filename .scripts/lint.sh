#!/bin/sh
set -euo pipefail

SCRIPTS_DIR=$(cd $(dirname $0) && pwd)
PROJECT_ROOT=$(cd "$SCRIPTS_DIR/.." && pwd)

cfn-lint "$PROJECT_ROOT/**.yaml"
