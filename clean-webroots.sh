
source .env

if [ ! -d $WEBROOTS_FOLDER/$ENVIRONMENT ]
then

  exit 1
fi


(
  cd $WEBROOTS_FOLDER/$ENVIRONMENT

  shopt -s dotglob nullglob
  a=(*)
  currentNumberOfWebroots=${#a[@]}

  if [ $currentNumberOfWebroots -gt $BACKUP_WEBROOTS_COUNT ]
  then
    numberOfFilesToRemove=`expr $currentNumberOfWebroots - $BACKUP_WEBROOTS_COUNT`

    ls -dt */ | tail -n $numberOfFilesToRemove | xargs rm -rf

  else


  fi
)
