class RefreshRepositoriesController < ApplicationController
  unloadable
  
  before_filter :find_repository
  before_filter :find_project
  before_filter :authorize
  accept_key_auth :refresh
  
  def refresh
    @last_changeset_before_refresh = 
          @repository.changesets.find(:first, 
                                      :limit => 1, 
                                      :order => "committed_on DESC")
                                      
    # check if new revisions have been committed in the repository
    @repository.fetch_changesets
    
    # latest changesets
    @changesets = 
          @repository.changesets.find(:all, 
                                      :order => "committed_on DESC",
                                      :conditions => ["committed_on > ?",
                                                      @last_changeset_before_refresh.committed_on])
    
    respond_to do |f|
      f.html do
        flash[:notice] = "refreshed"
        redirect_to :controller=> :repositories, :action => :show, :id => @project
      end
      f.xml do
        render :xml => @changesets, :status => :ok
      end
    end
  end
  
  private
    def find_project
      @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end

    def find_repository
      @project = Project.find(params[:id])
      @repository = @project.repository
      render_404 and return false unless @repository
    rescue ActiveRecord::RecordNotFound
      render_404
    end
    
    def render_404
      if params[:format] == "xml"
        head :status => 404 and return false
      else
        return super
      end
    end
    
    def render_403
      if params[:format] == "xml"
        head :status => 403 and return false
      else
        return super
      end
    end
    
  

end

