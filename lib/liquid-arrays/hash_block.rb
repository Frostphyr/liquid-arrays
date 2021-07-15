module Arrays
  class HashBlock < Liquid::Block
    def parse(tokens)
      super
      parser = AttributeParser.new(@parse_context, 'hash', @markup)
      @hash_name = parser.consume_required_attribute('hash', :id)
      parser.finish
    end

    def render(context)
      @hash = context[@hash_name] ||= {}
      context.scopes.last[@hash_name] = @hash
      context.stack do
        context['block_hash'] = @hash
        @output = super
      end
      @output
    end
  end

  Liquid::Template.register_tag('hash', HashBlock)
end