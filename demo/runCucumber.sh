#!/bin/bash

#
# Make sure that Xvfb is started in case we're using Chrome or Firefox
# (Xvfb is not used by poltergeist/phantomjs)
if [ "${CAPYBARA_DRIVER}" != "poltergeist" ]; then
    /etc/init.d/xvfb start
fi

#
# Make the user account 'cuke' in the container which matches the UID/GID of
# the caller outside of the container
#
makeCukeUser.sh

HOME=/home/cuke su cuke --preserve-environment -c "cd /capybara; cucumber $*"
