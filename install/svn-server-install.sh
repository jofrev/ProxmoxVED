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
$STD apt install -y subversion
msg_ok "Installed SVN Server"

msg_info "Configuring svnserve"
mkdir -p /srv/svn
cat <<EOF >/etc/systemd/system/svnserve.service
[Unit]
Description=Subversion Server
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/svnserve --daemon --foreground --root /srv/svn
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now svnserve
msg_ok "Configured svnserve"

motd_ssh
customize
cleanup_lxc
