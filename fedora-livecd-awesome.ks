
%include vendor/spin-kickstarts/fedora-live-base.ks
%include vendor/spin-kickstarts/fedora-live-minimization.ks
%include basic.ks
%include fedora-awesome-packages.ks
%include phpfarm.ks

part / --size 8000 --fstype ext4

%post
cat >> /etc/skel/.bash_profile <<EOF
[[ -z \$DISPLAY && \$XDG_VTNR -eq 1 ]] && exec startx
EOF

cat >> /etc/skel/.xinitrc <<EOF
#!/usr/bin/env bash

set -eu

exec awesome --no-argb
EOF
%end

