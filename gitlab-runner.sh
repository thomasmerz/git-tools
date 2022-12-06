#!/bin/bash

# ---
# Use GitLab CI to run tests locally
# https://stackoverflow.com/a/65920577
# https://docs.gitlab.com/runner/install/docker.html
# ---
# Note: The runner will only work on the commited state of your code base.
# Uncommited changes will be ignored.
# Exception: The .gitlab-ci.yml itself does not have be commited to be taken into account
# ---

printf '%.s─' $(seq 1 "$(tput cols)")
case "$1" in
  "-h")
    echo -e "\033[32m[info] Usage: $(basename "$0") [-l|-w job|-h] - You may want to give a JOB as parameter or list JOB(S) in .gitlab-ci.yml\033[0m"
    exit 0
    ;;
  "-l")
    echo -e "\033[32m[info] Trying to determine job from .gitlab-ci.yml\033[0m"
    # there are some jobs with blanks in their name(s):
    IFS=$'\n'
    job=$(grep -E "^[a-z].*" .gitlab-ci.yml | grep -vE 'default|stages' | tr -d ":")
    printf '%.s─' $(seq 1 "$(tput cols)")
    if [ -z "$job" ]; then
      echo -e "\033[31m[error] No job(s) found.\033[0m"
      exit 1
    else
      echo -e "\033[32m[info] Found job(s):\033[0m"
      echo "$job"
      exit 0
    fi
    ;;
  "-w")
    IFS=$'\n'
    job="$2"
    grep -E "^$2" .gitlab-ci.yml -q || { echo -e "\033[31m[error] Job '$2' not found in .gitlab-ci.yml\033[0m"; exit 1; }
    echo -e "\033[32m[info] Running with job=$job\033[0m"
    ;;
  *)
    if [ -z "$1" ]; then
      echo -e "\033[32m[info] No parameter(s) given, try to determine job(s) from .gitlab-ci.yml\033[0m"
    else
      echo -e "\033[32m[info] Ignoring unknown parameter(s) '$*', try to determine job from .gitlab-ci.yml\033[0m"
    fi
    IFS=$'\n'
    job=$(grep -E "^[a-z].*" .gitlab-ci.yml | grep -vE 'default|stages' | tr -d ":")
    echo -e "\033[32m[info] Found job(s):\033[0m"
    echo "$job"
    ;;
esac

#docker pull gitlab/gitlab-runner:latest|grep -q 'up to date' || \
#  { docker stop gitlab-runner && docker rm gitlab-runner; }

#docker run -d \
#  --name gitlab-runner \
#  --restart always \
#  -v $PWD:$PWD \
#  -v /var/run/docker.sock:/var/run/docker.sock \
#  gitlab/gitlab-runner:latest
#
#docker exec -it -w $PWD gitlab-runner gitlab-runner exec docker shellcheck

# or a single "docker run" command:
for j in $job; do
  printf '%.s─' $(seq 1 "$(tput cols)")
  echo -e "\033[32m[$j]\033[0m"
  docker run --rm -w "$PWD" -v "$PWD:$PWD" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:alpine \
    exec docker "$j"
done

