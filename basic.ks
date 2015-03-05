# nameserver
%post --erroronfail
cat > /etc/resolv.conf <<EOF
nameserver 8.8.8.8

EOF
%end

