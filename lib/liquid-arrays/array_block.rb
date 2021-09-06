module Arrays
  class ArrayBlock < Liquid::Block
    include ErrorHandler

    def parse(tokens)
      super
      catch do
        parser = AttributeParser.new(@parse_context, 'array', @markup)
        @array_name = parser.consume_required_attribute('array', :id)
        parser.finish
      end
    end

    def render(context)
      if context.key?(@array_name)
        @array = context[@array_name]
      else
        context.scopes.last[@array_name] = @array = []
      end
      context.stack do
        context['block_array'] = @array
        @output = super
      end
      @output
    end
  end

  Liquid::Template.register_tag('array', ArrayBlock)
end