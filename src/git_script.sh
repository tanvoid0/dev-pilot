#!/bin/bash

########## Git Fetch ###########
gitScriptFetch() {
  commandPrint "git fetch"
}

###########
## 1 - default value to create
gitScriptCheckoutBranch() {
  checkout=""
  mode="checkout"
  if [ "$1" == "create" ]; then
    checkout="-b"
    mode="create"
  fi

  read -r -p "Do you want to $mode branch for feature (other option is bug)? (Y/n):" input
  if [ "$input" == "n" ]; then
    input="bugFix"
  else
    input="feature"
  fi
  commitTask=""
  while [ -z "$commitTask" ]; do
    read -r -p "Enter ${BBLUE}task${NC} number (e.g., 55): FC-" commitTask
  done

  commandPrint "git checkout $checkout $input/$commitTask-$NAMESPACE"
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
  commandPrint "git status"
}


##################### Git Commit ###################
gitScriptCommit() {
  input=""
  read -r -p "Do you want to create commit for feature (other option is bug)? (Y/n):" input
  if [ -z "$input" ]; then
    input="feature"
  else
    input="bugFix"
  fi

  commitStory=""
  commitMessage=""
  echo "Commit commitFeature: $commitFeature"

  commitFeature=""
  while [ -z "$commitFeature" ]; do
    read -r -p "Enter ${BBLUE}feature${NC} number (e.g., 55): FC-" commitFeature
  done

  while [ -z "${commitStory}" ]; do
    read -r -p "Enter ${BBLUE}story${NC} number (e.g., 299): FC-" commitStory
  done

  while [ -z "${commitMessage}" ]; do
    read -r -p "Enter ${BBLUE}commit message${NC} (e.g., find list of users): " commitMessage
  done

  commitTitle="$input(FC-$commitStory | FC-$commitFeature) - $commitMessage"

  echo "Commit created with title: ${BRED}$commitTitle${NC}"

  commandPrint "git commit -m '$commitTitle'"
}

gitScriptCommitWithMessage() {
  commitMessage=""
  while [ -z "${commitMessage}" ]; do
    read -r -p "Enter custom ${BBLUE}commit message${NC}: " commitMessage
  done

  commandPrint "git commit -m '$commitMessage'"
}


############### Git amend commit ######################
gitScriptCommitAmend() {
  commandPrint "git commit --amend --no-edit --allow-empty"
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
  nums="$1"
  while [ -z "${nums}" ]; do
    read -r -p "Please enter number of commits to squash: " nums
  done
  commandPrint "git rebase -i Head~${nums}"
}

gitScriptSquashAllCommits() {
  git reset $(git merge-base develop $(git branch --show-current))
  git add -A
  git commit -m "Squash Commit"
}

##################### Git rebase #######################
gitScriptRebase() {
  gitScriptFetch
  commandPrint "git rebase origin/$1"
}