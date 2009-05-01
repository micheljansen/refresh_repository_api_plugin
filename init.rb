require 'redmine'

# add custom permission to refresh repositories
Redmine::AccessControl.map do |map|
  map.project_module :repository do |map|
    map.permission :refresh_changesets, :refresh_repositories => [:refresh]
  end
end

Redmine::Plugin.register :refresh_repositories_api do
  name 'Refresh repositories API'
  author 'Michel Jansen'
  url 'http://github.com/micheljansen/refresh_repository_api_plugin'
  author_url 'http://micheljansen.org'
  description "Adds a very simple API to invoke a refresh of a given repository remotely. Useful when using post commit hooks when the server running the SCM is not the same as the server running Redmine."
  version '0.1.0'
  requires_redmine :version_or_higher => '0.8.0'
end
