# frozen_string_literal: true

class PullRequest
  attr_reader :additions, :deletions, :changed_files, :author, :title, :url, :number, :created_at, :merged_at

  def initialize(author:, additions:, changed_files:, created_at:, deletions:, merged_at:, number:, title:, url:)# rubocop:disableMetrics/ParameterLists
    @author = author
    @created_at = Time.parse(created_at)
    @merged_at = Time.parse(merged_at)
    @changed_files = changed_files
    @number = number
    @title = title
    @url = url
    @additions = additions
    @deletions = deletions
  end

  def time_to_merge
    @time_to_merge ||= (merged_at - created_at).to_i
  end
end
