class Atrophy
  def self.run
    new.run
  end
  
  def run
    partial_views.each do |view|
      if no_other_views_reference_view?(view)
        report(view)
      end
    end
  end
  
  def no_other_views_reference_view?(view)
    !at_least_one_other_view_references_view?(view)
  end
  
  def at_least_one_other_view_references_view?(view)
    first_view_to_reference_view(view) == nil ? false : true
  end
  
  def first_view_to_reference_view(view)
    views.detect { |a_view| a_view.references?(view) }
  end
  
  def report(view)
    puts "* Couldn't find view #{view.pathname} referenced anywhere!"
  end
  
  def views
    @views ||= find_view_files
  end
  
  def partial_views
    @partial_views ||= find_partial_views
  end
  
private
  
  def find_view_files
    ViewFinder.all
  end
  
  def find_partial_views
    ViewFinder.all_partials
  end
  
  class ViewFinder
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
      "/Users/scott/src/git/flavorpill_com"
    end
  end
end
