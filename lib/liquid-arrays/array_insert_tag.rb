module Arrays
  class ArrayInsertTag < Liquid::Tag
    def parse(tokens)
      super
      parser = AttributeParser.new(@parse_context, @markup)
      @array_name = parser.consume_attribute('array', :id)
      @index = parser.consume_required_attribute('index', :integer)
      @value = parser.consume_required_attribute('value')
      parser.finish
    end

    def render(context)
      array = ArrayHelper.get_array(context, @array_name, false)
      index = @index.render(context)
      if !array.nil? && index.is_a?(Integer) && index >= 0 && index <= array.length
        array.insert(index, @value.render(context))
      end
      ''
    end
  end

  Liquid::Template.register_tag('array_insert', ArrayInsertTag)
end