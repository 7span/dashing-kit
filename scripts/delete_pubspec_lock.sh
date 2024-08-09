#!/bin/zsh

find ../ -type f -name 'pubspec.lock' -exec rm -f {} +
find ../ -type d -name '.dart_tool' -exec rm -r {} +