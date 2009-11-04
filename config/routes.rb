ActionController::Routing::Routes.draw do |map|
  map.connect 'repositories/refresh/:id', 
                          :controller => 'refresh_repositories', 
                          :action => 'refresh'
    
  map.connect 'repositories/refresh/:id.:format', 
                          :controller => 'refresh_repositories', 
                          :action => 'refresh'
end