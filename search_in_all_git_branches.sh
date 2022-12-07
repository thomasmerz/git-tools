#!/bin/bash

# search for something in all branches of a git-repo:
[ "$1" == "" ] && { echo "Usage: $(basename "$0") what-to-search-for [parameter-for-grep]" ; exit 1; }

# https://stackoverflow.com/questions/3846380/how-to-iterate-through-all-git-branches-using-bash-script/3847586#3847586
#git for-each-ref --shell --format "git grep \"$1\" %(refname)" refs/remotes | bash

for b in $(git branch -a | grep -v "remotes/origin/HEAD" | grep remote | sed -e 's/^[ *]\+\([^ ]\+\).*$/\1/'); do
  echo -e "\n=== $b ==="
  git grep "$2" "$1" "$b"
done
#
#=== master ===
#      1 master:Puppetfile:mod 'logstash', git: 'git@gitlab.dm-drogeriemarkt.com:puppet/logstash.git'
#=== remotes/origin/BDA-3197-prod ===
#      1 remotes/origin/BDA-3197-prod:Puppetfile:    git: 'git@gitlab.dm-drogeriemarkt.com:puppet/logstash.git',

