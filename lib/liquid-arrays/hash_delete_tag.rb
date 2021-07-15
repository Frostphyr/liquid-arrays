module Arrays
  class HashDeleteTag < HashTag
    def parse(tokens)
      super
      parser = AttributeParser.new(@parse_context, 'key', @markup)
      @hash_name = parser.consume_attribute('hash', :id)
      @key = parser.consume_required_attribute('key')
      parser.finish
    end

    def render(context)
      hash = get_hash(context, false)
      unless hash.nil?
        hash.delete(@key.render(context))
      end
      ''
    end
  end

  Liquid::Template.register_tag('hash_delete', HashDeleteTag)
end