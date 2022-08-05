#!/bin/bash

########## Git Fetch ###########
gitFetch() {
  commandPrint "git fetch"
}

########### Git Add All ###############
gitAddAll() {
  commandPrint "git add ."
}

########## Git add src/ folder ###############
gitAddSrc() {
  commandPrint "git add src/"
}

############## Git status ###############
gitStatus() {
  git status
}


##################### Git Commit ###################
gitCommit() {
  while [ -z "${commitFeature}" ]; do
    read -r -n "Enter feature name (e.g., FC-299): " commitFeature
  done
  while [ -z "${commitMessage}" ]; do
    read -r -n "Enter commit message (e.g., fixed bugs): " commitMessage
  done

  commandPrint "git commit -m \"${commitFeature}: ${commitMessage}\""
}


############### Git amend commit ######################
gitCommitAmend() {
  commandPrint "git commit --amend --no-edit"
}


############# Git push #############################
gitPush() {
  commandPrint "git push"
}

###################### Git push Force with leash ############
gitPushForceWithLeash() {
  commandPrint "git push --force-with-leash"
}

################## Git Squash ########################
gitSquash() {
  while [ -z "${nums}" ]; do
    read -r -n "Please enter number of commits to squash: " nums
  done
  commandprint "git rebase -i Head~${nums}"
}

##################### Git rebase #######################
gitRebase() {
  commandPrint "git rebase origin $1"
}