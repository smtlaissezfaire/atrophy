module Atrophy
  class ViewFinder < FileFinder
    FILE_BASE_PATH = "#{rails_root}/app/views"
    ALLOWED_FILE_EXTENSIONS_REGEXP = View::VIEW_EXTENSIONS_AS_REGEXP
    
    class << self
      def all_partials
        new.find_all_partials
      end
    end
    
    def find_all_partials
      find_all.select { |view| view.partial? }
    end
    
    def file_class
      View
    end
  end
end
