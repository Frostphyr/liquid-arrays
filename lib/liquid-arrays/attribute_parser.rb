module Arrays
  class AttributeParser < Liquid::Parser
    def initialize(parse_context, default_key = nil, markup)
      super(markup)
      @parse_context = parse_context
      @attributes = {}
      if @tokens.length == 2 && look(:end_of_string, 1)
        raise Liquid::SyntaxError, 'attributes must be named' if default_key.nil?
        @attributes[default_key] = get_current_value
      elsif @tokens.length > 2
        while look(:id) && look(:colon, 1)
          key = consume
          consume
          @attributes[key] = get_current_value
        end
        unless look(:end_of_string)
          raise Liquid::SyntaxError, 'attributes need to have the format key:value'
        end
      end
    end

    def consume_attribute(key, type = nil)
      return nil unless @attributes.key?(key)
      attribute = @attributes.delete(key)
      if type == :id
        return attribute[0] == :id ? attribute[1] : nil
      end
      attribute[0] == :id || type.nil? || attribute[0] == type ?
        Liquid::Variable.new(attribute[1], @parse_context) :
        nil
    end

    def consume_required_attribute(key, type = nil)
      attribute = consume_attribute(key, type)
      raise Liquid::ArgumentError, "#{key} not specified" if attribute == nil
      attribute
    end

    def finish
      unless @attributes.empty?
        raise Liquid::ArgumentError, "invalid arguments #{@attributes.keys.join(',')}"
      end
    end

    private

    def get_current_value
      token = @tokens[@p]
      type = token[0]
      value = expression
      if type == :number
        type = value.include?('.') ? :float : :integer
      elsif type == :id && value.eql?('true') || value.eql?('false')
        type = :boolean
      end
      [type, value]
    end
  end
end