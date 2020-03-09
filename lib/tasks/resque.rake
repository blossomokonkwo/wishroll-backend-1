#resque rake tasks 
require 'resque/tasks'
# task 'resque:setup' => :environment do  
#     ENV['QUEUE'] = '*'  
#   end  
# task "jobs:work" => "resque:work"   
task "resque:preload" => :environment