ActionController::Routing::Routes.draw do |map|
  map.connect 'repositories/refresh/:id', 
                          :controller => 'refresh_repositories', 
                          :action => 'refresh'
    
  map.connect 'repositories/refresh/:id.xml', 
                          :controller => 'refresh_repositories', 
                          :action => 'refresh',
                          :format => 'atom'
end