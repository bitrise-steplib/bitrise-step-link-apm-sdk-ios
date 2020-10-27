#!/bin/bash

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing step dependencies"

# dependencies
gem install "down" --silent
gem install "json" --silent
gem install "plist" --silent
gem install "xcodeproj" --silent

echo "Installed step dependencies"
echo "Checking Xcode version"

export APM_XCODE_VERSION=$(xcodebuild -version | grep 'Xcode\s[0-9.]*')

echo "Xcode version: ${APM_XCODE_VERSION}"

echo "Running Trace step"

ruby $THIS_SCRIPT_DIR/step.rb
