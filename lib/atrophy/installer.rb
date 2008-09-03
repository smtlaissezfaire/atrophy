module Atrophy
  class Installer
    class << self
      def install
        copy_files
        display_message
      end
      
      def uninstall
        rm "script/atrophy"
      end
      
      def copy_files
        cp "#{File.dirname(__FILE__)}/bin/atrophy", "script/"
      end
      
      def display_message
        output "*" * 80
        output ""
        output "Thanks for installing atrophy"
        output ""
        output "Run with the following command:"
        output ""
        output "  ruby script/atrophy"
        output ""
      end
      
    private
      
      def output(message)
        puts(message)
      end
      
      def cp(src, dest)
        execute "cp #{src} #{dest}"
      end
      
      def execute(cmd)
        `#{cmd}`
      end
    end
  end
end
