module Arrays
  class ArrayInsertTag < ArrayTag
    def parse(tokens)
      super
      parser = AttributeParser.new(@parse_context, @markup)
      @array_name = parser.consume_attribute('array', :id)
      @index = parser.consume_required_attribute('index', :integer)
      @value = parser.consume_required_attribute('value')
      parser.finish
    end

    def render(context)
      array = get_array(context, false)
      index = @index.render(context)
      if !array.nil? && index.is_a?(Integer) && index >= 0 && index <= array.length
        array.insert(index, @value.render(context))
      end
      ''
    end
  end

  Liquid::Template.register_tag('array_insert', ArrayInsertTag)
end