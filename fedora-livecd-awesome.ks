
%include vendor/spin-kickstarts/fedora-live-base.ks
%include vendor/spin-kickstarts/fedora-live-minimization.ks

repo --name=phpfarm --baseurl=https://copr-be.cloud.fedoraproject.org/results/nenadalm/phpfarm/fedora-$releasever-$basearch/ --install
repo --name=nenadalm-config --baseurl=https://copr-be.cloud.fedoraproject.org/results/nenadalm/nenadalm-config/fedora-$releasever-$basearch/ --install
repo --name=nenadalm-packages --baseurl=https://copr-be.cloud.fedoraproject.org/results/nenadalm/nenadalm-packages/fedora-$releasever-$basearch/ --install

part / --size 8000 --fstype ext4

%packages
nenadalm-packages
%end

%post --erroronfail
cat > /etc/resolv.conf <<FOE
nameserver 8.8.8.8

FOE

sudo -u phpfarm /opt/phpfarm/src/main.sh

cat >> /etc/init.d/livesys <<EOF
# autologin
cp /lib/systemd/system/getty@.service /etc/systemd/system/autologin@.service
sed -i 's/\/sbin\/agetty/\0 --autologin liveuser/' /etc/systemd/system/autologin@.service
sed -i 's/Restart=always/Restart=no/' /etc/systemd/system/autologin@.service
ln -fs /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
systemctl daemon-reload
systemctl getty@tty1 restart
EOF
%end

