#!/bin/bash
set -ex

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GEMFILE="--gemfile=${THIS_SCRIPT_DIR}/Gemfile"

# replace preinstalled bundler on build VM
if [ "$CI" == "true" ]; then
    echo "Installing/Updating gems from bundler list"

    gem install bundler --force
    gem update --system

    bundle update --bundler $GEMFILE

    echo "Installed/Updated gems from bundler list"
fi  

echo "Installing step dependencies"

#install step dependencies
bundle install $GEMFILE

echo "Pre-setup complete for Trace SDK script"

bundle exec $GEMFILE ruby $THIS_SCRIPT_DIR/step.rb
