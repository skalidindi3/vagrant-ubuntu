#!/usr/bin/env bash

readonly ANTIGEN_FOLDER=~/.antigen

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
                          gdb               \
                          vim               \
                          git-core          \
                          tmux              \
                          python-serial     \
                          python-matplotlib \
                          ipython           \
                          nodejs            \
                          nodejs-legacy     \
                          npm
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

function TURN_OFF_GITHUB_HOST_CHECKING() {
  echo "Turning off StrictHostKeyChecking for github ..."
  if ! $(grep "StrictHostKeyChecking no" ~/.ssh/config &> /dev/null); then
    echo -e "Host github.com\n\tStrictHostKeyChecking no" >> ~/.ssh/config
    echo "Turned off StrictHostKeyChecking for github."
  else
    echo "StrictHostKeyChecking already turned off for github."
  fi
  # NOTE: could check specific access with `git ls-remote "$EMBEDDED_REPO_LOC" &> /dev/null`
}

function TURN_ON_GITHUB_HOST_CHECKING() {
  echo "Turning on StrictHostKeyChecking for github ..."
  sed -i 'N;s/Host github.com\n.StrictHostKeyChecking no//' ~/.ssh/config
  echo "Turned on StrictHostKeyChecking for github."
}

function GET_ANTIGEN() {
  if ! [ -e "$ANTIGEN_FOLDER/antigen" ]; then
    echo "Getting antigen ..."
    mkdir -p $ANTIGEN_FOLDER
    cd $ANTIGEN_FOLDER
    git clone git@github.com:/zsh-users/antigen
    echo "Done getting antigen."
  fi
}

function SET_ZSH() {
  TURN_OFF_GITHUB_HOST_CHECKING
  echo "Setting zsh ..."
  sudo apt-get install -y zsh
  GET_ANTIGEN
  sudo chsh -s /bin/zsh vagrant
  echo "zsh set."
  TURN_ON_GITHUB_HOST_CHECKING
}

main() {
  CHECK_LINUX
  GET_BASE_PKGS
  CHECK_GIT
  SET_ZSH
}

main

