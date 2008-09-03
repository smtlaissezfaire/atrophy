module Atrophy
  class GenericRailsFile
    def initialize(pathname, rails_root)
      @pathname = pathname
      @rails_root = rails_root
    end
    
    attr_reader :pathname
    
    def contents
      @contents ||= File.read(pathname)
    end
    
    def basename
      File.basename(pathname)
    end
    
    def references?(other_view)
      content_includes?(other_view.abbreviated_name)
    end
    
  private
    
    def content_includes?(string)
      contents =~ /render\(?\s*\:partial\s*\=\>\s*.*["'](#{string})["']/ ? true : false
    end
  end
end
