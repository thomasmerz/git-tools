#!/bin/bash
# shellcheck disable=SC2010

# https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
#[[ $_ != $0 ]] && echo "Script is being sourced" || { echo "Script must be run like this: \". $0\""; exit 1; }


function do_the_git_stuff () {
  git fetch -p
  git pull|grep -v "Already up to date."
  git gc --auto -q
  cd .. || exit
}

function work_on_dirs () {
#for d in $(ls -1d */ 2>/dev/null| grep -v pass | sort); do
for d in $(ls -l | grep ^d | awk '{print $9}' 2>/dev/null | sort); do
  #echo $n
  # n is the n-th level of dirs:
  # 0 means "main" and 1, 2, ... are sub-dirs of "main" dir.
  [ "$n" -eq "0" ] && echo -e "\033[1;32mMain: $d\033[0m" || echo -e "\033[1;33mSub: $d\033[0m"
  cd "$d" || exit
  if [ -d ".git" ]; then
    do_the_git_stuff
  else
    n=$(( n + 1))
    work_on_dirs $n
    n=0
    cd .. || exit
  fi
  #cd "$DIR"
  [ "$n" -eq "0" ] && echo ""
done
}

DIR=$(pwd)
n=0
if [ -d ".git" ]; then
  echo -e "\n\033[1;31m### This script pulls only this current (git) directory ###\033[0m\n"
  do_the_git_stuff
else
  echo -e "\n\033[1;31m### This script pulls all git directory structures recursively ###\033[0m\n"
  work_on_dirs
fi
cd "$DIR" || exit

