module Arrays
  class ArrayAddTag < Liquid::Tag
    def parse(tokens)
      super
      parser = AttributeParser.new(@parse_context, 'value', @markup)
      @array_name = parser.consume_attribute('array', :id)
      @value = parser.consume_required_attribute('value')
      parser.finish
    end

    def render(context)
      array = ArrayHelper.get_array(context, @array_name, true)
      unless array.nil?
        array.push(@value.render(context))
      end
      ''
    end
  end

  Liquid::Template.register_tag('array_add', ArrayAddTag)
end