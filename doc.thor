require 'rubygems'
require 'rdoc/rdoc'
require 'fileutils'
require 'erb'
require File.join(File.dirname(__FILE__), 'rdoc', 'generators', 'merb_generator')
$: << File.join(File.join(File.dirname(__FILE__), "rdoc"))

class Doc < Thor
  
  desc "generate PATH", "generate doc for the path passed as an argument"
  def generate(path)
    path = File.expand_path(path)
    readme = File.join(path, "README") || File.join(path, "README.markdown")
    
    # destination => ./generated_doc/project_name
    destination = File.join(Dir.pwd, 'generated_doc', File.basename(path))
    # cleaning up the folder before generating the doc
    FileUtils.rm_rf(destination)
    
    # get all the files to process
    files = Dir.glob("#{path}/**/lib/**/*.rb")
    # without forgetting the readme file
    files += ["#{path}/README"] if File.exists?("#{path}/README")

    # rdoc args
    arguments = [
      "-m", readme,
      "--fmt", "merb",
      "--op", destination
    ]

    puts "Generating doc for #{File.basename(path)} (#{files.size} files) doc generated to: #{destination}"
    RDoc::RDoc.new.document(arguments + files)
  end
  
end