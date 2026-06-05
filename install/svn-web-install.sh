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
$STD apt install -y apache2 apache2-utils libapache2-mod-svn
msg_ok "Installed SVN Web Server"

msg_info "Configuring Apache SVN"
mkdir -p /srv/svn /etc/svn
chown -R www-data:www-data /srv/svn
cat <<'EOF' >/etc/apache2/conf-available/svn.conf
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
$STD a2enmod dav dav_svn authz_svn
$STD a2enconf svn
systemctl enable -q apache2
systemctl restart apache2
msg_ok "Configured Apache SVN"

motd_ssh
customize
cleanup_lxc
