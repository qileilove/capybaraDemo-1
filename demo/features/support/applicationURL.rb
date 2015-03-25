require 'uri'

# Returns the full application URL given a path relative to the application base path
def applicationURL(relativePath)
	return URI.join(Capybara.app_host, relativePath).to_s
end
