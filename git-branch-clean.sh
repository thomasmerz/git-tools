#!/bin/bash
# Originally from Daniel Flassak (dmTECH)
# shellcheck'ed and shfmt'ed by thomasmerz
output=$(tput setaf 7)
error=$(tput setaf 1)
reset=$(tput sgr0)
# green appears unused. Verify use (or export if used externally). [SC2034]
# shellcheck disable=SC2034
green=$(tput setaf 2)
message=$(
  tput bold
  tput setaf 4
)
run_pretty() { # will output everything to stdout in grey and stderr in red
  echo -n "${output}"
  error_message=$(eval "$1" 3>&1 1>&2 2>&3)
  if [ -n "$error_message" ]; then
    echo -n "${error}"
    echo "$error_message"
    echo -n "${reset}"
  fi
}
echo "${message}fetching from origin...${reset}"
run_pretty "git fetch -q"
echo "${message}pruning remotes not in origin...${reset}"
run_pretty "git remote prune origin"
echo "${message}removing branches that are gone in origin...${reset}"
run_pretty "git branch -vv | grep ': gone]'|  grep -v '\*' | awk '{print \$1; }' | xargs git branch -D 2>&1| grep -v 'branch name required'"
echo "${message}removing branches that have no origin remote...${reset}"
run_pretty "git branch -vv | grep --invert-match '\[origin'|  grep -v '\*' | awk '{print \$1; }' | xargs git branch -d 2>&1 | grep -v 'branch name required'"
