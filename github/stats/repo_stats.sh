#!/bin/bash

# GitHub CLI api
# https://cli.github.com/manual/gh_api

# https://docs.github.com/en/rest/metrics/statistics?apiVersion=2022-11-28

gh api \
  -H "Accept: application/vnd.github+json" \
  /repos/OWNER/REPO/stats/code_frequency


# commit summary
# GitHub CLI api
# https://cli.github.com/manual/gh_api

gh api \
  -H "Accept: application/vnd.github+json" \
  /repos/OWNER/REPO/stats/commit_activity


## summary stats

# GitHub CLI api
# https://cli.github.com/manual/gh_api

gh api \
  -H "Accept: application/vnd.github+json" \
  /repos/OWNER/REPO/stats/contributors

## Weekly commit count

# GitHub CLI api
# https://cli.github.com/manual/gh_api

gh api \
  -H "Accept: application/vnd.github+json" \
  /repos/OWNER/REPO/stats/participation
