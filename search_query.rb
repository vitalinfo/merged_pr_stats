# frozen_string_literal: true

class SearchQuery
  def initialize(params:)
    @params = params
  end

  def perform # rubocop:disable Metrics/AbcSize
    res = []
    res << "org:#{params['ORGNAME']}" unless params['ORGNAME'].nil?
    res << "repo:#{params['REPO']}" unless params['REPO'].nil?
    if !params['START'].nil? && !params['END'].nil?
      start_date = Time.parse(params['START'])
      end_date = Time.parse(params['END'])

      res << "merged:#{start_date.iso8601}..#{end_date.iso8601}"
    end
    res.join(' ')
  end

  private

  attr_reader :params
end
