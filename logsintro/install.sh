#!/bin/bash
set -e
installdir=$PWD


if [ -n "$1" ]; then
    apikey=$1
fi

if [ ! $apikey ]; then
  if [ ! $dd_upgrade ]; then
    printf "\033[31mAPI key not available in the first command line arg.\033[0m\n"
    exit 1;
  fi
fi

if [ ! $(command -v curl) ]; then
    printf "\033[31mIt seems that curl is not installed on this machine. Please follow the instructions at https://github.com/DataDog/TrainingEnvironment to install the environment. \n\nThe API Key you will want to use is $apikey\033[0m\n"
    exit 1;

fi
printf "This script will download the Training Environment for Introduction to Logs in Datadog. It is installed into the current directory:\n\n    $installdir\n\n
If you want to move this to a different directory, the easiest way is to delete the directory \nand run the command on the Learning Center again.\033[0m\n\n"


printf "\033[31mDownloading the Training Environment from Github \033[0m\n"
outputfilename=TrainingEnvironment-$(date +%m%Y%d)
curl -L -J https://github.com/DataDog/TrainingEnvironment/archive/master.zip -o $outputfilename
printf "\033[31mUnzipping the Training Environment \033[0m\n"
unzip -q $outputfilename
mv TrainingEnvironment-master/logs/* .
rm -rf TrainingEnvironment-master

printf "\033[31mConfiguring... \033[0m\n"

printf "DD_API_KEY=$apikey\n"> apikey.env

if [ ! $(command -v docker-compose) ]; then
    printf "You will need to install Docker and docker-compose to get the system up and running.\nGo to https://www.docker.com/get-started for more on doing that."
fi
printf "Installation complete\nReturn to $installdir whenever you need to run the Docker-based environment. \n\nThe key commands to remember are: \n\n\033[31docker-compose up\033[0m - launches the docker environment\n"


