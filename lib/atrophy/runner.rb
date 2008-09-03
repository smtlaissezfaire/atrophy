module Atrophy
  class Runner
    def self.run
      new.run
    end
    
    def run
      partial_views.each do |view|
        if no_other_files_reference_view?(view)
          report(view)
        end
      end
    end
    
    def no_other_files_reference_view?(view)
      !at_least_one_other_file_references_view?(view)
    end
    
    def at_least_one_other_file_references_view?(view)
      first_file_to_reference_view(view) == nil ? false : true
    end
    
    def first_file_to_reference_view(view)
      files.detect { |a_view| a_view.references?(view) }
    end
    
    def report(view)
      puts "* Couldn't find view #{view.pathname} referenced anywhere!"
    end
    
    def files
      @files ||= find_files
    end
    
    def partial_views
      @partial_views ||= find_partial_views
    end
    
  private
    
    def find_files
      FileFinder.all
    end
    
    def find_partial_views
      ViewFinder.all_partials
    end
  end
end
