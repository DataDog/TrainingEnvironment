#!/bin/bash
echo WORK IN PROGRESS
set -e
logfile="trainingenvironment-install.log"
installdir="$HOME/DatadogTrainingEnvironment"



function on_error() {
    printf "\033[31m$ERROR_MESSAGE
It looks like you hit an issue when trying to install the Datadog Training Environment.
Troubleshooting and basic usage information for the Training Environment are available at:
    https://github.com/DataDog/TrainingEnvironment/
If you're still having problems, please send an email to support@datadoghq.com
.\n\033[0m\n"
}

if [ -n "$DD_API_KEY" ]; then
    apikey=$DD_API_KEY
fi

if [ ! $apikey ]; then
  # if it's an upgrade, then we will use the transition script
  if [ ! $dd_upgrade ]; then
    printf "\033[31mAPI key not available in DD_API_KEY environment variable.\033[0m\n"
    exit 1;
  fi
fi

if [ ! $(command -v curl) ]; then
    printf "\033[31mIt seems that curl is not installed on this machine. Please follow the instructions at https://github.com/DataDog/TrainingEnvironment to install the environment. \n\nThe API Key you will want to use is $apikey\033[0m\n"
    exit 1;

fi
printf "This script will download the Training Environment. By default 
the environment will be installed in:\n\n    $installdir\n\n
If this is OK, press Enter here. Otherwise type the directory you 
would prefer to use.\n\033[31mInstall the environment in [$installdir]\033[0m: "
read newinstalldir
workingdir=0
while [ $workingdir -ne 1 ]; do
  newinstalldir=${newinstalldir/"~"/$HOME}
  if ((${#newinstalldir} > 0));then
    if [ -d $newinstalldir ]; then
      installdir=$newinstalldir
      workingdir=1
    else
      printf "That directory doesn't exist. Try again, or press enter to accept the default of \n\n    $installdir\n\033[31mInstall the environment in [$installdir]\033[0m: "
      read newinstalldir
    fi
  else 
    workingdir=1
    if [ ! -d $installdir ]; then
      mkdir $installdir
    fi
  fi
done

origwd=$PWD
echo $PWD
cd $installdir
echo $PWD
curl -L -J -O https://github.com/DataDog/TrainingEnvironment/archive/master.zip
unzip master.zip

cd $origwd
echo $PWD
