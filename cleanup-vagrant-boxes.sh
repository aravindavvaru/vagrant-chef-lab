#!/bin/bash
#
# remove all downloaded vagrant boxes
vagrant box list | grep -v There | cut -f 1 -d ' ' | xargs -L 1 vagrant box remove -f --all
