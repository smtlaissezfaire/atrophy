module Atrophy
  class FileFinder
    class << self
      def all
        new.find_all
      end
      
      def rails_root
        @rails_root ||= find_rails_root
      end
      
    private
      
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
    
    FILE_BASE_PATH = "#{rails_root}/app"
    ALLOWED_FILE_EXTENSIONS_REGEXP = /.*/
    
    def find_all
      @all ||= files.map { |file| construct_file_class(file) }
    end
    
    def file_class(file)
      if file && file.include?(ViewFinder::FILE_BASE_PATH)
        View
      else
        GenericRailsFile
      end
    end
    
    def construct_file_class(file)
      file_class(file).new(file, rails_root)
    end
    
    def files
      @files ||= all_files_in_dir.select { |f| f =~ ALLOWED_FILE_EXTENSIONS_REGEXP }
    end
    
  private
    
    def all_files_in_dir
      Dir.glob("#{FILE_BASE_PATH}/**/*", File::FNM_DOTMATCH).select do |file|
        File.file?(file)
      end
    end
    
    def rails_root
      self.class.rails_root
    end
  end
end
