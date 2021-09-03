module Arrays
  class HashSetTag < Liquid::Tag
    def parse(tokens)
      super
      parser = AttributeParser.new(@parse_context, @markup)
      @hash_name = parser.consume_attribute('hash', :id)
      @key = parser.consume_required_attribute('key')
      @value = parser.consume_required_attribute('value')
      parser.finish
    end

    def render(context)
      hash = HashHelper.get_hash(context, @hash_name, true)
      unless hash.nil?
        hash[@key.render(context)] = @value.render(context)
      end
      ''
    end
  end

  Liquid::Template.register_tag('hash_set', HashSetTag)
end