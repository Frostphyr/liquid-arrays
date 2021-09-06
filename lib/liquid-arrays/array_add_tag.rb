module Arrays
  class ArrayAddTag < Liquid::Tag
    include ErrorHandler
    
    def parse(tokens)
      super
      catch do
        parser = AttributeParser.new(@parse_context, 'value', @markup)
        @array_name = parser.consume_attribute('array', :id)
        @value = parser.consume_required_attribute('value')
        parser.finish
      end
    end

    def render(context)
      array = ArrayHelper.get_array(context, @array_name, true)
      array.push(@value.render(context)) unless array.nil?
      ''
    end
  end

  Liquid::Template.register_tag('array_add', ArrayAddTag)
end