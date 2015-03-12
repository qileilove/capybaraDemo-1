# capybaraDemo

This repository has a simple example of running [Capybara](https://github.com/jnicklas/capybara) in a [Docker](www.docker.com) container.

The tests may be run against Firefox, Chrome, or Poltergeist/Phantomjs.
It also includes support for [screenshots](mattheworiordan/capybara-screenshot) of failed tests cases

## Overview

The docker image `capybara_demo` contains all of the tools and libraries required to run Capybara against Firefox, Chrome or Phantomjs.

The directory `demo` is mounted into the docker container under the directory `/capybara`, giving the tools in the container access to
all of the cucumber/capybara test files defined in `demo`.

The script `demo/runCucmber.sh` is executed from within docker. It handles any runtime setup (such as starting Xvfb if necessary), and
then executes cucumber.

A report of the test execution is written to `demo/output`.

## How to run

### Step 1 - Build the docker image

This step only needs to be performed once on a given machine.
On the first execution, the build will take several minutes.
Docker will cache the resulting image locally so that any subsequent attempts will be much faster

```
$ ./dockerBuild.sh
```
### Step 2 - Run the test suite against one of the browsers

The Selenium driver for Capybara is the default, and by default it executes tests againts Firefox.
```
$ ./dockerRun.sh
or
$ ./dockerRun.sh -d selenium
```

To run against Chrome,
```
$ ./dockerRun.sh -d selenium_chrome
```

To run against Poltergeist/Phantomjs,
```
$ ./dockerRun.sh -d poltergeist
```

### Step 3 - Review the test results

The output from the tests are written to stdout as the tests execute. Additionally, an HTML report is written to
`demo/output/features_report.html`. If a test case fails, the HTML report will include a screenshot of the browser
at the point in time when the test case failed.

### Cucumber Command Line Options
Cucumber command line options can be specified by defining the environment variable `CUCUMBER_OPTS` on the make command line.
For a full list of possible options, specify `--help`
```
$ CUCUMBER_OPTS=--help ./dockerRun.sh
```

### Environment variables
Environment variables are used to pass information into the docker container.

The variables `CALLER_UID` and `CALLER_GID` capture the current users UID and GID which are used in the container to create a `cuke` user so that
files written to `demo/output` will have the proper owner/group information.

Other variables set bu `dockerRun.sh` are:
 * **`CAPYBARA_DRIVER`** - the name of the Capybara web driver to use. Valid values are `selenium` (which uses Firefox), `selenium_chrome`, or `poltergeist` (which uses PhantomJS). The default if not specified is "selenium"
 * `CAPYBARA_TIMEOUT` - the timeout, in seconds, that Capybara should wait for a page or element. The default is 10 seconds.

For details of how these two variables are used, see [demo/features/support/env.rb](demo/features/support/env.rb)

## TODOs

 * Include a failed test case to illustrate error reporting
 * Illustrate use of tags (reports and running just some)
 * Illustrate a pending scenario

## Known Issues

 * Phantomjs crashes on click of the Search button - [phantomjs/issues/13055](https://github.com/ariya/phantomjs/issues/13055)

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
