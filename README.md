rails-app Cookbook
==================

This is a cookbook that allows for plug-and-play creation of an application, using only a repository. The recipe takes care of creating the database, installing required gems via bundler, and creating an nginx stack to serve your site.

Requirements
------------
This recipe has been tested on Ubuntu 12.04 and Ubuntu 14.04. 

Attributes
----------

#### rails-app::default attributes
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>["rails-app"]["name"]</tt></td>
    <td>String</td>
    <td>Application name</td>
    <td><tt>"default"</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["address"]</tt></td>
    <td>String</td>
    <td>IP address or domain name of the server.</td>
    <td><tt>node['fqdn']</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["action"]</tt></td>
    <td>String</td>
    <td>What to do with the app, options are :deploy and :force_deploy, for more info see the chef application cookbook.</td>
    <td><tt>:deploy</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["path"]</tt></td>
    <td>String</td>
    <td>Path where the application should be stored on the server.</td>
    <td><tt>"/opt/#{node["rails-app"]["name"]}"</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["deploy_key"]</tt></td>
    <td>String</td>
    <td>An optional string if you wish to pull your code from a private repository, make sure to replace all newlines with \n if you use this.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["repository"]</tt></td>
    <td>String</td>
    <td>Repository to pull your code from.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["revision"]</tt></td>
    <td>String</td>
    <td>Revision of your code to pull.</td>
    <td><tt>"master"</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["environment"]</tt></td>
    <td>String</td>
    <td>Rails environment to deploy.</td>
    <td><tt>"production"</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["db_host"]</tt></td>
    <td>String</td>
    <td>Tells rails where the database is located.</td>
    <td><tt>"127.0.0.1"</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["db_adapter"]</tt></td>
    <td>String</td>
    <td>Tells rails the database adapter to use.</td>
    <td><tt>"postgresql"</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["db_name"]</tt></td>
    <td>String</td>
    <td>Tells rails the database to use.</td>
    <td><tt>"rails-app-#{default["rails-app"]["name"]}"</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["db_username"]</tt></td>
    <td>String</td>
    <td>Tells rails who to login as.</td>
    <td><tt>node["rails-app"]["name"]</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["db_password"]</tt></td>
    <td>String</td>
    <td>Tells rails the database password.</td>
    <td><tt>node["rails-app"]["db_password"] || ::SecureRandom.base64(24)</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["bundler"]</tt></td>
    <td>Boolean</td>
    <td>Should I use bundler?</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["bundle_command"]</tt></td>
    <td>String</td>
    <td>The path to bundler on your system.</td>
    <td><tt>"#{node["rbenv"]["root_path"]}/shims/bundle"</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["bundler_deployment"]</tt></td>
    <td>Boolean</td>
    <td>Should bundler use deployment mode?</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["migrate"]</tt></td>
    <td>Boolean</td>
    <td>Should the rails app have migrations run on it?</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["migration_command"]</tt></td>
    <td>String</td>
    <td>What is the command to migrate the database?</td>
    <td><tt>"#{node["rails-app"]["bundle_command"]} exec rake db:migrate"</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["gems"]</tt></td>
    <td>Array</td>
    <td>Additional gems to install with this recipe.</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["bundler_without_groups"]</tt></td>
    <td>Array</td>
    <td>What groups should bundler ignore?</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["ssl"]</tt></td>
    <td>Boolean</td>
    <td>Should I use SSL?</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["precompile_assets"]</tt></td>
    <td>Boolean</td>
    <td>Shoudl assets be precompiled?</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["rails-app"]["delete_before_bundle"]</tt></td>
    <td>Array</td>
    <td>What files should be deleted from the repo after fetching?</td>
    <td><tt>[".rbenv-version", ".ruby-version"]</tt></td>
  </tr>
</table>

Usage
-----
#### rails-app::default

Just include `rails-app::default` in your node's `run_list` and override attributes as needed. Generally you will need to override the name, host and repository to download from. An example of this is in the Vagrantfile in this repository.

Packer with Docker
------------------

This recipe includes a packer.json file that will build a Docker image and commit it to your local computer. In order to use it you will need to setup your environment first. (Note that this is only tested on Ubuntu 15.04. It should work on other versions of Ubuntu but has some bugs that cause it to not work on OS X, and Windows was not considered.)

0. Perform the steps listed in the [Developing](https://github.com/mitre-cyber-academy/rails-app-cookbook#developing) section.
1. git - `sudo apt-get install git`
2. Docker - `sudo apt-get install docker.io`
3. Download the temporary patched version of packer to work with docker 1.5 located [here](https://bintray.com/alkersan/generic/packer/view) until the [related github issue](https://github.com/mitchellh/packer/issues/1752) is fixed.
4. `wget https://bintray.com/artifact/download/alkersan/generic/packer_0.8.0_linux_amd64.zip`
5. `sudo apt-get install unzip`
6. `unzip packer_0.8.0_linux_amd64.zip`
7. `sudo mv packer* /usr/local/bin/`
8. Install the docker post-processor onto packer. (steps below)
9. Install go - `sudo apt-get install golang-go`
10. Install mercurial - `sudo apt-get install mercurial`
11. `mkdir ~/go`
12. Add the next two lines to .bashrc
13. `export GOPATH=~/go`
14. `export PATH=$PATH:$GOPATH/bin`
15. `git clone https://github.com/avishai-ish-shalom/packer-post-processor-docker-dockerfile.git ~/packer-post-processor-docker-dockerfile`
16. `cd ~/packer-post-processor-docker-dockerfile`
17. `go get github.com/nitrous-io/goop && go build github.com/nitrous-io/goop`
18. `goop install` - if you get an error on this step, try the build step anyway, it may work.
19. `goop go build`
20. `mv packer-post-processor-docker-dockerfile /usr/local/bin`
21. `berks vendor cookbooks`
22. `sudo su`
23. `service docker start`
24. At this point you can run `packer build packer.json` in the root directory of this project.

Debugging Packer with Docker
----------------------------

If there is a problem happening with the Packer build, it is rather simply to turn on chef debugging output, however poorly documented. In the packer.json file, the provisioner block should be changed to include an override block like below. It will then spit out chef debugging output which is much more useful in the case of an error.

    "provisioners": [
      {
        "type": "shell",
        "inline": ["apt-get -y update; apt-get install -y curl libjson-perl"]
      },
      {
        "type": "chef-solo",
        "cookbook_paths": ["cookbooks"],
        "run_list": ["recipe[rails-app::default]"],
        "prevent_sudo": true,
        "json": {        
          "rails-app": {
              "name": "registration-app",
              "ssl": false,
              "repository": "https://github.com/mitre-cyber-academy/registration-app.git",
              "revision": "moveToRails4"
          }},
        "override": {
          "docker": {
            "execute_command": "chef-solo -l debug --no-color -c {{.ConfigPath}} -j {{.JsonPath}}"
          }
        }
      }
    ]

Developing
----------

1. Install the ChefDK (https://downloads.chef.io/chef-dk/)
2. If you are using rbenv, make sure you add add `export PATH="/opt/chefdk/bin:$PATH"` to your `~/.bash_profile` after your rbenv init line.


Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Submit a Pull Request using Github

To DO
-----

* Make recipe less fragile to different versions of ruby. Currently if the C compiler prefix (gems/**2.1.0**/gems) is changed then the recipe will break, that should not happen.

License and Authors
-------------------
Authors: Robert Clark <rbclark@mitre.org>
