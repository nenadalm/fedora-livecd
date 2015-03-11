
%include vendor/spin-kickstarts/fedora-live-base.ks
%include vendor/spin-kickstarts/fedora-live-minimization.ks
%include basic.ks

part / --size 8000 --fstype ext4

%packages
ansible
%end

%post --erroronfail
git clone http://github.com/nenadalm/fedora-livecd /tmp/fedora-livecd --depth=1 --branch=ansible
cd /tmp/fedora-livecd/ansible
ansible-playbook playbook.yml --connection=local -vvvv
%end

