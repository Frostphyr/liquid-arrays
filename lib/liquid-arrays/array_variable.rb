module Arrays
  class ArrayVariable
    def initialize(array)
      @array = array
    end

    def render(context)
      array = @array.map { |v| v.render(context) }
      return array.length == 1 && array[0].is_a?(Array) ? array[0] : array
    end
  end
end