#!/bin/bash
if [[ $TRAVIS_BRANCH == 'master' ]] ; then
  bundle exec rake publish
else
  echo 'Invalid branch. You can only deploy from master.'
  exit 1
fi