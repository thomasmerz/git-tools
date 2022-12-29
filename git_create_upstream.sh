#!/bin/bash

# create upstream branch

cols="$(tput cols)"

pinfo() {
  out="$1"
  echo -e "\033[1;30m[\033[0m$(date +%Y-%m-%dT%H:%M:%S --utc)Z \033[0;32mINFO\033[0m \033[1;30m]\033[0m $out"
}

line_white() {
  echo -en "\033[1;37m$(printf '%.s─' $(seq 1 $((cols - 5))))\033[0m"
  echo -e "" ## just a newline
}

line_grey() {
  echo -en "\033[1;30m$(printf '%.s─' $(seq 1 $((cols - 5))))\033[0m"
  echo -e "" ## just a newline
}

function perror() {
  out="$1"
  echo -e "\033[1;30m[\033[0m$(date +%Y-%m-%dT%H:%M:%S --utc)Z \033[1;31mERROR\033[0m \033[1;30m]\033[0m $out"
}

error_and_exit() {
  line_grey
  perror "$OUT"
  line_grey
  exit 1
}

[ "$1" == "" ] && {
  line_grey
  perror "Usage: $(basename "$0") upstream-repo-URL"
  line_grey
  exit 1
}

line_grey
pinfo "\033[1;36mSync fork - add a local upstream branch with upstream URL \033[0m[\033[1;33m$(basename "$(pwd)")\033[0m]"
line_white

pinfo "Add upstream HEAD URL to my branch."
OUT="$(git remote add upstream "$1" 2>&1)" || error_and_exit
line_grey

pinfo "Checkout local upstream branch:"
OUT="$(git checkout -b upstream 2>&1)" || error_and_exit; echo "$OUT"
line_grey

pinfo "Pushing into my upstream branch:"
OUT="$(git push --set-upstream origin upstream 2>&1)" || error_and_exit; echo "$OUT"
line_grey

