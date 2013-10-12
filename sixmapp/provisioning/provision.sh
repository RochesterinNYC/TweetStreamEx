#!/bin/bash

# Linux Setup
echo "Installing update..."
apt-get -y update >/dev/null 2>&1

echo "Installing essential linux components..."
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-dev \
    git vim curl libyaml-dev libcurl4-openssl-dev sqlite3 >/dev/null 2>&1

echo "Installing bundler..."
apt-get -y install ruby-bundler >/dev/null 2>&1

echo "Installing Rails..."
apt-get -y install rails >/dev/null 2>&1

echo "Finished."