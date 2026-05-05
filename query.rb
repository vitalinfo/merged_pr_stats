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
          comments(first: 0) {
            totalCount
          }
          commits(first: 0) {
            totalCount
          }
          reviewRequests(first: 0) {
            totalCount
          }
          reviews(first: 0) {
            totalCount
          }
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
