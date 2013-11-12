#right now this is geared to a Magento dev env. here but with a little more 
#refactoring we will be able to have this handle a few types like WP to more 
#complicated ones.

# is there room to improve andabstract this, yes!  
# throw ideas out and let us see what sticks

require 'rubygems'
module MageInstaller
    
    load 'rake/helper.rb'
    include MAGEINSTALLER_Helper
    
    fresh=false
    
    def initialize(params=nil)
        if !File.exist?("#{Dir.pwd}/READY") 
            if Gem::Version.new(RUBY_VERSION) > Gem::Version.new('1.8')
                puts "initializing the system"          
                load_gem("json")
                load_gem("highline")
                load_gem("launchy")
                output = `vagrant plugin list`
                if !output.include? "vagrant-hostsupdater"
                    puts "installing vagrant-hostsupdater plugin"
                    puts `vagrant plugin install vagrant-hostsupdater`
                else
                    puts "vagrant-hostsupdater plugin loaded"
                end
                if !output.include? "vagrant-cachier"
                    puts "installing vagrant-cachier plugin"
                    puts `vagrant plugin install vagrant-cachier`
                else
                    puts "vagrant-cachier plugin loaded"
                end
                puts "*************************************************************\n"
                puts "`rake start` again ******************************************\n"
                puts " there were a few things needed to install so you need to do."
                puts "*************************************************************\n"
                File.open("#{Dir.pwd}/READY", "w+") { |file| file.write("") }
                abort("type rake start")
            else         
                abort("ruby version to low, must update see http://rvm.io/ if on Mac")
            end
        else
            require 'highline/import'
        end
    end



##################    
#tasks
##################

#test
    def test()
        require 'fileutils'

        puts "testing the system now"
        fresh=false
        puts "insuring default folders"
        create_dir("/www/")
        create_dir("/_depo/")
        create_dir("/_BOXES/")
        create_dir("/database/data/")
        if !File.exist?("#{Dir.pwd}/scripts/installer_settings.json") 
            File.open("#{Dir.pwd}/scripts/installer_settings.json", "w+") { |file| file.write("") }
        end
        #this is where we would build the Vagrant file to suite if abstracted to account for 
        #more then this project would allow for new boxes is approprate too.  
        file="#{Dir.pwd}/_BOXES/precise32.box"
        if !File.exist?(file)
            download('http://hc-vagrant-files.s3.amazonaws.com/precise32.box',file)
        else
            puts "base box esited"
        end
        say("System seems ready <%= color('proceeding forward', :bold) %>")
    end

#start
    def start()
        stopwatch = Stopwatch.new
        self.test()
        event("Pre")

        say("[<%= color('Starting the Vagrant', :bold,:green) %>]")
        system( "vagrant up" )
        
        event("Post")
        self.open() 
        stopwatch.end("Started in:")
    end
    
#end
    def end_it()
        stopwatch = Stopwatch.new
        event("Pre")
        system( "vagrant destroy -f" )
        if agree("Should all the databases be cleared?   <%= color('[y/n]', :bold) %>")
            self.clean_db()
        end
        event("Post")
        stopwatch.end("finished shutdown in:")
    end

#clean_db
    def clean_db()
        say("<%= color('starting database removal', :bold, :yellow, :on_black) %>")
        #note maybe nuking can be done a simpler way to preserve the db install it's self?
        FileUtils.rm_rf(Dir.glob('database/data/*'))
        say("<%= color('mysql is fully cleared', :bold, :red, :on_black) %>")
    end

#clean_www
    def clean_www()
        say("<%= color('cleaning the WWW folder', :bold, :yellow, :on_black) %>")
        FileUtils.rm_rf(Dir.glob('www/*'))
        say("<%= color('all files in the www web root has been cleared', :bold, :red, :on_black) %>")
    end

#fresh
    def fresh()
        self.hardclean()
        puts "needs to uninstall gems and what not"
    end


#hardclean
    def hardclean()
        stopwatch = Stopwatch.new
        event("Pre")
        output=`vagrant destroy -f`
        puts output

        self.clean_www()
        self.clean_db()
        say("<%= color('cleaning the file DEPO folder', :bold, :yellow, :on_black) %>")
        FileUtils.rm_rf(Dir.glob("#{Dir.pwd}/_depo/*"))
        say("<%= color('all files in the _depo web root has been cleared', :bold, :red, :on_black) %>")
        
        event("Post")
        stopwatch.end("finished hard clean up in:")
    end


#this should be removed so that we can do better with this
#open
    def open()
        
        #note we would want to check for the browser bing open already
        #so we don't annoy people
        
        event("Pre")
        require 'launchy'
        Launchy.open("http://local.general.dev/") #note this should be from setting file
        event("Post")
    end


#up
    def up()
        stopwatch = Stopwatch.new
        self.test()
        load_settings()
        event("Pre")
        system( "vagrant up" )
        event("Post")
        self.open()
        stopwatch.end("box brought up in:")
        
    end

#reload
    def reload()
        stopwatch = Stopwatch.new
        event("Pre")
        system( "vagrant reload" )
        event("Post")
        self.open()
        stopwatch.end("reloaded in:")
    end

#destroy
    def destroy()
        stopwatch = Stopwatch.new
        event("Pre")
        system( "vagrant destroy" )
        event("Post")
        stopwatch.end("destroy in:")
    end

#halt
    def halt()
        stopwatch = Stopwatch.new
        event("Pre")
        system( "vagrant halt" )
        event("Post")
        stopwatch.end("halted in:")
    end

#restart
    def restart()
        stopwatch = Stopwatch.new
        event("Pre")
        self.end_it()
        self.up()
        event("Post")
        stopwatch.end("restarted in:")
    end




#setting file
    def create_settings_file()

        
        #we would call to each package adn if they exist
        #then we would run it's content, for example:
        require 'digest/md5'
    
        file="scripts/installer_settings.json"

    end


    def set_settings_defaults()
        require 'digest/md5'
        file="scripts/installer_settings.json"

    end

    def set_custom_user_settings()

    end


end