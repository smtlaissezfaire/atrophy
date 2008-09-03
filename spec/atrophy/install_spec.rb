require File.dirname(__FILE__) + "/../spec_helper"

module Atrophy
  describe Installer do
    describe "installer" do
      before :each do
        Installer.stub!(:copy_files)
        Installer.stub!(:display_message)
      end
      
      it "should call copy_files" do
        Installer.should_receive(:copy_files)
        Installer.install
      end
      
      it "should call display_message" do
        Installer.should_receive(:display_message)
        Installer.install
      end
    end
    
    describe "copy_files" do
      before :each do
        Installer.stub!(:cp).and_return "return status"
        File.stub!(:dirname).and_return "plugin_dir"
      end
      
      it "should cp" do
        Installer.should_receive(:cp).with("plugin_dir/bin/atrophy", "script/")
        Installer.copy_files
      end
      
      it "should cp from the plugin dir" do
        File.stub!(:dirname).and_return "correct_plugin_dir"
        Installer.should_receive(:cp).with("correct_plugin_dir/bin/atrophy", "script/")
        Installer.copy_files
      end
    end
    
    describe "uninstall" do
      before :each do
        Installer.stub!(:rm).and_return ""
      end
      
      it "should remove the script/atrophy file" do
        Installer.should_receive(:rm, "script/atrophy")
        Installer.uninstall
      end
    end
  end
end
