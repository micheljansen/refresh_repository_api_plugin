class RefreshRepositoriesController < ApplicationController
  unloadable
  
  before_filter :find_project
  before_filter :authorize
  accept_key_auth :refresh
  before_filter :find_repository
  
  def refresh
    @last_changeset_before_refresh = 
          @repository.changesets.find(:first, 
                                      :limit => 1, 
                                      :order => "committed_on DESC")
    
    # import all new revisions that were made since the last check
    @repository.fetch_changesets
    
    # list of all the new changesets that were imported
    @changesets = []
    if(@last_changeset_before_refresh)
      @changesets = 
          @repository.changesets.find(:all, 
                                      :order => "committed_on DESC",
                                      :conditions => ["committed_on > ?",
                                                      @last_changeset_before_refresh.committed_on])
    end
    
    respond_to do |f|
      f.html do
        flash[:notice] = "refreshed"
        redirect_to :controller=> :repositories, :action => :show, :id => @project
      end
      f.atom do
        render :xml => @changesets, :status => :ok
      end
      f.xml do
        render :xml => @changesets, :status => :ok
      end
    end
  end
  
  
  private
  
  def find_project
    begin
      @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404 and return false
    end
  end

  def find_repository
    begin
      @project = Project.find(params[:id])
      @repository = @project.repository
      render_404 and return false unless @repository
    rescue ActiveRecord::RecordNotFound
      render_404 and return false
    end
  end
  
  def render_404
    if params[:format] == "atom" || params[:format] == "xml"
      head :status => 404 and return false
    else
      return super
    end
  end
  
  def render_403
    if params[:format] == "atom" || params[:format] == "xml"
      head :status => 403 and return false
    else
      return super
    end
  end
  
  def deny_access
    if params[:format] == "atom" || params[:format] == "xml"
      render_403 and return false
    else
      super
    end
  end
  
end

