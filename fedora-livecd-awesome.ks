
%include vendor/spin-kickstarts/fedora-live-base.ks
%include vendor/spin-kickstarts/fedora-live-minimization.ks

part / --size 8000 --fstype ext4

%packages
ansible
ntpdate
git
%end

%post --erroronfail
cat > /etc/resolv.conf <<EOF
nameserver 8.8.8.8

EOF

ntpdate pool.ntp.org

dnf check-update
dnf upgrade -y
dnf distro-sync -y

git clone http://github.com/nenadalm/fedora-livecd /tmp/fedora-livecd --depth=1 --branch=develop
cd /tmp/fedora-livecd/ansible
PATH=$PATH:/usr/bin:/usr/sbin ansible-playbook playbook.yml --connection=local -vvvv

dnf copr enable nenadalm/phpfarm
dnf copr enable nenadalm/nenadalm-config
dnf install -y phpfarm nenadalm-config
%end

