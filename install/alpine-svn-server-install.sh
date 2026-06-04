#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: jofrev
# License: MIT | https://github.com/community-scripts/ProxmoxVED/raw/main/LICENSE
# Source: https://subversion.apache.org/

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing SVN Server"
$STD apk add --no-cache subversion
msg_ok "Installed SVN Server"

msg_info "Configuring svnserve"
mkdir -p /srv/svn
cat <<EOF >/etc/conf.d/svnserve
SVNSERVE_OPTS="--root /srv/svn"
EOF
$STD rc-update add svnserve default
$STD rc-service svnserve start
msg_ok "Configured svnserve"

motd_ssh
customize
cleanup_lxc
