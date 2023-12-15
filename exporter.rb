require 'csv'

class Exporter
  HEADER = ['Number', 'Created', 'Merged', 'Time to merge', 'Author', 'Additions', 'Deletions' 'Title', 'URL']

  attr_reader :filename

  def initialize(params:, pull_request_stats:)
    @params = params
    @pull_request_stats = pull_request_stats
    @filename = "pull_request_stats_#{Time.now.strftime('%Y%m%d%H%M')}.csv"
  end

  def perform
    CSV.open(filename, 'w') do |csv|
      export_info(csv)
      csv << []
      export_stats(csv)
    end
  end

  private

  attr_reader :params, :pull_request_stats

  def export_info(csv)
    csv << ['Org name:', params['ORGNAME']] unless params['ORGNAME'].nil?
    csv << ['Repo:', params['REPO']] unless params['REPO'].nil?
    csv << ['Total:', pull_request_stats.total]
    if !params['START'].nil? && !params['END'].nil?
      start_date = Time.parse(params['START'])
      end_date = Time.parse(params['END'])

      csv << ['Period:', "#{start_date.to_date} - #{end_date.to_date}"]
    end
    csv << ['Avg time to merge:', pull_request_stats.avg_time_to_merge]
  end

  def export_stats(csv)
    csv << HEADER
    pull_request_stats.list.each do |pull_request|
      csv << [
        pull_request.number,
        pull_request.created_at.strftime('%F'),
        pull_request.merged_at.strftime('%F'),
        pull_request.time_to_merge,
        pull_request.author,
        pull_request.additions,
        pull_request.deletions,
        pull_request.title,
        pull_request.url
      ]
    end
  end
end