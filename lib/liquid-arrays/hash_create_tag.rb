module Arrays
  class HashCreateTag < Liquid::Tag
    include ErrorHandler

    def parse(tokens)
      super
      catch do
        parser = AttributeParser.new(@parse_context, 'hash', @markup)
        @hash_name = parser.consume_required_attribute('hash', :id)
        @entries = parser.consume_attribute('entries', :hash)
        parser.finish
      end
    end

    def render(context)
      context.scopes.last[@hash_name] = @entries.nil? ?
        {} : @entries.render(context)
      ''
    end
  end

  Liquid::Template.register_tag('hash_create', HashCreateTag)
end