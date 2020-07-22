#!/bin/bash

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing step dependencies"

# dependencies
gem install "down" --silent
gem install "json" --silent
gem install "plist" --silent
gem install "xcodeproj" --silent

echo "Installed step dependencies"

echo "Running Trace step"

ruby $THIS_SCRIPT_DIR/step.rb
