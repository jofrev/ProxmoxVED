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

msg_info "Installing SVN Web Server"
$STD apk add --no-cache apache2 apache2-utils apache2-svn subversion
msg_ok "Installed SVN Web Server"

msg_info "Configuring Apache SVN"
mkdir -p /srv/svn /etc/svn
chown -R apache:apache /srv/svn
cat <<'EOF' >/etc/apache2/conf.d/svn.conf
LoadModule dav_module modules/mod_dav.so
LoadModule dav_fs_module modules/mod_dav_fs.so
LoadModule dav_svn_module modules/mod_dav_svn.so
LoadModule authz_svn_module modules/mod_authz_svn.so

<Location /svn>
  DAV svn
  SVNParentPath /srv/svn
  SVNListParentPath on

  AuthType Basic
  AuthName "Subversion Repository"
  AuthUserFile /etc/svn/passwd

  <LimitExcept GET PROPFIND OPTIONS REPORT>
    Require valid-user
  </LimitExcept>
</Location>
EOF
touch /etc/svn/passwd
$STD rc-update add apache2 default
$STD rc-service apache2 start
msg_ok "Configured Apache SVN"

motd_ssh
customize
cleanup_lxc
