module Arrays
  class ArrayDeleteTag < Liquid::Tag
    def parse(tokens)
      super
      parser = AttributeParser.new(@parse_context, @markup)
      @array_name = parser.consume_attribute('array', :id)
      @value = parser.consume_attribute('value')
      @index = parser.consume_attribute('index', :integer)
      parser.finish
      if @value.nil? && @index.nil?
        raise Liquid::ArgumentError, 'no value or index specified'
      elsif !@value.nil? && !@index.nil?
        raise Liquid::ArgumentError, 'only value or index can be specified'
      end
    end

    def render(context)
      array = ArrayHelper.get_array(context, @array_name, false)
      unless array.nil?
        if @index.nil?
          array.delete(@value.render(context))
        else
          index = @index.render(context)
          if index.is_a?(Integer) && index >= 0 && index < array.length
            array.delete_at(index)
          end
        end
      end
      ''
    end
  end

  Liquid::Template.register_tag('array_delete', ArrayDeleteTag)
end