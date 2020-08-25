require "fileutils"
require_relative 'project_helper'
require_relative 'functions'

if !ENV['APM_COLLECTOR_TOKEN']
    puts 'Error: missing APM_COLLECTOR_TOKEN env, double check envman and if Trace has been enabled in app by navigating to: Bitrise App->Addon->Trace'
    exit 1
end

project_path = ENV['project_path']
scheme = ENV['scheme']
lib_version = ENV['lib_version']

if project_path.empty?
    puts "Error: BITRISE_PROJECT_PATH env var is required and cannot be empty. #{project_path}"
    exit 1
end

if scheme.empty?
    puts "Error: BITRISE_SCHEME env var is required and cannot be empty. #{scheme}"
    exit 1
end

if lib_version.empty?
    puts "Error: missing input lib_version"
    exit 1
end

url = "https://monitoring-sdk.firebaseapp.com/#{lib_version}/libTrace.a"
tmpf = download_library(url)
if tmpf == nil
    puts "Error downloading Bitrise Trace library version #{lib_version} from #{url}: #{e.message}"
    exit 1
end

puts 
puts "Downloaded Trace library"
puts 
puts "Starting step with path: #{project_path}, scheme: #{scheme}, trace version: #{lib_version}"
puts

FileUtils.mv(tmpf.path, "#{File.dirname(project_path)}/#{tmpf.original_filename}")

helper = ProjectHelper.new(project_path, scheme)

begin
    puts 
    puts "Updating project to link Trace library"
    helper.link_swift_framework_if_objective_c_only_project()
    helper.link_static_library()
    puts "Updated project with Trace library"
rescue Exception => e
    puts "Error modifying project to link Trace library: #{e.message}"
    exit 1
end

begin
    puts "Registering configuration plist file into build phase"
    helper.register_resource()
    puts "Registered configuration plist file into build phase"
rescue Exception => e
    puts "Error registering Bitrise configuration plist file: #{e.message}"
    exit 1
end

puts 
puts "Done!"
