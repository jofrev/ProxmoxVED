#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVED/main/misc/build.func)
# Copyright (c) 2021-2026 community-scripts ORG
# Author: jofrev
# License: MIT | https://github.com/community-scripts/ProxmoxVED/raw/main/LICENSE
# Source: https://subversion.apache.org/

APP="Alpine-SVN-Server"
var_tags="${var_tags:-alpine;versioncontrol}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-256}"
var_disk="${var_disk:-1}"
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
  if [[ ! -f /usr/bin/svnserve ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  msg_info "Updating ${APP}"
  $STD apk -U upgrade
  msg_ok "Updated ${APP}"

  msg_info "Restarting svnserve"
  $STD rc-service svnserve restart
  msg_ok "Restarted svnserve"
  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} svnserve is listening on:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}svn://${IP}:3690${CL}"
echo -e "${INFO}${YW} Create your first repository with:${CL}"
echo -e "${TAB}${BGN}svnadmin create /srv/svn/<name>${CL}"
