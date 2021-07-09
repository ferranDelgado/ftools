#!/bin/bash
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

versions_folder="$HOME/.terraform.versions"
version_folder="/dev/null"

print_error() {
    printf "${RED}ERROR: $1 ${NC}\n"
}

list_versions() {
    curl https://releases.hashicorp.com/terraform/ -s | grep -o 'terraform_[0-9.]*<' | grep -o '[0-9.]*' | sort | uniq
}

check_version_exists() {
    echo "Checking version $1"
    if ! curl https://releases.hashicorp.com/terraform/ -s | grep -o 'terraform_[0-9.]*<' | grep -o '[0-9.]*' | sort | uniq | grep "$1" -q; then        
        print_error "version [$1] not found"
        exit 1
    fi
}

download() {
    version=$1
    url="https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip"
    # echo "$url"
    wget $url -P $version_folder
    unzip -o "${version_folder}/*.zip" -d $version_folder
    # ls "${version_folder}/*"
    find $version_folder -name "*.zip" -type f -delete
}

link() {
    # unlink "${versions_folder}current"
    run_arg "rm ${versions_folder}/current"
    run_arg "ln -s ${version_folder}/terraform ${versions_folder}/current"
}

link_bin() {
    printf "\nRemember to creat link in the bin folder \n\t ${YELLOW}ln -s ${versions_folder}/current /usr/bin/terraform ${NC}\n"    
}

run_arg() {
    printf "${RED} Cmd: ${NC}$1\n"
    eval $1
}

install() {
    version=$1
    check_version_exists $version
    version_folder="${versions_folder}/$version"
    echo $version_folder
    if [ -d $version_folder ] 
    then
        echo "Version already downloaded $version_folder" 
    else
        echo "Creating version folder $version_folder" 
        mkdir -p $version_folder
        download $version
    fi
    link
    link_bin
}

help() {
    printf "> tfswitch.tf [args] \n"
    printf "> Possible arguments: \n"
    printf "\tlist\t\t\t-> print all possible versions\n"
    printf "\tinstall <version>\t-> install version\n"
}

if [[ $# -lt 1 ]]; then
    echo "ERROR: Illegal number of parameters"
    help
    exit 2
fi


case $1 in
list)
    echo "Listing all possible versions"
    list_versions
    ;;

install)
    install $2
    ;;

*) 
    echo "ERROR: unknown argument $1"
    help
    ;;
esac