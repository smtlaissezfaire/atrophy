module Atrophy
  def self.run
    Runner.run
  end
  
  dir = File.dirname(__FILE__) + "/atrophy"
  
  autoload :Runner,     "#{dir}/runner"
  autoload :View,       "#{dir}/view"
  autoload :ViewFinder, "#{dir}/view_finder"  
  autoload :Installer,  "#{dir}/installer"
end
