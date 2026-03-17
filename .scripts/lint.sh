#!/bin/sh
set -euo pipefail

SCRIPTS_DIR=$(cd $(dirname $0) && pwd)
PROJECT_ROOT=$(cd "$SCRIPTS_DIR/.." && pwd)

echo "Linting the project"
cfn-lint "$PROJECT_ROOT/**/*.yaml" --ignore-checks W3002 --ignore-checks W6001
echo "Successfully linted the project"
echo