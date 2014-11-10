#!/usr/bin/env bash

brew install rbenv ruby-install

rbenv init -
rbenv install 2.1.4
rbenv global 2.1.4

echo 'Please ensure $(rbenv init -) is evaluated by your shell. For example, in ~/.zshrc.'
