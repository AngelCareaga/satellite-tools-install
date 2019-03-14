#!/bin/bash

## Load configurations
echo " ======= LOADING CONFIGURATIONS ======"
. "utils/parse_yaml.sh"
eval $(parse_yaml config-satellite-tools.yml "cfg_")

echo " ======= LOADED CONFIGURATIONS ======"
echo ""

echo "satellite_subs_parent_user: $cfg_satellite_subs_parent_user"
echo "satellite_subs_parent_pass $cfg_satellite_subs_parent_pass"
echo "satellite_subs_parent_pool $cfg_satellite_subs_parent_pool"

echo "list_repos $cfg_list_repos"

echo "scenario $cfg_scenario"
echo "fn_initial_organization $cfg_fn_initial_organization"
echo "fn_initial_location $cfg_fn_initial_location"
echo "fn_admin_username $cfg_fn_admin_username"
echo "fn_admin_password $cfg_fn_admin_password"
echo "fn_proxy_dns_managed $cfg_fn_proxy_dns_managed"
echo "fn_proxy_dhcp_managed $cfg_fn_proxy_dhcp_managed"

echo "load_manifest_subs $cfg_load_manifest_subs"
echo "name_manifest_subs $cfg_name_manifest_subs"
echo ""

. "private/configure-server.sh"
. "private/configure-subscription.sh"
. "private/configure-yum.sh"

echo " ======= INSTALLING ========"

configureFirewallCMD # Configuration ports in firewall

## removeAndUnRegisterSubcription # Optional for remove previous subscription
subscriptionRegisterAttach # Subscription and Attach
disableAllRepos # Disable default repos
enableReposCFG # Enable repos for Satellite
setReleaseUnset # Ensure that Red Hat Subscription Manager is not set to use a specific operating system release

yumPrepare # Prepare YUM 
yumInstallSatellite # Install Satellite Package
yumInstallConfigureChronydAndSos # Install chrony & sos Package


# ======= SATELLITE INSTALLER =======
satellite-installer --scenario $cfg_scenario \
    --foreman-initial-organization $cfg_fn_initial_organization \
    --foreman-initial-location $cfg_fn_initial_location \
    --foreman-admin-username $cfg_fn_admin_username \
    --foreman-admin-password $cfg_fn_admin_password \
    --foreman-proxy-dns-managed=$cfg_fn_proxy_dns_managed \
    --foreman-proxy-dhcp-managed=$cfg_fn_proxy_dhcp_managed

if [ $cfg_load_manifest_subs = "true" ]; then
    hammer subscription upload \
    --file ~/$cfg_name_manifest_subs \
    --organization $cfg_fn_initial_organization
    else
    echo " ======= INSTALL MANIFEST IN CONSOLE ========"
fi


