#NOTE THIS IS YOUR PERSONAL ACTIONS AREA
#NOT COMMITED TO GIT LESS THE EXAMPLE
class Pre_start
    include MAGEINSTALLER_Helper
    include MageInstaller
    def initialize(params=nil)
        
        load_settings

        rerun=false
        file="#{Dir.pwd}/Vagrantfile"
        if File.exist?(file)
            if agree("Use last run's set up? <%= color('[y/n]', :bold) %>")
                rerun=true
            end
        end

        if !rerun
            puts "working on the lite mode"
            FileUtils.cp_r('Vagrantfile-lite', 'Vagrantfile')
            mode = "lite"
        #www root folder
            if Dir.glob('www/{*,.*}').empty?
                if agree("Should WWW folder be cleared? <%= color('[y/n]', :bold) %>")
                    clean_www()
                end
            end
        #database
            if Dir.glob('database/data/{*,.*}').empty?
                if agree("Should all the databases be cleared? <%= color('[y/n]', :bold) %>")
                    clean_db()
                end
            end
        #installer settings
            target  = "scripts/installer_settings.json"
            file = File.join(Dir.pwd, target)
            if File.exist?(file)
                if agree("Should we clear the past install settings file?  <%= color('[y/n]', :bold) %>")
                    FileUtils.rm_rf(file)
                    say("<%= color('removed file #{file}', :bold, :red, :on_black) %>")
                    begin_settings_file()
                        add_setting(file,"\"bs_mode\":\"#{mode}\",")         
                        create_settings_file()
                    end_settings_file()
                  else
                    puts "using the past installer settings"
                end
            else
                begin_settings_file()
                    add_setting(file,"\"bs_mode\":\"#{mode}\",")    
                    create_settings_file()
                end_settings_file()
            end
        end
    end
    
    def get_magepackage(version)

    end
    
    
    
end