# -*- coding: utf-8 -*-

class Git
  class Blob
    ATTRIBUTES = [:commit, :author, :date, :message, :diff]
    attr_accessor *ATTRIBUTES
    attribute_setters = ATTRIBUTES.map do |attr|
      (attr.to_s + '=').to_sym
    end
    private *attribute_setters

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
        appended_value = [previous_value, value].join
        self.send(setter, appended_value)
      else
        setter = (key.to_s + '=').to_s
        self.send(setter, value)
      end
    end

  end
end
