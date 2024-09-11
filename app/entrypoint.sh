#!/bin/sh

mkdir -p /github/workflow
cp /app/problem-matcher.json /github/workflow/problem-matcher.json

echo "::add-matcher::${RUNNER_TEMP}/_github_workflow/problem-matcher.json"

# Make sure our coding standards can be found.
phpcs --config-set installed_paths /root/.composer/vendor/drupal/coder/coder_sniffer/Drupal,/root/.composer/vendor/drupal/coder/coder_sniffer/DrupalPractice,/root/.composer/vendor/slevomat/coding-standard && \

phpcs -d memory_limit=${INPUT_MEMORY_LIMIT} --report=checkstyle .

status=$?

echo "::remove-matcher owner=phpcs::"

exit $status
