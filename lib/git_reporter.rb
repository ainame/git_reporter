$:.unshift File.dirname(__FILE__)
require "git_reporter/version"

class GitReporter
  attr_reader :repository

  def initialize()
  end

  def fetch
    @repository = Git.new
    self
  end
end
