
default: usage

usage:
	@echo "USAGE: make <target>\n"
	@echo "where target is one of: "
	@echo "\tdockerBuild - builds the docker image"
	@echo "\ttest - runs the tests with Firefox in the docker image"
	@echo "\ttestChrome - runs the tests with Chrome in the docker image"
	@echo "\ttestPhantomjs - runs the tests with poltergeist/phantomjs in the docker image"

test: testFirefox

testFirefox:
	$(MAKE) DRIVER_NAME=selenium dockerRun

#
# Google Chrome is extremely picky about SUID filesystems which creates issues
# trying to run Chrome inside a docker container because the container-local filesystems are SUID.
# Using --privileged=true on the docker container is one workaround.
#
# TODO: try configuring chromedriver to pass the --no-sandbox arg to chrome and/or run chrome as non-root user
# https://sites.google.com/a/chromium.org/chromedriver/capabilities
#
testChrome:
	docker run --rm --privileged=true -v `pwd`/demo:/capybara -e CAPYBARA_DRIVER=selenium_chrome -t capybara_demo /capybara/runCucumber.sh

testPhantomjs:
	$(MAKE) DRIVER_NAME=poltergeist dockerRun

dockerBuild:
	docker build -t capybara_demo dockerImage

dockerRun:
ifdef CAPYBARA_TIMEOUT
	docker run --rm -v `pwd`/demo:/capybara -e CAPYBARA_DRIVER=$(DRIVER_NAME) -e CAPYBARA_TIMEOUT=$(CAPYBARA_TIMEOUT)-t capybara_demo /capybara/runCucumber.sh $(CUCUMBER_OPTS)
else
	docker run --rm -v `pwd`/demo:/capybara -e CAPYBARA_DRIVER=$(DRIVER_NAME) -t capybara_demo /capybara/runCucumber.sh $(CUCUMBER_OPTS)
endif

