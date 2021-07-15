module Arrays
  class ArrayAddTag < ArrayTag
    def parse(tokens)
      super
      parser = AttributeParser.new(@parse_context, 'value', @markup)
      @array_name = parser.consume_attribute('array', :id)
      @value = parser.consume_required_attribute('value')
      parser.finish
    end

    def render(context)
      array = get_array(context, true)
      unless array.nil?
        array.push(@value.render(context))
      end
      ''
    end
  end

  Liquid::Template.register_tag('array_add', ArrayAddTag)
end