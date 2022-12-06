#!/bin/bash

# rebase my forked HEAD against upstream HEAD:

cols="$(tput cols)"

pinfo() {
  out="$1"
  echo -e "\033[1;30m[\033[0m$(date +%Y-%m-%dT%H:%M:%S --utc)Z \033[0;32mINFO\033[0m \033[1;30m]\033[0m $out"
}

function perror() {
  out="$1"
  echo -e "\033[1;30m[\033[0m$(date +%Y-%m-%dT%H:%M:%S --utc)Z \033[1;31mERROR\033[0m \033[1;30m]\033[0m $out"
}

line_white() {
  echo -en "\033[1;37m$(printf '%.s─' $(seq 1 $((cols - 5))))\033[0m"
  echo -e "" ## just a newline
}

line_grey() {
  echo -en "\033[1;30m$(printf '%.s─' $(seq 1 $((cols - 5))))\033[0m"
  echo -e "" ## just a newline
}

line_grey
pinfo "\033[1;36mSync fork - sync my fork from upstream URL via local upstream branch\033[0m"
line_white

pinfo "Pulling Upstream HEAD into forked branch:"
if git checkout upstream; then
  if git pull upstream HEAD; then
    OUT="$(git push 2>&1)" || { line_grey; perror "$OUT"; exit 1; }; echo "$OUT"
  fi
else
  perror "Error while checking out upstream. See details above."
  line_grey
  exit 1
fi
line_grey

pinfo "Local checkout of my HEAD and pulling:"
git checkout "$(git remote show origin|grep "HEAD branch"|cut -d":" -f2|tr -d " ")" && git pull
line_grey

pinfo "Rebasing my local HEAD with synced fork / upstream HEAD and pushing:"
if git rebase upstream; then
  OUT="$(git push 2>&1)" || { line_grey; perror "$OUT"; exit 1; }; echo "$OUT"
else
  perror "Error while rebasing upstream. See details above."
  line_grey
  exit 1
fi
line_grey

