#!/bin/bash

########## Git Fetch ###########
gitScriptFetch() {
  commandPrint "git fetch"
}

########### Git Add All ###############
gitScriptAddAll() {
  commandPrint "git add ."
}

########## Git add src/ folder ###############
gitScriptAddSrc() {
  commandPrint "git add src/"
}

############## Git status ###############
gitScriptStatus() {
  git status
}


##################### Git Commit ###################
gitScriptCommit() {
  while [ -z "${commitFeature}" ]; do
    read -r -n "Enter feature name (e.g., FC-299): " commitFeature
  done
  while [ -z "${commitMessage}" ]; do
    read -r -n "Enter commit message (e.g., fixed bugs): " commitMessage
  done

  commandPrint "git commit -m \"${commitFeature}: ${commitMessage}\""
}


############### Git amend commit ######################
gitScriptCommitAmend() {
  commandPrint "git commit --amend --no-edit"
}


############# Git push #############################
gitScriptPush() {
  commandPrint "git push"
}

###################### Git push Force with lease ############
gitScriptPushForceWithLease() {
  commandPrint "git push --force-with-lease"
}

################## Git Squash ########################
gitScriptSquash() {
  while [ -z "${nums}" ]; do
    read -r -n "Please enter number of commits to squash: " nums
  done
  commandprint "git rebase -i Head~${nums}"
}

##################### Git rebase #######################
gitScriptRebase() {
  commandPrint "git rebase origin $1"
}