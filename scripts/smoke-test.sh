#!/usr/bin/env bash
# Starts the image restricted (uid 1000, a read-only root, every capability dropped), with only the
# paths the Project mounts writable, and waits until it serves.
# Usage: scripts/smoke-test.sh <prowlarr-image>
set -euo pipefail
owned='uid=1000,gid=1000'

cleanup() { docker rm -f smoke-prowlarr >/dev/null 2>&1 || true; }
trap cleanup EXIT
cleanup

docker run -d --name smoke-prowlarr --read-only --cap-drop ALL \
  --tmpfs "/tmp:$owned,mode=1777" --tmpfs "/config:$owned" "$1" >/dev/null

code=""
for _ in $(seq 1 60); do
  code=$(docker exec smoke-prowlarr curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:9696/ping 2>/dev/null || true)
  [ "$code" = 200 ] && break
  if [ "$(docker inspect -f '{{.State.Running}}' smoke-prowlarr)" != true ]; then
    docker logs smoke-prowlarr 2>&1 | tail -30
    echo "prowlarr exited before it served" >&2
    exit 1
  fi
  sleep 3
done
[ "$code" = 200 ] || { docker logs smoke-prowlarr 2>&1 | tail -30; echo "prowlarr never served /ping" >&2; exit 1; }
# Writing a temporary file is where a TMPDIR outside the writable paths shows.
if docker logs smoke-prowlarr 2>&1 | grep -q 'DirectoryNotFoundException'; then
  docker logs smoke-prowlarr 2>&1 | grep -A3 DirectoryNotFoundException | head -8
  echo "prowlarr writes outside its writable paths" >&2
  exit 1
fi
others=$(docker top smoke-prowlarr -eo pid,uid | tail -n +2 | awk '$2 != 1000')
[ -z "$others" ] || { echo "prowlarr runs a process as another uid: $others" >&2; exit 1; }
echo "prowlarr serves /ping as uid 1000"
echo "smoke test passed"
