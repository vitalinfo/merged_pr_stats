# frozen_string_literal: true

require 'time'
require_relative 'query'
require_relative 'requester'
require_relative 'search_query'
require_relative 'exporter'

# SUPPORTED PARAMS
# GITHUB_TOKEN (*required)
# ORGNAME
# REPO [USERNAME/REPOSITORY]
# START/END [YYYY-MM-DDThh:mm:ss]

params = Hash[*ARGV.map { _1.split('=') }.flatten]

if params['GITHUB_TOKEN'].nil?
  puts('Please provide GITHUB_TOKEN')
  exit 0
end

search_query = SearchQuery.new(params: params)
query = QUERY.gsub(/\{\{QUERY\}\}/, search_query.perform)

requester = Requester.new(token: params['GITHUB_TOKEN'], query: query)

pull_request_stats = requester.perform
exporter = Exporter.new(params: params, pull_request_stats: pull_request_stats).tap(&:perform)

puts("Export file: #{exporter.filename}")
