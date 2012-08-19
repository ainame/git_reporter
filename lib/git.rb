require 'git/blob'
require 'git/blob/extractor'

class Git
  # dependent 'which' command 
  BIN = `which git`.strip
  attr_reader :blobs, :base_dir

  class NotGitBinaryError < StandardError; end
  class NotAGitRepositoryError < StandardError; end
  class NotAllowCommandError < StandardError; end

  ALLOWED_COMMAND = [
    :status, :log, :fetch, :diff, :show, :checkout, :pull
  ].freeze

  ALLOWED_COMMAND.each do |command| 
    define_method(command) do |*options|
      invoke(command, *options)
    end
  end

  def initialize(path = nil)
    @blobs = []
    @base_dir = path || `pwd`.strip

    raise NotGitBinaryError unless BIN =~ /git/
    raise NotAGitRepositoryError unless git_repository?      
  end
 
  def parse_log(log)
    extractor = Git::Blob::Extractor.new
    blob = nil
    log.each_line do |line|
      attribute, value = extractor.parse(line)  
      if attribute == :commit and not blob.nil?
        @blobs.push blob
        blob = Git::Blob.new
      elsif blob.nil?
        blob = Git::Blob.new
      end
      blob.add_attribute(attribute, value)
    end
    @blobs.push blob

    nil
  end

  private

  def git_repository?
    !(invoke(:status) =~ /fatal: Not a git repository/)
  end

  def invoke(subcommand, *options)
    raise NotAllowedCommandError unless ALLOWED_COMMAND.include?(subcommand)
    command = build_command(subcommand, *options)

    evaluate_with_base_dir do
      execute(command)
    end
  end
   
  def build_command(subcommand, *options)
    ["#{BIN} #{subcommand}", *options].join(' ')
  end

  def evaluate_with(path)
    return nil unless block_given?

    Dir.chdir(path) do
      yield
    end
  end

  def evaluate_with_base_dir(&block)
    evaluate_with(@base_dir, &block)
  end

  def execute(command)
    `#{command}`
  end

end
