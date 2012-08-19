class Git::Blob::Extractor    
  STATES = [
    :author, :commit, :date, :message, :diff
  ].freeze

  BLOB_HEADERS = [
    :author, :commit, :date
  ].freeze

  REGEXP_HEADERS = [
    /^(Author):\s*(.*)$/, 
    /^(commit)\s*(\w*)$/, 
    /^(Date):\s*(.*)$/, 
  ].freeze

  REGEXP_DIFF = /^(diff) --git (.*)$/
  
  attr_reader :state

  def set_state(state)
    @state = state
  end

  def parse(input_line)
    case input_line
    when *REGEXP_HEADERS
      @state = $1.downcase.to_sym
      return @state, $2
    when REGEXP_DIFF
      @state = :diff
      return :diff, input_line
    else
      if @state == :date || @state == :message
        @state = :message
        return :message, input_line
      elsif @state == :diff
        return :diff, input_line
      end
    end
  end
end

