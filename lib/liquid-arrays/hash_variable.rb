module Arrays
  class HashVariable
    def initialize(hash)
      @hash = hash
    end

    def render(context)
      @hash.map { |k,v| [k.render(context), v.render(context)] }.to_h
    end
  end
end