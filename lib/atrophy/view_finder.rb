module Atrophy
  class ViewFinder
    VIEW_EXTENSIONS_AS_REGEXP = View::VIEW_EXTENSIONS_AS_REGEXP
    
    class << self
      def all
        new.find_all
      end
      
      def all_partials
        new.find_all_partials
      end
    end
    
    def find_all_partials
      find_all.select { |view| view.basename =~ /^\_.*/ }
    end
    
    def find_all
      @all ||= files.map { |file| View.new(file, rails_root) }
    end
    
    def files
      @files ||= all_files_in_view_directory.select { |f| f =~ VIEW_EXTENSIONS_AS_REGEXP }
    end
    
  private
    
    def all_files_in_view_directory
      Dir.glob("#{rails_root}/app/views/**/*")
    end
    
    def rails_root
      @rails_root ||= find_rails_root
    end
    
    def find_rails_root(start_dir = File.dirname(__FILE__))
      dir = File.expand_path(start_dir)
      file = "#{dir}/config/environment.rb"
      if File.exists?(file)
        dir
      else
        find_rails_root("#{dir}/..")
      end
    end
  end
end
