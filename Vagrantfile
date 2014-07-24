root      = File.expand_path("..", __FILE__)
solo_json = File.join(root, "node.json")

Vagrant.configure("2") do |config|

  # Install required plugins
  plugins = ['vagrant-omnibus', "vagrant-berkshelf --plugin-version '2.0.0.rc3'"]
  # Vagrant does not detect new plugins right away. In order to get around this, if we 
  # have added any plugins then we simply set reload to true and tell the user to re-run
  # the vagrant command.
  reload = false
  plugins.each do |plugin|
    # Split so that we can specify plugin versions in the plugins array without breaking the script
    if !Vagrant.has_plugin?(plugin.split("--").first.strip)
      reload = true
      puts "Installing #{plugin}..."
      print %x(vagrant plugin install #{plugin})
      if !$?.success?
        puts "Plugin installation failed. Please fix any errors above and try again."
        exit
      end
    end 
  end
  if reload
    puts "Done installing plugins, however they cannot be accessed until the vagrant command is re-run."
    puts "Please re-run your vagrant command..."
    exit
  end

  # Install the latest version of Chef (uses https://github.com/schisamo/vagrant-omnibus)
  config.omnibus.chef_version = :latest

  config.vm.box = "hashicorp/precise64"
  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true

  # https://github.com/cloudbau/vagrant-openstack-plugin this block for overriding of the default box
  # if you are using the openstack provider.
  # vagrant box add dummy https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box to add box.
  config.vm.provider :openstack do |os,override|
    override.vm.box = "dummy"
    override.vm.box_url = "https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box"
    # Set the server name to something more specific in openstack.
    os.server_name = "rails-app-cookbook"
    os.security_groups = ["default","web-server"]
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, 
      "--memory", "1024", 
      "--cpus", "2",
      "--ioapic", "on"
    ]
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "."
    chef.json = {
        "rails-app" => {
            "name" => "registration-app",
            "ssl" => false,
            "repository" => "https://github.com/mitre-cyber-academy/registration-app.git"
        }
    }
    chef.run_list = [
        "recipe[rails-app::default]"
    ]
  end
end
