# capybaraDemo

This repository has a simple example of running [Capybara](https://github.com/jnicklas/capybara) in a [Docker](www.docker.com) container.

It supports running the tests against Firefox, Chrome, or Poltergeist/Phantomjs. It also includes support for [screenshots](mattheworiordan/capybara-screenshot) of failed tests cases

## Overview

The docker image `capybara_demo` contains all of the tools and libraries required to run Capybara against Firefox, Chrome or Phantomjs.
The cucumber/capybara files in the directory `demo` are mounted into the docker container
under the directory `/capybara` and then the script `runCucmber.sh` is executed from within docker.
The `runCucumber.sh` script starts Xvfb (which is required for Firefox and Chrome, but not used by Phantomjs) and executes cucumber.
A report of the test executation is written to `demo/output`.

## How to run

### Step 1 - Build the docker image

This step only needs to be performed once on a given machine.
On the first execution, the build will take several minutes.
Docker will cache the image locally so that any subsequent attempts will be much faster

```
$ make dockerBuild
```
### Step 2 - Run the test suite against one of the browsers

The Selenium driver for Capybara is the default, and by default it executes tests againts Firefox.
```
$ make test
```

To run against Chrome,
```
$ make testChrome
```

To run against Poltergeist/Phantomjs,
```
$ make testPhantomjs
```

### Step 3 - Review the test results

The output from the tests are written to stdout as the tests execute. Additionally, an HTML report is written to
`demo/output/features_report.html`. If a test case fails, the HTML report will include a screenshot of the browser
at the point in time when the test case failed.

### Cucumber Command Line Options
Cucumber command line options can be specified by defining the `CUCUMBER_OPTS` variable on the make command line. 
For a full list of possible options, specify `--help`
```
$ make CUCUMBER_OPTS=--help test
```

### Optional Environment variables
The optional environment variables used to override some of the default behaviors are:
 * **CAPYBARA_DRIVER** - the name of the Capybara web driver to use. Valid values are "selenium" (which uses Firefox), "selenium_chrome", or "poltergeist" (which uses PhantomJS). The default if not specified is "selenium"
 * **CAPYBARA_TIMEOUT** - the timeout, in seconds, that Capybara should wait for a page or element. The default is 10 seconds.

Use the `-e` command line option to `docker run` to pass these values to the Cucumber.

For details of how these variables are used, see [demo/features/support/env.rb](demo/features/support/env.rb)

## Known Issues

 * The `demo/output` directory and it's contents are owned by root, but should be the user who ran the tests.
 * Phantomjs crashes on click of the Search button - [phantomjs/issues/13055](https://github.com/ariya/phantomjs/issues/13055)
 * For security reasons, the sandboxing capabilities of Chrome on Linux will prevent it from running on SUID filesystems, including those in a Docker container. To workaround that, you can run the docker container with the `--privileged` flag, which is a no-no for Docker containers in general. Alternatively, you __TBD__

## References

 * [Docker](www.docker.com)
 * [Cucumber - A tool for BDD testing](https://github.com/cucumber/cucumber)
 * [Capybara - An Acceptance test framework for web applications](https://github.com/jnicklas/capybara)
 * [Capybara cheat sheet](https://gist.github.com/zhengjia/428105)
 * [How to install PhantomJS on Ubuntu](https://gist.github.com/julionc/7476620)
 * [Notes on setting up Xvfb for docker](https://github.com/keyvanfatehi/docker-chrome-xvfb)
 * [How to install Chromedriver on Ubuntu](https://devblog.supportbee.com/2014/10/27/setting-up-cucumber-to-run-with-Chrome-on-Linux/)
 * [How to install Chrome from the command line](http://askubuntu.com/questions/79280/how-to-install-chrome-browser-properly-via-command-line)
 * [URLs for different versions of Chrome](http://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable)
 * [Chromedriver options](https://sites.google.com/a/chromium.org/chromedriver/capabilities)
 * [Chrome options](http://peter.sh/experiments/chromium-command-line-switches/)
