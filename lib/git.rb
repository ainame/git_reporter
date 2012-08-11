require 'git/blob'

class Git
  BIN = `which git`.strip
  attr_reader :blobs, :base_dir

  ALLOWED_COMMAND = [
    :status, :log, :fetch, :diff, :show
  ].freeze

  class NotAGitRepositoryError < StandardError; end
  class NotAllowCommandError < StandardError; end

  def initialize(path = nil)
    @blobs = []
    @base_dir = path || `pwd`.strip
    raise NotAGitRepositoryError unless git_repository?      
  end

  def fetch
    
  end

  def pull
    
  end

  def log(*options)
    invoke(:log, *options)
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

  def git_repository?
    !(invoke(:status) =~ /fatal: Not a git repository/)
  end

  private

  def invoke(subcommand, *options)
    raise NotAllowedCommandError unless ALLOWED_COMMAND.include?(subcommand)
    command = build_command(subcommand, *options)

    with_base_dir_execution do
      execute(command)
    end
  end
   
  def build_command(subcommand, *options)
    ["#{BIN} #{subcommand}", *options].join(' ')
  end

  def with_base_dir_execution()
    return nil unless block_given?

    Dir.chdir(@base_dir) do
      yield
    end
  end

  def execute(command)
    `#{command}`
  end

end
