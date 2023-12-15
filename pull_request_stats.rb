# frozen_string_literal: true

class PullRequestStats
  attr_reader :list
  attr_accessor :error, :total

  def initialize
    @list = []
    @total = 0
    @error = nil
  end

  def avg_time_to_merge
    (list.map(&:time_to_merge).reduce(:+) / list.size.to_f).to_i
  end
end
