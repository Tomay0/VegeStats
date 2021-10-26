#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /vegestats/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
bundle exec rails s -p $APP_PORT -b 0.0.0.0