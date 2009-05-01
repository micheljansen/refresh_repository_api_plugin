connect 'repositories/refresh/:id', 
                        :controller => 'refresh_repositories', 
                        :action => 'refresh'
    
connect 'repositories/refresh/:id.:format', 
                        :controller => 'refresh_repositories', 
                        :action => 'refresh'