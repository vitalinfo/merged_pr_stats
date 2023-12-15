# frozen_string_literal: true

require 'ostruct'
require 'uri'
require 'net/http'
require 'json'
require_relative 'pull_request_stats'
require_relative 'pull_request'

class Requester
  GITHUB_ENDPOINT = URI('https://api.github.com/graphql')

  def initialize(token:, query:)
    @token = token
    @query = query
    @after = nil
    @pull_request_stats = PullRequestStats.new
  end

  def perform # rubocop:disable Metrics/MethodLength
    loop do
      results = response

      break if error_for?(results)

      search = results.dig(:data, :search)
      page_info = search[:pageInfo]

      pull_request_stats.total = search[:issueCount]

      parse_page(search[:nodes])

      break unless page_info[:hasNextPage]

      @after = page_info[:endCursor]
    end

    pull_request_stats
  end

  private

  attr_reader :after, :token, :query, :pull_request_stats

  def error_for?(results)
    return unless results.key?(:error) || results.key?(:message) || results.key?(:errors)

    pull_request_stats.error = results[:error] || results[:message] || results[:errors]
  end

  def http
    @http ||= Net::HTTP.new(GITHUB_ENDPOINT.host, GITHUB_ENDPOINT.port).tap do |object|
      object.use_ssl = true
    end
  end

  def header
    { Authorization: "Bearer #{token}",
      'Content-Type': 'application/json' }
  end

  def parse_page(nodes)
    pull_request_stats.list.concat(nodes.map do
      PullRequest.new(author: _1.dig(:author, :login),
                      created_at: _1[:createdAt],
                      merged_at: _1[:mergedAt],
                      **_1.slice(:additions, :deletions, :title, :url, :number))
    end)
  end

  def request
    Net::HTTP::Post.new(GITHUB_ENDPOINT.request_uri, header).tap do |object|
      object.body = JSON.generate(query: query, variables: { after: after })
    end
  end

  def response_body
    http.request(request).read_body
  end

  def response
    JSON.parse(response_body, symbolize_names: true)
  rescue JSON::ParserError
    { error: 'invalid_response' }
  end
end
