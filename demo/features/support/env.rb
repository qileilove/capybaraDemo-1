#
# This file is responsible for loading/executing any code that exists outside of
# the step definitions. You can also define hooks either here or in another file
# in this directory (e.g. hooks.rb). For more info on hooks, see
# https://github.com/cucumber/cucumber/wiki/Hooks
#
require 'fileutils'
require "capybara"
require "capybara/cucumber"
require "capybara/rspec"
require 'capybara/poltergeist'
require 'selenium-webdriver'
require 'capybara-screenshot/cucumber'

#
# Set defaults
Capybara.default_wait_time = 10
Capybara.default_driver = :selenium
Capybara::Screenshot.prune_strategy = :keep_last_run

output_dir = ENV["OUTPUT_DIR"]
if output_dir && output_dir.length > 0
    if Dir.exists?(output_dir)
        FileUtils.rm_rf(output_dir)
    end
    Capybara.save_and_open_page_path = output_dir + "/screenshots"
    FileUtils.mkdir_p(Capybara.save_and_open_page_path)
end

driver_override = ENV["CAPYBARA_DRIVER"]
if driver_override && driver_override.length > 0
    if driver_override == "selenium"
        Capybara.default_driver = :selenium
    elsif driver_override == "selenium_chrome"
        Capybara.default_driver = :selenium_chrome
    elsif driver_override == "poltergeist"
        Capybara.default_driver = :poltergeist
    else
        puts "ERROR: invalid value for CAPYBARA_DRIVER"
        exit 1
    end
end

#
# Register Chrome (Firefox is the selenium default)
Capybara.register_driver :selenium_chrome do |app|
	Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

#
# Register poltergeist (headless driver based on phantomjs)
Capybara.register_driver :poltergeist do |app|
    options = {
    	:ignore_ssl_errors => true,
        :js_errors => false,
        :timeout => 120,
        :debug => false,
        :phantomjs_options => ['--load-images=no', '--disk-cache=false'],
        :inspector => true,
    }
    Capybara::Poltergeist::Driver.new(app, options)
end

#
# Required so that Screenshot works with the "selenium_chrome" driver
Capybara::Screenshot.register_driver(:selenium_chrome) do |driver, path|
    driver.browser.save_screenshot(path)
end


