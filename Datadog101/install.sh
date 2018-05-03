#!/bin/bash
set -e
installdir=$PWD


if [ -n "$1" ]; then
    apikey=$1
fi

if [ ! $apikey ]; then
  # if it's an upgrade, then we will use the transition script
  if [ ! $dd_upgrade ]; then
    printf "\033[31mAPI key not available in the first command line arg.\033[0m\n"
    exit 1;
  fi
fi

if [ ! $(command -v curl) ]; then
    printf "\033[31mIt seems that curl is not installed on this machine. Please follow the instructions at https://github.com/DataDog/TrainingEnvironment to install the environment. \n\nThe API Key you will want to use is $apikey\033[0m\n"
    exit 1;

fi
printf "This script will download the Training Environment. It is installed into the current directory:\n\n    $installdir\n\
Feel free to move this to a different directory, but be sure to \nrun the update.sh script to update the location of the API key definition file.\033[0m"


printf "\033[31mDownloading the Training Environment from Github \033[0m\n"
outputfilename=TrainingEnvironment-$(date +%m%Y%d)
curl -L -J https://github.com/DataDog/TrainingEnvironment/archive/master.zip -o $outputfilename
printf "\033[31mUnzipping the Training Environment \033[0m\n"
unzip -q $outputfilename
mv TrainingEnvironment-master/Datadog101/* .
rm -rf TrainingEnvironment-master

printf "\033[31mConfiguring... \033[0m\n"
sed -i "" "s|source: '~/.ddtraining.sh'|source: '$installdir/.ddtraining.sh'|g" Vagrantfile
printf "#!/bin/bash\nDD_API_KEY='$apikey'\n"> .ddtraining.sh

sedsourceline="s|source: '$installdir/.ddtraining.sh'|source: '$PWD/.ddtraining.sh'|g"
printf "sed -i '' '$sedsourceline' Vagrantfile" > update.sh
chmod +x update.sh

if [ ! $(command -v vagrant) ]; then
    printf "You will need to install Vagrant to get the system up and running.\nGo to http://vagrantup.com for more on doing that."
fi
printf "Installation complete\nReturn to $installdir whenever you need to run the Vagrant-based environment. \nThe key commands to remember are: \n\n\033[31mvagrant up\033[0m - launches the vagrant environment\n\033[31mvagrant halt\033[0m - stops the vagrant environment\n\033[31mvagrant destroy\033[0m - destroys the vagrant environment, but a vagrant up brings it all back\n\nI often run the single line: \033[31mvagrant halt;vagrant destroy -f;vagrant up\033[0m to restart everything."


