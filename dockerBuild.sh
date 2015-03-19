#!/bin/bash

if [ -f reporter/target/reporter.jar ]; then
    cp reporter/target/reporter.jar dockerImage
else
    echo "ERROR: reporter/target/reporter.jar not found"
    echo "       You can build it by running \"cd reporter;mvn -s ./settings.xml package\"" 
    exit 1
fi

docker build -t capybara_demo dockerImage
