# Merged PR stats

This is a tool to creates github merged PullRequest statistics. 
It is useful to measure the productivity and health of your team.

## Usage

```
ruby run.rb GITHUB_TOKEN=ZZZZZ
```

Available additional command line params:

- `ORGNAME` - matches issues in repositories owned by the GitHub organization
- `REPO` - matches issues from specific repository
- `START` + `END` - time period

Example

```
ruby run.rb GITHUB_TOKEN=ZZZZ ORGNAME=MyOrg START=2023-01-01T00:00:00 END=2023-12-15T23:59:59
```

## Links

- https://docs.github.com/en/github/searching-for-information-on-github/searching-issues-and-pull-requests