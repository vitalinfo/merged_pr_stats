# frozen_string_literal: true

QUERY = <<-GRAPHQL
  query($after: String) {
    search(type: ISSUE, first: 100, query: "is:pr is:merged {{QUERY}}", after: $after) {
      issueCount
      nodes {
        ... on PullRequest {
          author {
            login
          }
          additions
          deletions
          title
          url
          number
          createdAt
          mergedAt
          changedFiles
        }
      }
      pageInfo {
        endCursor
        hasNextPage
      }
    }
    rateLimit {
      limit
      cost
      remaining
      resetAt
    }
  }
GRAPHQL
