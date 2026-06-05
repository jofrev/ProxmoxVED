#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVED/main/misc/build.func)
# Copyright (c) 2021-2026 community-scripts ORG
# Author: jofrev
# License: MIT | https://github.com/community-scripts/ProxmoxVED/raw/main/LICENSE
# Source: https://subversion.apache.org/

APP="Alpine-SVN-Web"
var_tags="${var_tags:-alpine;versioncontrol}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-256}"
var_disk="${var_disk:-4}"
var_os="${var_os:-alpine}"
var_version="${var_version:-3.23}"
var_arm64="${var_arm64:-no}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  if [[ ! -f /etc/apache2/conf.d/svn.conf ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  msg_info "Updating ${APP}"
  $STD apk -U upgrade
  msg_ok "Updated ${APP}"

  msg_info "Restarting Apache"
  $STD rc-service apache2 restart
  msg_ok "Restarted Apache"
  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Browse repositories at:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}/svn${CL}"
echo -e "${INFO}${YW} Add a commit user with:${CL}"
echo -e "${TAB}${BGN}htpasswd /etc/svn/passwd <username>${CL}"
echo -e "${INFO}${YW} Create a repository with:${CL}"
echo -e "${TAB}${BGN}svnadmin create /srv/svn/<name>${CL}"
echo -e "${INFO}${YW} Then set ownership so Apache can write to it:${CL}"
echo -e "${TAB}${BGN}chown -R apache:apache /srv/svn/<name>${CL}"
