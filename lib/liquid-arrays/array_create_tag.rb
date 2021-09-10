module Arrays
  class ArrayCreateTag < Liquid::Tag
    include ErrorHandler

    def parse(tokens)
      super
      catch do
        parser = AttributeParser.new(@parse_context, 'array', @markup)
        @array_name = parser.consume_required_attribute('array', :id)
        @items = parser.consume_attribute('items', :array)
        parser.finish
      end
    end

    def render(context)
      context.scopes.last[@array_name] = @items.nil? ?
        [] : @items.render(context)
      ''
    end
  end

  Liquid::Template.register_tag('array_create', ArrayCreateTag)
end