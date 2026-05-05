# frozen_string_literal: true

class PullRequest
  attr_reader :additions, :author, :changed_files, :comments_count, :commits_count, :created_at,
              :deletions, :merged_at, :number, :pending_reviews_count, :reviews_count, :title, :url

  def initialize(additions:,
                 author:,
                 changed_files:,
                 comments_count:,
                 commits_count:,
                 created_at:,
                 deletions:,
                 merged_at:,
                 number:,
                 pending_reviews_count:,
                 reviews_count:,
                 title:,
                 url:)# rubocop:disableMetrics/ParameterLists
    @additions = additions
    @author = author
    @changed_files = changed_files
    @comments_count = comments_count
    @commits_count = commits_count
    @created_at = Time.parse(created_at)
    @deletions = deletions
    @merged_at = Time.parse(merged_at)
    @number = number
    @pending_reviews_count = pending_reviews_count
    @reviews_count = reviews_count
    @title = title
    @url = url
  end

  def time_to_merge
    @time_to_merge ||= (merged_at - created_at).to_i
  end
end
