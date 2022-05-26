
source .env

if [ "$SCRIPT_LOGGING" = "ON" ]
then

  npm --cwd $REPO_ROOT install 2>&1 >> $CURRENT_LOG_FILE
  (cd $REPO_ROOT; gridsome build 2>&1 >> $CURRENT_LOG_FILE; exit $?)

  if [[ $? -ne 0 ]];
  then

  else

  fi

  cp -r $BUILD_DIST $WEBROOTS_FOLDER/$ENVIRONMENT/$timestamp

else

  npm --cwd $REPO_ROOT install

  (cd $REPO_ROOT; gridsome build; exit $?)

  if [[ $? -ne 0 ]];
  then

  else

  fi

fi

ln -sfn $WEBROOTS_FOLDER/$ENVIRONMENT/$timestamp/dist/ $MAIN_WEBROOT

