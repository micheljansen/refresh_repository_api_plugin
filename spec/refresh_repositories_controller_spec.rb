require File.dirname(__FILE__) + '/spec_helper'


describe RefreshRepositoriesController, :type => :controller do
  describe "routes" do
    it "should map /repositories/refresh/project-identifier to the right action" do
      params_from(:get, "/repositories/refresh/project-identifier").should == 
                                          {:controller=>"refresh_repositories", 
                                            :action=>"refresh", 
                                            :id=>"project-identifier"}
    end
    
    it "should map /repositories/refresh/project-identifier.xml to the right action and method" do
      params_from(:get, "/repositories/refresh/project-identifier.xml").should == 
                                          {:controller=>"refresh_repositories", 
                                            :action=>"refresh", 
                                            :id=>"project-identifier",
                                            :format=>"atom"}
    end
    
  end
end