Vagrant.configure do |config|
  config.vm.boot_timeout = 400 # seconds
  config.vm.box_check_update = false
end

#config.vm.synced_folder "/users/suresh/work","/work",rsync: true
#config.vm.provision "shell", inline: <<-SHELL
#echo export GOPATH=/work > /etc/profile.d/gopath.sh
#SHELL

#if needed for disabling vagrant-vbguest
#  config.vbguest.auto_update = false
# config.vbguest.no_remote = true

#If we need to control the mapping of current folder to inside of the vagrant 
#config.vm.synced_folder '.', '/vagrant', type: 'nfs'
#config.vm.synced_folder '.', '/vagrant', disabled: true
