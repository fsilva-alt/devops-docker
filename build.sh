#!/usr/bin/env sh
# Build this course with coursekit, the rendering tool kept next to it (../coursekit).
# The tool is used by reference, so updates to coursekit apply here on the next build.
#
#   ./build.sh                build dist/index.html
#   ./build.sh dev            preview at http://127.0.0.1:8000, rebuilt and reloaded as you save
#   ./build.sh --strict       fail on warnings (missing images, broken links …), e.g. in CI
#   COURSEKIT=/path/to/coursekit ./build.sh     use a coursekit checkout somewhere else
set -e
cd "$(dirname "$0")"

COURSEKIT="${COURSEKIT:-../coursekit}"
if [ ! -f "$COURSEKIT/bin/coursekit" ]; then
  echo "coursekit not found at '$COURSEKIT' (relative to $(pwd))." >&2
  echo "Clone it next to this course, or set COURSEKIT=/path/to/coursekit." >&2
  exit 1
fi

if [ "$1" = "dev" ]; then
  shift
  exec sh "$COURSEKIT/bin/coursekit" dev . "$@"
fi
exec sh "$COURSEKIT/bin/coursekit" build . "$@"
