# capybaraDemo

This repository has a simple example of running [Capybara](https://github.com/jnicklas/capybara) in a [Docker](www.docker.com) container.

The tests may be run against Firefox, Chrome, or Poltergeist/Phantomjs.
It also includes support for [screenshots](mattheworiordan/capybara-screenshot) of failed tests cases

#Table of Contents

  - [Overview](#overview)
  - [How to run](#how-to-run)
    - [Step 1 - Build the reporter jar](#step-1---build-the-reporter-jar)
    - [Step 2 - Build the docker image](#step-2---build-the-docker-image)
    - [Step 3 - Run the test suite](#step-3---run-the-test-suite)
    - [Step 4 - Review the test results](#step-4---review-the-test-results)
    - [Cucumber Command Line Options](#cucumber-command-line-options)
    - [Environment variables](#environment-variables)
  - [Examples](#examples)
    - [Running a subset of tests](#running-a-subset-of-tests)
    - [Looking at a failed test case](#looking-at-a-failed-test-case)
    - [Tagging conventions](#tagging-conventions)
    - [Page Object Model](#page-object-model)
  - [TODOs](#todos)
  - [Known Issues](#known-issues)
  - [References](#references)

## Overview

The docker image `capybara_demo` contains all of the tools and libraries required to run Capybara against Firefox, Chrome or Phantomjs.

The directory `demo` is mounted into the docker container under the directory `/capybara`, giving the tools in the container access to
all of the cucumber/capybara test files defined in `demo`.

The script `runCucmber.sh` is executed from within docker. It handles any runtime setup (such as starting Xvfb if necessary), and
then executes cucumber.

A report of the test execution is written to `demo/output`.

## How to run

**NOTE:** The tests in this demo use github as the 'system under test', and some of them require valid userid/password
credentials. You can specify those credentials on the command line or with enviroment variables (details below).
If you do not specify the credentials, the tests will run, but the scenarios will which require a valid login
will fail.

### Step 1 - Build the reporter jar

Though cucumber comes with several different reports, I think the most useful is an html report generated by
a separate project, [cucumber-reporting](https://github.com/masterthought/cucumber-reporting). Normally, cucumber-reporting
is used as a Jenkins plugin that converts the standard JSON report produced by Cucumber into an elegant HTML format.
To run it from the command line outside of Jenkins, we need to build a small Java app. The `dockerBuild.sh` script
will add this jar to the docker image, and the `runCucumber.sh` script in the image will run the Java app to generate
a nice report after cucumber is done.

To build the Java app,

```
$ cd reporter
$ mvn -s ./settings.xml package
```

### Step 2 - Build the docker image

This step only needs to be performed once on a given machine.
On the first execution, the build will take several minutes.
Docker will cache the resulting image locally so that any subsequent attempts will be much faster


```
$ ./dockerBuild.sh
```
### Step 3 - Run the test suite

Capybara uses different 'drivers' to interface with a web browser.
The Selenium driver for Capybara is the default, and by default it executes tests againts Firefox.
The test suite can be run against any one of several browsers by selecting differnet drivers.

```
$ ./dockerRun.sh -u <yourGithubID> -p <yourGitHubPassword>
or
$ ./dockerRun.sh -d selenium -u <yourGithubID> -p <yourGitHubPassword>
```

To run against Chrome,

```
$ ./dockerRun.sh -d selenium_chrome -u <yourGithubID> -p <yourGitHubPassword>
```

To run against Poltergeist/Phantomjs,

```
$ ./dockerRun.sh -d poltergeist -u <yourGithubID> -p <yourGitHubPassword>
```

For a full description of the command line options, run `./dockerRun.sh -h`

### Step 4 - Review the test results

The output from the tests are written to stdout as the tests execute. Additionally, an HTML report is written to
`demo/output/feature-overview.html`. If a test case fails, the HTML report will include a screenshot of the browser
at the point in time when the test case failed.

### Cucumber Command Line Options
Cucumber command line options can be specified by defining the environment variable `CUCUMBER_OPTS` on the make command line.

### Environment variables
Environment variables are used to pass information into the docker container which are used by the shell and Ruby scripts executed in the container.

The primary variables used by `dockerRun.sh` are:

 * **`APPLICATION_URL`** - the URL of the application under test (githb in this case).
 * **`APPLICATION_USERID`** - the user id to login into the application under test (i.e. your github account id). You can set this variable with the `-u` command line option for `dockerRun.sh`.
 * **`APPLICATION_PASSWORD`** - the password used to login into the application under test. You can set this variable with the `-p` command line option for `dockerRun.sh`.
 * **`CAPYBARA_DRIVER`** - the name of the Capybara web driver to use. Valid values are `selenium` (which uses Firefox), `selenium_chrome`, or `poltergeist` (which uses PhantomJS). The default if not specified is "selenium". You can set this variable with the `-d` command line option for `dockerRun.sh`.
 * **`CAPYBARA_TIMEOUT`** - the timeout, in seconds, that Capybara should wait for a page or element. The default is 10 seconds. You can set this variable with the `-t` command line option for `dockerRun.sh`.
 * **`CUCUMBER_OPTS`** - any of the standard command line options for Cucumber.

Internally, the script also uses the variables `CALLER_UID` and `CALLER_GID` capture the current users UID and GID which are used in the container to create a `cuke` user so that
files written to `demo/output` will have the proper owner/group information (for OSX, see Known Issues). These two variables should not be overwritten or modified. For an example of how these variables are used, refer to the [dockerImage/makeCukeUser.sh](dockerImage/makeCukeUser.sh) script.

For details of how these variables are used, see [demo/features/support/env.rb](demo/features/support/env.rb) and [demo/features/support/application.rb](demo/features/support/application.rb)

For a full list of possible options for Cucumber itself, pass the `--help` option to Cucumber like this:

```
$ CUCUMBER_OPTS=--help ./dockerRun.sh
```

## Examples
### Running a subset of tests
Cucumber supports a feature called tags which can be used in run a subset of tests.  A full explanation of using tags is beyond the scope of this document; see the Cucumber [documentation](https://github.com/cucumber/cucumber/wiki/Tags) for a full description.

For this demo, the two Features have been tagged, so you can run just one of them at a time

```
$ CUCUMBER_OPTS='--tags @search' ./dockerRun.sh -u <yourGithubID> -p <yourGitHubPassword>

```

### Looking at a failed test case
This demo captures screenshots for failed test steps. If you have not seen a failed test case already, run the tests with an invalid userid and/or password.  When you do, you should see something like this in the command line output.

```
 Scenario: Successful login                                   # features/login.feature:4
    When I am on the login page                                # features/steps/login_steps.rb:1
    And I fill in the user id field with the default user id   # features/steps/login_steps.rb:9
    And I fill in the password field with the default password # features/steps/login_steps.rb:17
    And I click the sign-in button                             # features/steps/login_steps.rb:28
    Then I should see "News Feed"                              # features/steps/generic_steps.rb:13
      expected to find text "News Feed" in "Skip to content Sign up Sign in Explore Features Enterprise Blog Incorrect username or password. Sign in Username or Email Password (forgot password) Status API Training Shop Blog About \u00A9 2015 GitHub, Inc. Terms Privacy Security Contact" (RSpec::Expectations::ExpectationNotMetError)
      ./features/steps/generic_steps.rb:14:in `/^I should see "(.*?)"$/'
      features/login.feature:9:in `Then I should see "News Feed"'
    And I should see "Pull Requests"                           # features/steps/generic_steps.rb:13
    And I should see "GitHub Bootcamp"                         # features/steps/generic_steps.rb:13
    HTML screenshot: ./output/screenshots/screenshot_2015-03-27-11-46-31.958.html
    Image screenshot: ./output/screenshots/screenshot_2015-03-27-11-46-31.958.png
```
If you open `demo/output/feature-overview.html` with a browser and drill into the details for the login feature, you will see the equivalent output in nicely formatted table. Look for a "Screenshot" link below the error report for the failed step. Clicking on that link should display an image captured at the time of the failure.

### Tagging conventions
Cucumber offers a powerful tagging feature that can be used to control which features and/or scenarios are run, as well as enabling custom 'hooks' to run specific blocks of code at different points

This demo project defines the following tags:

 * feature tags - There is a unique tag on each Feature to allow running single features at a time or in combination. The valid values are `@login`, `@search` and `@profile`
 * login hook - The tag `@login-required` illustrates how to use hook tags to automatically execute some block of code before/after the associated feature/step. In this case, the `@login-required` tag will login the user before each feature/step decorated with the tag (remember that each Scenario executes as a new browser session).

 To specify one of these tags, define `--tags tagName` in CUCUMBER_OPTS. For instance the following command will run just the tests for the profile feature:

 ```
$ CUCUMBER_OPTS='--tags @profile' ./dockerRun.sh -u yourName@something.com -p yourPasswordHere`
 ```

For information of these Cucumber feature, see:

 * [Tags](https://github.com/cucumber/cucumber/wiki/Tags)
 * [Hooks](https://github.com/cucumber/cucumber/wiki/Hooks)

### Page Object Model
Cucmber and Capybara offer huge advantages in terms of being able to write tests using a simple, expressive DSL that describes how to interact with your application's UI.
However, as your application and your tests grow, you can easily run into situations where implementation details about a particular page or reusable element are either 'leaking' into Step statements explicitly, or they are constantly repeated across step definitions. For instances, things like the IDs or CSS/Xpath expressions used to identify specific elements on a page can end up being repeated over and over again. When the actual page definition is changed by a developer, then you have to make the same refactor across multiple places in your tests.

A Page Object Model is a DSL for describing for the page itself. Think of it as a secondary DSL "below" the DSL expresssed in the test features. The Page Object Model should encapsulate all of the implementation detail like DOM identifiers, CSS/xpath matching expressions, etc.

This demo has a very simple example for using a Page Object Model. I choose [Site Prism](http://www.sitepoint.com/testing-page-objects-siteprism/) to implement a Page Object Model for just the github login page.  The login page  is defined in [demo/features/pages/login.rb](demo/features/pages/login.rb), and it is used in [demo/features/steps/login_steps.rb](demo/features/steps/login_steps.rb).

For more discussion of page object model, see

 * [Testing Page Objects with SitePrism](http://www.sitepoint.com/testing-page-objects-siteprism/)
 * [Keeping It Dry With Page Objects](http://techblog.constantcontact.com/software-development/keeping-it-dry-with-page-objects/)

## TODOs

 * Add example of REST validation

## Known Issues

 * Phantomjs crashes on click of the Search button - [phantomjs/issues/13055](https://github.com/ariya/phantomjs/issues/13055)
 * On Mac OSX with [boot2docker](http://boot2docker.io/), you must use the `--root` option for `dockerRun.sh` and
 boot2docker will automagically map the root user of the docker container to the current user of the host OS. Without the `--root` option, you will encounter permission problems trying to write files into the `demo/output` directory.

## References

 * [Docker](www.docker.com)
 * [Cucumber - A tool for BDD testing](https://github.com/cucumber/cucumber)
 * [Capybara - An Acceptance test framework for web applications](https://github.com/jnicklas/capybara)
 * [Capybara cheat sheet](https://gist.github.com/zhengjia/428105)
 * [Site Prism - A Page Object Model DSL for Capybara](https://github.com/natritmeyer/site_prism)
 * [How to install PhantomJS on Ubuntu](https://gist.github.com/julionc/7476620)
 * [Notes on setting up Xvfb for docker](https://github.com/keyvanfatehi/docker-chrome-xvfb)
 * [How to install Chromedriver on Ubuntu](https://devblog.supportbee.com/2014/10/27/setting-up-cucumber-to-run-with-Chrome-on-Linux/)
 * [How to install Chrome from the command line](http://askubuntu.com/questions/79280/how-to-install-chrome-browser-properly-via-command-line)
 * [URLs for different versions of Chrome](http://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable)
 * [Chromedriver options](https://sites.google.com/a/chromium.org/chromedriver/capabilities)
 * [Chrome options](http://peter.sh/experiments/chromium-command-line-switches/)
