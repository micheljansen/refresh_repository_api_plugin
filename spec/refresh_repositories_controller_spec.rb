require File.dirname(__FILE__) + '/spec_helper'


describe RefreshRepositoriesController, "Refresh Repositories API plugin", :type => :controller do
    
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
  
  describe "call" do
    before(:each) do
      @project = mock_model(Project)
      @project.stub!(:active?)
      
      @changeset = mock_model(Changeset, :committed_on => Time.now)
      
      @repository = mock_model(Repository, :fetch_changesets => [])
      @repository.stub!(:changesets).and_return(mock("relation", :find => @changeset))
      @project.stub!(:repository).and_return(@repository)
      Project.stub!(:find).and_return(@project)
      
      @user = mock_model(User)
      @user.stub!(:allowed_to?).with({:controller => "refresh_repositories", :action => 'refresh'}, anything(), anything()).and_return(true)
      @user.stub!(:logged?).and_return(false)
      User.stub!(:find_by_rss_key).and_return(@user)
      User.stub!(:current).and_return(@user)
    end

    def do_refresh_call
      post :refresh, 
              :id => "project-identifier", 
              :format => 'atom', 
              :key => '0fffd238a475216c39a2160917bcf95954c7608d'
    end
    
    it "should respond success" do
      do_refresh_call
      response.should be_success
    end
    
    it "should deny access to unauthorized users" do

      User.stub!(:current).and_return(User.anonymous)
      User.stub!(:find_by_rss_key).and_return(User.anonymous)
      
      @repository.stub!(:fetch_changesets)
      @repository.should_not_receive(:fetch_changesets)
      do_refresh_call
      
      response.should_not be_success
    end
    
    it "should trigger a call fetch_changesets" do
     @repository.should_receive(:fetch_changesets)
     do_refresh_call
   end
  end
end