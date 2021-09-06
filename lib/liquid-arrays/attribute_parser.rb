module Arrays
  class AttributeParser < Liquid::Parser
    def initialize(parse_context, default_key = nil, markup)
      super(markup)
      @parse_context = parse_context
      parse(default_key, markup)
    end

    def consume_attribute(key, type = nil)
      return nil unless @attributes.key?(key)
      value = @attributes.delete(key)
      if type == :id
        return value[0] == :id ? value[1].raw : nil
      elsif type == :array && value[0] != :array
        return ArrayVariable.new([value[1]])
      end
      return type.nil? || value[0] == type || value[0] == :id ? value[1] : nil
    end

    def consume_required_attribute(key, type = nil)
      attribute = consume_attribute(key, type)
      raise Liquid::SyntaxError, "#{key} not specified" if attribute == nil
      attribute
    end

    def finish
      unless @attributes.empty?
        raise Liquid::SyntaxError, "invalid arguments #{@attributes.keys.join(',')}"
      end
    end

    private

    def parse(default_key, markup)
      @attributes = {}
      unless look(:end_of_string)
        if look(:id) && look(:colon, 1)
          while look(:id) && look(:colon, 1)
            key = consume
            consume
            @attributes[key] = parse_value
          end
          unless look(:end_of_string)
            raise Liquid::SyntaxError, 'attributes need to have the format key:value'
          end
        else
          raise Liquid::SyntaxError, 'attributes must be named' if default_key.nil?
          @attributes[default_key] = parse_value
          unless look(:end_of_string)
            raise Liquid::SyntaxError, ''
          end
        end
      end
    end

    def parse_value
      expression = parse_expression
      if look(:comma)
        array = [expression[1]]
        while look(:comma)
          consume
          array.push(parse_expression[1])
        end
        return [:array, ArrayVariable.new(array)]
      elsif look(:comparison)
        raise Liquid::SyntaxError, '' unless consume.eql?('>')
        hash = {expression[1] => parse_expression[1]}
        while look(:comma) && look(:comparison, 2)
          consume
          key = parse_expression[1]
          raise Liquid::SyntaxError, '' unless consume.eql?('>')
          hash[key] = parse_expression[1]
        end
        return [:hash, HashVariable.new(hash)]
      end
      expression
    end

    def parse_expression
      token = @tokens[@p]
      type = token[0]
      value = expression
      if type == :number
        type = value.include?('.') ? :float : :integer
      elsif type == :id && value.eql?('true') || value.eql?('false')
        type = :boolean
      end
      [type, Liquid::Variable.new(value, @parse_context)]
    end
  end
end