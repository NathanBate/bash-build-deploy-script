#!/bin/bash

base_path="$(dirname "$0")"

cd $base_path

if [ -e .env ]
then

else

  exit 1
fi

source $base_path/.env

timestamp=`date +'%Y-%m-%d___%H-%M-%S'`
export timestamp

if [ "$SCRIPT_LOGGING" = "ON" ]
then

  if [ ! -d $LOG_FILE_DIRECTORY  ]
  then
    mkdir $LOG_FILE_DIRECTORY

  fi

  CURRENT_LOG_FILE=90North-Deploy-Log-$timestamp.log
  CURRENT_LOG_FILE=$LOG_FILE_DIRECTORY$CURRENT_LOG_FILE

  export CURRENT_LOG_FILE
fi
(
  numberOfLogFilesToKeep=744
  cd $LOG_FILE_DIRECTORY

  shopt -s dotglob nullglob
  a=(*)
  currentNumberOfLogFiles=${#a[@]}

  if [ $currentNumberOfLogFiles -gt $numberOfLogFilesToKeep ]
  then

    numberOfLogFilesToRemove=`expr $currentNumberOfLogFiles - $numberOfLogFilesToKeep`

    ls -dt */ | tail -n $numberOfLogFilesToRemove | xargs rm -rf

  else


  fi

)

(
  cd $REPO_ROOT
  if git diff-index --quiet HEAD --; then
    exit 1
  fi
)

if [[ $? -ne 0 ]];
then
  if [ "$SCRIPT_LOGGING" = "ON" ]
  then

  else

  fi
  exit 0
fi

if [ "$SCRIPT_LOGGING" = "ON" ]
then
  ./setup-webroot.sh >> $CURRENT_LOG_FILE
else
  ./setup-webroot.sh
fi

export currentWebroot

if [ "$SKIP_BUILD_STATIC_SITE" = "NO" ]
then

  if [ "$SCRIPT_LOGGING" = "ON" ]
  then

    ./build-static-site.sh >> $CURRENT_LOG_FILE
  else
    ./build-static-site.sh
  fi

fi

if [[ $? -ne 0 ]];
then

  exit 1
fi

if [ "$SCRIPT_LOGGING" = "ON" ]
then
  ./clean-webroots.sh >> $CURRENT_LOG_FILE
else
  ./clean-webroots.sh
fi

(cd $REPO_ROOT; git add -A; exit $?)

if [[ $? -ne 0 ]];
then
  if [ "$SCRIPT_LOGGING" = "ON" ]
  then

  else

  fi

  exit 1
fi

(cd $REPO_ROOT; git commit -am"auto adding post updates from Statamic"; exit $?)

if [[ $? -ne 0 ]];
then
  if [ "$SCRIPT_LOGGING" = "ON" ]
  then

  else

  fi

  exit 1
fi

(cd $REPO_ROOT; git push origin master; exit $?)

if [[ $? -ne 0 ]];
then
  if [ "$SCRIPT_LOGGING" = "ON" ]
  then
    printf "\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n" >> $CURRENT_LOG_FILE
    printf "There was a problem pushing to the master branch" >> $CURRENT_LOG_FILE
    printf "\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n" >> $CURRENT_LOG_FILE
  else
    printf "\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
    printf "There was a problem pushing to the master branch"
    printf "\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n"
  fi

  exit 1
fi