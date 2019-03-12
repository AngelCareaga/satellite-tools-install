#!/bin/bash

## ================= LOADING CONFIGURATIONS ================= #
echo " ======= LOADING CONFIGURATIONS ======"
. "utils/parse_yaml.sh"
eval $(parse_yaml config-satellite-tools.yml "cfg_")

## ================= FUNCTIONS SUBSCRIPTION ================= #

subscriptionRegisterAttach(){
    echo " ======= CONFIGURE SUBSCRIPTION ========"
    echo ""
    echo " ======= REGISTER ========"
    subscription-manager register --username=$cfg_satellite_subs_parent_user --password=$cfg_satellite_subs_parent_pass
    echo " =======  ATTACH  ========"
    subscription-manager attach --pool=$cfg_satellite_subs_parent_pool
}

disableAllRepos(){
    echo " ======= DISABLE ALL REPOS ========"
    subscription-manager repos --disable="*"
}

disableReposCFG(){
    echo " ======= DISABLE REPOS CFG ========"
    subscription-manager repos --disable="*"
}

enableReposCFG(){
    echo " ======= ENABLE REPOS CFG ========"
    IFS=';' read -r -a listRepos <<< "$cfg_list_repos"
    for repo in "${listRepos[@]}"
    do
        subscription-manager repos --enable=$repo
    done
}

setReleaseUnset(){
    echo " ======= RELEASE UNSET ========"
    subscription-manager release --unset
}

removeAndUnRegisterSubcription(){
    echo " ======= REMOVING SUBSCRIPTION ========"
    subscription-manager remove --all
    echo " ======= UNREGISTER SUBSCRIPTION ========"
    subscription-manager unregister
}