

source .env


if [ ! -d $WEBROOTS_FOLDER ]
then


else

fi


if [ ! -d $WEBROOTS_FOLDER/$ENVIRONMENT ]
then


else

fi

mkdir $WEBROOTS_FOLDER/$ENVIRONMENT/$timestamp


currentWebroot=$WEBROOTS_FOLDER/$ENVIRONMENT/$timestamp
export currentWebroot
