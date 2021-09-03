module Arrays
  class ArrayVariable
    def initialize(array)
      @array = array
    end

    def render(context)
      @array.map { |v| v.render(context) }
    end
  end
end