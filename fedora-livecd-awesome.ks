
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

git clone http://github.com/nenadalm/fedora-livecd /tmp/fedora-livecd --depth=1 --branch=master
cd /tmp/fedora-livecd/ansible
PATH=$PATH:/usr/bin:/usr/sbin ansible-playbook playbook.yml --connection=local -vvvv
%end

