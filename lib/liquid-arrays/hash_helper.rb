module Arrays
  class HashHelper
    def self.get_hash(context, hash_name, create)
      unless hash_name.nil?
        if context.key?(hash_name)
          hash = context[hash_name]
        elsif create
          hash = context.scopes.last[hash_name] ||= {}
        end
      else
        if context.key?('block_hash')
          hash = context['block_hash']
        end
      end
      hash
    end
  end
end