module Atrophy
  class Runner
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
  end
end
