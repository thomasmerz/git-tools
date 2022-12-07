#!/bin/bash
git stash
git reset --hard "$(git rev-list HEAD | tail -n1)" && git pull
git stash pop
