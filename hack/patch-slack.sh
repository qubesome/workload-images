#!/usr/bin/env bash

set -euo pipefail

SLACK_URL="https://slack.com/intl/en-gb/release-notes/linux"
SLACK_REGEX="Slack ([0-9].[0-9]{1,2}.[0-9]{1,3})"

function main() {
    local LATEST_VERSION=""
    LATEST_VERSION=$(curl "${SLACK_URL}" | grep -oEi "${SLACK_REGEX}" | head -n1 | cut -d' ' -f2)

    if [ -n "${LATEST_VERSION}" ]; then
        sed -i "s;ARG SLACK_VERSION=.*;ARG SLACK_VERSION=${LATEST_VERSION};g" workloads/slack/Dockerfile
    fi

    if git diff --cached --quiet; then
        echo "Update to ${LATEST_VERSION}"
        
        git checkout -b slack-patch
        git add workloads/slack/Dockerfile
        git commit -m "build: Bump Slack to ${LATEST_VERSION}"
        git push --set-upstream origin slack-patch
        gh pr create --title "build: Bump Slack to ${LATEST_VERSION}" --body "" --base main
    else
        echo "No new versions found."
    fi
}

main
