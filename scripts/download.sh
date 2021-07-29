#!/bin/bash

# download github runner application
curl -o actions-runner-linux-x64-2.278.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz
tar xzf actions-runner-linux-x64-2.278.0.tar.gz
rm -rf actions-runner-linux-x64-2.278.0.tar.gz
