#!/bin/bash
set -e
installdir=$PWD


if [ ! $(command -v curl) ]; then
    printf "\033[31mIt seems that curl is not installed on this machine. Please follow the instructions at https://github.com/DataDog/TrainingEnvironment to install the environment. \n\nThe API Key you will want to use is $apikey\033[0m\n"
    exit 1;

fi
printf "This script will download the Training Environment for Autodiscovery with Kubernetes. It is installed into the current directory:\n\n    $installdir\n\n
If you want to move this to a different directory, the easiest way is to delete the directory \nand run the command on the Learning Center again.\033[0m\n\n"


printf "\033[31mDownloading the Training Environment from Github \033[0m\n"
outputfilename=TrainingEnvironment-$(date +%m%Y%d)
curl -L -J https://github.com/DataDog/TrainingEnvironment/archive/master.zip -o $outputfilename
printf "\033[31mUnzipping the Training Environment \033[0m\n"
unzip -q $outputfilename
mv TrainingEnvironment-master/k8sautodiscovery/* .
rm -rf TrainingEnvironment-master
