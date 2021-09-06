module Arrays
  class ArrayHelper
    def self.get_array(context, array_name, create)
      unless array_name.nil?
        if context.key?(array_name)
          array = context[array_name]
        elsif create
          array = context.scopes.last[array_name] ||= []
        end
      else
        if context.key?('block_array')
          array = context['block_array']
        end
      end
      array.is_a?(Array) ? array : nil
    end
  end
end