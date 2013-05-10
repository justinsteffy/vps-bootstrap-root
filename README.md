# VPS Bootstrap as Root via Chef

*WARNING: No warranty expressed or implied about the security of your machine after executing these scripts*

A chef repo to be run as root against a fresh Ubuntu 12.04 VPS install using [knife solo](http://matschaffer.github.io/knife-solo/).  It provides the following features:

* enable password-less sudo
* create a regular user
* setup ssh keys
* harden ssh

After this is done you can use password-less ssh with your regular user account.


## Setup

* install knife solo (use `gem install knife-solo`)
* prepare the target machine using `knife solo prepare -P password root@your.host`
* overwrite the contents of the newly created file in `nodes/your.host.json` with the contents of `template.json`
* create identity files using `ssh-keygen -t rsa` (or use existing)
* copy the id-rsa.pub file to `cookbooks/setup/files/default/authorized_keys`
* update attributes however you'd like (I'd just edit `cookbooks/setup/attributes/default.rb`)
* run `knife solo cook root@your.host` and enter the root password repeatedly

At the end of the install it restarts ssh with root login disabled, so start using your newly created user account.  Remember that the ssh port has been changed and that the identity file is required.  You can ssh using a command like the following:

    ssh -p port -I /path/to/identity/id_rsa newuser@your.host
    
Or you can setup an ssh config in `~/.ssh/config` that looks like this:

    Host your.host
        HostName your.host
        Port ssh.port
        User newuser
        IdentityFile /path/to/identity/id_rsa
        
Now you can use Chef as a regular user to set everything else up.
