#!/bin/bash
set -e
installdir="$HOME/DatadogTrainingEnvironment"


if [ -n "$TRAINING_API_KEY" ]; then
    apikey=$TRAINING_API_KEY
fi

if [ ! $apikey ]; then
  # if it's an upgrade, then we will use the transition script
  if [ ! $dd_upgrade ]; then
    printf "\033[31mAPI key not available in TRAINING_API_KEY environment variable.\033[0m\n"
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
      printf "\033[31mCreating the directory: $installdir\033[0m\n"
      mkdir $installdir
    fi
  fi
done

origwd=$PWD
cd $installdir

printf "\033[31mDownloading the Training Environment from Github \033[0m\n"
curl -L -J -O https://github.com/DataDog/TrainingEnvironment/archive/master.zip
printf "\033[31mUnzipping the Training Environment \033[0m\n"
unzip -q TrainingEnvironment-master.zip
mv TrainingEnvironment-master/* .
rm TrainingEnvironment-master/.gitignore
rmdir TrainingEnvironment-master
printf "\033[31mConfiguring... \033[0m\n"
sed -i "" "s|source: '~/.ddtraining.sh'|source: '$PWD/.ddtraining.sh'|g" Datadog101/Vagrantfile
printf "#!/bin/bash\nDD_API_KEY='$apikey'\n"> .ddtraining.sh

if [ ! $(command -v vagrant) ]; then
    printf "You will need to install Vagrant to get the system up and running.\nGo to http://vagrantup.com for more on doing that."
fi
printf "Installation complete\nReturn to $installdir whenever you need to run the Vagrant-based environment. \nThe key commands to remember are: \n\n\033[31mvagrant up\033[0m - launches the vagrant environment\n\033[31mvagrant halt\033[0m - stops the vagrant environment\n\033[31mvagrant destroy\033[0m - destroys the vagrant environment, but a vagrant up brings it all back\n\nI often run the single line: \033[31mvagrant halt;vagrant destroy -f;vagrant up\033[0m to restart everything."

cd $origwd

