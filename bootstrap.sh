#!/usr/bin/env bash

readonly LIBS_FOLDER=~/libs

function CHECK_LINUX() {
  if [ $(uname) != "Linux" ]; then
    echo "This script is only for Linux. Sorry!\n" 1>&2
    exit 1
  fi
}

function GET_BASE_PKGS() {
  echo "Updating apt-get and getting base packages ..."
  sudo apt-get update
  sudo apt-get upgrade
  sudo apt-get install -y build-essential   \
                          vim               \
                          git-core          \
                          tmux              \
                          python-serial     \
                          python-matplotlib \
                          ipython
  echo "Done getting base packages."
}

function CHECK_GIT() {
  echo "Checking git credentials"
  if git config --global user.name &> /dev/null \
       && git config --global user.email &> /dev/null; then
    echo "Using git credentials:"
    echo -e "\tName:  `git config --global user.name`"
    echo -e "\tEmail: `git config --global user.email`"
  else
    echo "Missing git credentials" 1>&2
    exit 1
  fi
}

main() {
  CHECK_LINUX
  GET_BASE_PKGS
  CHECK_GIT
}

main

