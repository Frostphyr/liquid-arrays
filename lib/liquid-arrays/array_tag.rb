module Arrays
  class ArrayTag < Liquid::Tag
    def get_array(context, create)
      unless @array_name.nil?
        if context.key?(@array_name)
          array = context[@array_name]
        elsif create
          array = context[@array_name] ||= []
        end
      else
        if context.key?('block_array')
          array = context['block_array']
        end
      end
      array
    end

    def out_of_bounds?(array, index)
      index < 0 || index >= array.length
    end
  end
end