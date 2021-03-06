module Arrays
  class ArrayReplaceTag < Liquid::Tag
    include ErrorHandler
    
    def parse(tokens)
      super
      catch do
        parser = AttributeParser.new(@parse_context, @markup)
        @array_name = parser.consume_attribute('array', :id)
        @index = parser.consume_required_attribute('index', :integer)
        @value = parser.consume_required_attribute('value')
        parser.finish
      end
    end

    def render(context)
      array = ArrayHelper.get_array(context, @array_name, false)
      index = @index.render(context)
      unless array.nil? || !index.is_a?(Integer) || index < 0 || index >= array.length
        array[index] = @value.render(context)
      end
      ''
    end
  end

  Liquid::Template.register_tag('array_replace', ArrayReplaceTag)
end