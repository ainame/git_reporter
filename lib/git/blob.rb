# -*- coding: utf-8 -*-
class Git
  class Blob
    attr_accessor :commit, :author, :date, :message, :diff

    def initialize (args = {})
      @commit      ||= args[:commit]
      @author  ||= args[:author]
      @date    ||= args[:date]
      @message ||= args[:message]
      @diff    ||= args[:diff]
    end

    def add_attribute(key, value)
      if key == :diff or key == :message
        setter = (key.to_s + '=').to_s
        previous_value = self.send(key)
        appended_value = [previous_value, value].join("\n")
        self.send(setter, appended_value)
      else
        setter = (key.to_s + '=').to_s
        self.send(setter, value)
      end
    end

    class Extractor    
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
  end
end
