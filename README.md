# WSU Magento Development platform 
## Overview
The goal of this project is to make a very simple way for someone to do development against the 
production version of the Magento solution.  This setup is done in a way that should let the user follow 
only a few steps before then can login to the admin area and begin development work. 

1. install the base apps
    
    > 1. GITHUB ([win](http://windows.github.com/)|[mac](http://mac.github.com/)) 
    > 1. [Vagrant](http://www.vagrantup.com/) (for [help installing see wiki](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/wiki/Installing-Vagrant))
    > 1. [VirtualBox](https://www.virtualbox.org/) (for [help installing see wiki](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/wiki/Installing-Vagrant))
    > 1. [Ruby](http://rubyinstaller.org/)(only needed if using windows see the [wiki for help](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/wiki/Installing-ruby))
    > Note: if your on a mac you must have ruby 1.9 or above.  Look to [this article to update your ruby](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)
1. run in powershell/command line 
        
        > git clone git://github.com/jeremyBass/vagrant-base-web.git webbase

1. move to the new directory 
        
        > cd webbase

1. run in powershell/command line/terminal 
        
        > rake start

Some this to note is that you wil be asked questions.  If you need help, look to the [task options wiki page](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/wiki/Taks-Options)

Now if this is the first time you have ever run then the `rake start` task will install anything 
that is needed and check to make sure everything is ok.  It'll prompt you as it goes, but after a 
few minutes the first time around, you will have the admin area for Magento up and ready to log in.
It really is as simple as these 4 steps to get up and running.  On a fresh system, seeing the Magento
admin page took about 5-10 minutes depending on the power of the machine your ran it on and it's internet
connections.  There will be a tune it up section in the wiki area later on.

If you have use Vagrant, then you'll know that most of the time you need to mess with config files,
install plugins, and have to do some of your own clean up if you want to start from scratch.  
What this project is designed to do it wrap Vagrant in a `rake` task for Ruby.  By doing this we can 
perform tests that the host system is ready to `vagrant up` and can ask questions verse requiring 
the developer to mess around with the configs.  This means you can totally bring up and down a box much 
faster by automating as much as possible.

***
##The Ruby wrapper
###Rake Tasks
Although you could just use the Vagrant commands, the whole point of this project is that there 
are questions about the environment you want to set up.  In order to take advantage of this, here are a list of the rake tasks:

**Primary Tasks**

1. `rake start` :: basically `vagrant up` but with prompts (this runs a few other tasks to ensure that the system is ready to `vagrant up`)
1. `rake end` :: this task is `vagrant destroy` with options to clean up the database if it needs it.
1. `rake hardclean` :: runs all the cleaners
1. `rake fresh` :: takes the system back to basic (will prompt to uninstall gems and vagrant plugins)
1. `rake restart` :: this task will time the running of `rake end` and then `rake up` which should provide a very fast full down and up

**Tasks to match Vagrant**

1. `rake up` :: vagrant up ***(only adds timer and events)***
1. `rake destroy` :: vagrant destroy ***(only adds timer and events)***
1. `rake halt` :: vagrant halt ***(only adds timer and events)***
1. `rake reload` :: vagrant reload ***(only adds timer and events)***
1. `rake suspend` :: vagrant suspend ***(only adds timer and events)***
1. `rake pull` :: match the local to the production
1. `rake push` :: push up to production ***(would need to authenticate)***

**Utility tasks**

1. `rake clean_db` ::  This is to clear the shared database folder
1. `rake clean_www` :: This is to clear the shared web folder
1. `rake create_install_settings` :: create the settings for the installer
1. `rake test` :: this is for testing that all the plugins are there, if not then install them?
1. `rake open` :: Opens up your default browser and loads your url from settings



### Events
Because this is a ruby rake task wrapper for Vagrant, we can add a few helpers to improve the process.
One of the first things is that there are event hooks that you can inject your personal parts to.  
All event files are located in `/rake/events` and will have the file name in the format  of `{Event_type}_{Task_name}.rb`.
The events that are set up for you are
    
1. Pre
1. Post
    
So for example if you wanting to do something before everything else when `rake start` is ran, then you would need 
to add your event file named, `/Pre_start.rb`  There is a sample file to look at as well in the `/rake` folder (`EXAMPLE_Pre_start.rb`).
From there you area now able to do more custom actions like copying some files in place or something.

###Gems that are autoloaded
1. [json](http://rubygems.org/gems/json)
1. [highline](http://rubygems.org/gems/highline)
1. [launchy](http://rubygems.org/gems/launchy)

***
##Vagrant
Just to note you can by pass the rake taskes and just use Vagrant on it's own, but you will have to magage your files on your own, and make sure that you edit your configs too.  There is a lot to learn under the hood.

###Vagrant plugins that are autoloaded
1. [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)


***
## Customizable settings

### Credentials and Such
#### MySQL Root ***(defaults)***
* User: `root`
* Pass: `blank`


### What's loaded on the systems?
There are 3 servers that run when mirroring the production servers, or just one if you want a development base.
**note:** This set up is currently a Shell provisioner only.  Later when branching, there will be a 
switch to CentOS and to a new provisioner option.  Currently options are Chef and Salt as considered

1. [Ubuntu](http://ubuntu.com) 12.04 LTS (Precise Pangolin)
1. [nginx](http://nginx.org) 1.4.2
1. [mysql](http://mysql.com) 5.5.32
1. [php-fpm](http://php-fpm.org) 5.4.17
1. [memcached](http://memcached.org/) 1.4.13
1. PHP [memcache extension](http://pecl.php.net/package/memcache/3.0.8) 3.0.8
1. [xdebug](http://xdebug.org/) 2.2.3
1. [PHPUnit](http://pear.phpunit.de/) 3.7.24
1. [ack-grep](http://beyondgrep.com/) 2.04
1. [git](http://git-scm.com) 1.8.3.4
1. [ngrep](http://ngrep.sourceforge.net/usage.html)
1. [dos2unix](http://dos2unix.sourceforge.net/)
1. [phpMemcachedAdmin](https://code.google.com/p/phpmemcacheadmin/) 1.2.2 BETA

**Note this is the highlights, for a full list look [here](#)**



***

### Rightfully questioning this project extensiveness 
So moving forward, the ruby wrapper is built out to be able to have use for Wordpress (or any other setup) 
like many of the other vagrant projects, but should it be totally abstracted enough for that?  Maybe 
if there is interest it would be and at which point then there would be a wrapper project on its own 
and this would be reduced do to only the Magento parts of the environment.

### Feedback?
keep it to your self.. no tell it like it is but atm there is no area to yell at except on here.

## Contributing

If you find what looks like a bug:

1. Search the [mailing list] COMING SOON
2. Check the [GitHub issue tracker](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/issues) to see if anyone else has reported issue.
3. If you don't see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix: (will be better defined later)

1. Fork the project on GitHub.
2. Make your changes with tests.
3. Commit the changes to your fork.
4. Send a pull request.

***
Original Author: jeremyBass 
