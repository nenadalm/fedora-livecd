
%include vendor/spin-kickstarts/fedora-live-base.ks
%include vendor/spin-kickstarts/fedora-live-minimization.ks

part / --size 8000 --fstype ext4

%packages
ntpdate
%end

%post --erroronfail
cat > /etc/resolv.conf <<EOF
nameserver 8.8.8.8

EOF

ntpdate pool.ntp.org

dnf check-update
dnf upgrade -y
dnf distro-sync -y

dnf copr enable nenadalm/phpfarm
dnf copr enable nenadalm/nenadalm-config
dnf copr enable nenadalm/nenadalm-packages
dnf install -y nenadalm-packages
%end

