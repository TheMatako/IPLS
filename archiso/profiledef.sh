#!/usr/bin/env bash
# shellcheck disable=SC2034  # variables are consumed by mkarchiso, which sources this file
iso_name="ipls"
iso_label="IPLS_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="IPLS Project <https://github.com/TheMatako/IPLS>"
iso_application="ISIMA Purple Linux System"
iso_version="${IPLS_VERSION:-dev}"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
)
