module Atrophy
  class View
    VIEW_EXTENSIONS                  = %w(rhtml html.erb rjs)
    VIEW_EXTENSIONS_WITH_PERIODS     = VIEW_EXTENSIONS.map { |extension| ".#{extension}" }
    VIEW_EXTENSIONS_AS_REGEXP_STRING = VIEW_EXTENSIONS_WITH_PERIODS.join("|")
    VIEW_EXTENSIONS_AS_REGEXP        = Regexp.new(VIEW_EXTENSIONS_AS_REGEXP_STRING)
    
    def initialize(pathname, rails_root)
      @pathname = pathname
      @rails_root = rails_root
    end
    
    attr_reader :pathname
    
    def relative_path_name
      @pathname.gsub("#{@rails_root}/app/views/", "")
    end
    
    def contents
      @contents ||= File.read(pathname)
    end
    
    def references?(other_view)
      if in_same_view_dir?(other_view)
        content_includes?(other_view.abbreviated_name) || content_includes?(other_view.abbreviated_basename)
      else
        content_includes?(other_view.abbreviated_name)
      end
    end
    
    def inspect
      if partial?
        "Partial: #{abbreviated_name}"
      else
        "Template: #{abbreviated_name}"
      end
    end
    
    def basename
      File.basename(relative_path_name)
    end
    
    def abbreviated_name
      remove_suffix(relative_path_name).gsub(/(.*)\/\_(.*)/) { "#{$1}/#{$2}" }
    end
    
    def abbreviated_basename
      remove_suffix(basename).gsub(/^_(.*)/) { $1 }
    end
    
    def in_same_view_dir?(other_view)
      view_dir == other_view.view_dir
    end
    
    #TODO
    def partial?
      true
    end
    
  private
    
    QUOTE_MARKS = "(\\'|\\\")"
    
    def content_includes?(string)
      contents =~ /render\(?\s*\:partial\s*\=\>\s*.*["'](#{string})["']/ ? true : false
    end
    
  protected
    
    def view_dir
      regexp_string = "#{@rails_root}/app/views/(.*)/[_A-Za-z0-9]+(#{VIEW_EXTENSIONS_AS_REGEXP_STRING})"
      regexp = Regexp.new(regexp_string)
      pathname.gsub(regexp) { $1 }
    end
    
    def remove_suffix(string)
      string.gsub(VIEW_EXTENSIONS_AS_REGEXP, "")
    end
  end
end
