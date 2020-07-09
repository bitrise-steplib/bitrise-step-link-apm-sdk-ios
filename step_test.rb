require 'xcodeproj'

MAIN_TARGET = ENV['BITRISE_SCHEME']

# Xcode project tests
project = Xcodeproj::Project.open("#{ENV['BITRISE_PROJECT_PATH']}".gsub(/\.xcworkspace\b/, '.xcodeproj'))
project.targets.each do |target_obj|
    next if target_obj.name != MAIN_TARGET

    target_obj.build_configuration_list.build_configurations.each do |build_configuration|
        build_settings = build_configuration.build_settings

        if build_settings['OTHER_LDFLAGS']
            build_settings['OTHER_LDFLAGS'].each_with_index do |flag, idx|
                if flag == "libTrace.a" && build_settings['OTHER_LDFLAGS'][idx-1] != '-force_load'
                    puts "Target '#{target_obj.name}' with '#{build_configuration.name}' configuration does not contain expected build settings"
                    puts "Expected OTHER_LDFLAGS should contain '-force_load libTrace.a'"
                    puts "Actual OTHER_LDFLAGS: #{build_settings['OTHER_LDFLAGS']}"
                    exit 1
                end
            end
        else
            puts "Target '#{target_obj.name}' with '#{build_configuration.name}' configuration does not contain OTHER_LDFLAGS"
            puts "Expected OTHER_LDFLAGS should contain '-force_load libTrace.a'"
            exit 1
        end

        if build_settings['LIBRARY_SEARCH_PATH'] 
            if !build_settings['LIBRARY_SEARCH_PATH'].include? "$(inherited)" || !(build_settings['LIBRARY_SEARCH_PATH'].include? "$(PROJECT_DIR)/trace-cocoa-sdk")
                puts "Target '#{target_obj.name}' with '#{build_configuration.name}' configuration does not contain expected build settings"
                puts "Expected LIBRARY_SEARCH_PATH should include '$(inherited)' and '$(PROJECT_DIR)/trace-cocoa-sdk'"
                puts "Actual LIBRARY_SEARCH_PATH: #{build_settings['LIBRARY_SEARCH_PATH']}"
                exit 1
            end
        else
            puts "Target '#{target_obj.name}' with '#{build_configuration.name}' configuration does not contain LIBRARY_SEARCH_PATH"
            puts "Expected LIBRARY_SEARCH_PATH should include '$(inherited)' and '$(PROJECT_DIR)/trace-cocoa-sdk'"
            exit 1
        end
    end
    
    frameworks_build_phase = target_obj.frameworks_build_phase
    
    if !frameworks_build_phase.file_display_names.include?("SystemConfiguration.framework")
        puts "Target does not contain SystemConfiguration framework"
        exit 1
    end
    
    if !frameworks_build_phase.file_display_names.include?('libc++.tbd')
        puts "Target does not contain c++ library"
        exit 1
    end
    
    if !frameworks_build_phase.file_display_names.include?('libz.tbd')
        puts "Target does not contain Z library"
        exit 1
    end
end

# Files tests
apm_library_path = "#{ENV['BITRISE_PROJECT_PATH']}/../libTrace.a"
if !File.file?(apm_library_path)
    puts "Trace library not found at #{apm_library_path}"
    exit 1
end

bitrise_configuration_path = "#{ENV['BITRISE_PROJECT_PATH']}/../bitrise_configuration.plist"
if !File.file?(bitrise_configuration_path)
    puts "Configurator plist not found at #{bitrise_configuration_path}"
    exit 1
end

# plist tests
plist = Xcodeproj::Plist.read_from_path(bitrise_configuration_path)

if plist.nil?
    puts "plist does not exist"
    exit 1
end

if plist['APM_COLLECTOR_TOKEN'] != ENV['APM_COLLECTOR_TOKEN']
    puts "Collector token #{plist['APM_COLLECTOR_TOKEN']} in plist does not match test token #{ENV['APM_COLLECTOR_TOKEN']}"
    exit 1
end
