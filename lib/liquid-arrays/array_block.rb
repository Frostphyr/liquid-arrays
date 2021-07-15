module Arrays
  class ArrayBlock < Liquid::Block
    def parse(tokens)
      super
      parser = AttributeParser.new(@parse_context, 'array', @markup)
      @array_name = parser.consume_required_attribute('array', :id)
      parser.finish
    end

    def render(context)
      @array = context[@array_name] ||= []
      context.scopes.last[@array_name] = @array
      context.stack do
        context['block_array'] = @array
        @output = super
      end
      @output
    end
  end

  Liquid::Template.register_tag('array', ArrayBlock)
end