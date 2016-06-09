
%include vendor/spin-kickstarts/fedora-live-base.ks
%include vendor/spin-kickstarts/fedora-live-minimization.ks

repo --name=phpfarm --baseurl=https://copr-be.cloud.fedoraproject.org/results/nenadalm/phpfarm/fedora-$releasever-$basearch/
repo --name=nenadalm-config --baseurl=https://copr-be.cloud.fedoraproject.org/results/nenadalm/nenadalm-config/fedora-$releasever-$basearch/
repo --name=nenadalm-packages --baseurl=https://copr-be.cloud.fedoraproject.org/results/nenadalm/nenadalm-packages/fedora-$releasever-$basearch/

part / --size 8000 --fstype ext4

%packages
nenadalm-packages
%end

%post --erroronfail
cat > /etc/resolv.conf <<EOF
nameserver 8.8.8.8

EOF
%end

