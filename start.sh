#!/bin/bash
./config.sh --url $GITHUB_REPO_URL --pat $GITHUB_REPO_PAT_TOKEN --name $RUNNER_NAME --work _work --labels $LABELS --runasservice
