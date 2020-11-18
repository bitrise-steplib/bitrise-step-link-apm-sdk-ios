#!/bin/bash

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing step dependencies"

# dependencies
if ! gem list -i "^down$"; then 
    echo "Installing gem: down"

    gem install "down" --silent --conservative
else
    echo "Found gem: down"
fi;

if ! gem list -i "^json$"; then
    echo "Installing gem: json" 

    gem install "json" --silent --conservative
else
    echo "Found gem: json"
fi;

if ! gem list -i "^plist$"; then 
    echo "Installing gem: plist"

    gem install "plist" --silent --conservative
else
    echo "Found gem: plist"
fi;

if ! gem list -i "^xcodeproj$"; then
    echo "Installing gem: xcodeproj" 

    gem install "xcodeproj" --silent --conservative
else
    echo "Found gem: xcodeproj"
fi;

if ! gem list -i "^rubyzip$"; then 
    echo "Installing gem: rubyzip"

    gem install "rubyzip" --silent --conservative
else
    echo "Found gem: rubyzip"
fi;

echo "Installed step dependencies"
echo "Checking Xcode version"

export APM_XCODE_VERSION=$(xcodebuild -version | grep 'Xcode\s[0-9.]*')

echo "Xcode version: ${APM_XCODE_VERSION}"

echo "Running Trace step"

ruby $THIS_SCRIPT_DIR/step.rb
