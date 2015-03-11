%packages
ansible
%end

%post --erroronfail
git clone http://github.com/nenadalm/spin-kickstarts /tmp/spin-kickstarts
%end

