#!/bin/bash

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing step dependencies"

# dependencies
if ! gem list -i "^down$"; then 
    gem install "down" --silent --conservative
fi;

if ! gem list -i "^json$"; then 
    gem install "json" --silent --conservative
fi;

if ! gem list -i "^plist$"; then  
    gem install "plist" --silent --conservative
fi;

if ! gem list -i "^xcodeproj$"; then 
    gem install "xcodeproj" --silent --conservative
fi;

if ! gem list -i "^rubyzip$"; then 
    gem install "rubyzip" --silent --conservative
fi;

echo "Installed step dependencies"
echo "Checking Xcode version"

export APM_XCODE_VERSION=$(xcodebuild -version | grep 'Xcode\s[0-9.]*')

echo "Xcode version: ${APM_XCODE_VERSION}"

echo "Running Trace step"

ruby $THIS_SCRIPT_DIR/step.rb
