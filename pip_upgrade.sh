#!/bin/bash

# pip upgrade outdated
pip list --outdated | tail -n +3 | awk '{print $1}' | xargs pip install --upgrade
