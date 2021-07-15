module Arrays
  class ArrayDeleteTag < ArrayTag
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
      array = get_array(context, false)
      unless array.nil?
        if @index.nil?
          array.delete(@value.render(context))
        else
          index = @index.render(context)
          array.delete_at(index) if index.is_a?(Integer) && !out_of_bounds?(array, index)
        end
      end
      ''
    end
  end

  Liquid::Template.register_tag('array_delete', ArrayDeleteTag)
end