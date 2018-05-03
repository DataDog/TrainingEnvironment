#!/bin/bash
sed -i '' 's|source: "CURRENT/.ddtraining.sh"|source: "\$PWD/.ddtraining.sh"|g' Vagrantfile
printf "sed -i '' 's|source: \'CURRENT/.ddtraining.sh\'|source: \'\$PWD/.ddtraining.sh\'|g' update.sh"