#!/usr/bin/env bash

########################
# Script to create a brief sign in script for AWS
########################
# Script will ask for profile name used to sign in
# then will check if a file alread exists if not it will create the file to sign in.
#
# Finally it will add an alias to the .zshrc file
# at the moment it will only append to the very end of the file
#

set -euo pipefail

#Variables

profile_name=""
sign_script_save_location="${HOME}/Documents/Sign-In-Scripts"
zshrc_file_path="${HOME}/.zshrc"
alias_chosen_name=""

read -p "Profile Name: " profile_name

filepath_and_name="${sign_script_save_location}/${profile_name}.sh"

if [[ ! -d $sign_script_save_location ]]; then
    mkdir -p $sign_script_save_location 
    touch $filepath_and_name
elif [[ ! -f $filepath_and_name ]]; then
    touch $filepath_and_name
else
    echo "This file seems to exist - check if it works and delete if needed"
    exit 1
fi

echo "export AWS_PROFILE=${profile_name}" >> $filepath_and_name
echo "aws sso login --profile ${profile_name}" >> $filepath_and_name

read -p "Please choose a name for the Alias to sign into chosen profile: " alias_chosen_name

if [[ -f "${HOME}/.zshrc" ]]; then
    cat <<EOF >> $zshrc_file_path


##########
# Alias to sign into aws for $profile_name
##########

alias ${alias_chosen_name}="source ${filepath_and_name}"

EOF
else
    echo "Cannot find .zshrc file, if you're not using zsh I haven't thought that far ahead"
    exit 1
fi