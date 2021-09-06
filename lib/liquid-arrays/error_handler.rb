module Arrays
  module ErrorHandler
    def handle(error)
      error.line_number = line_number
      error.markup_context = "in \"#{@markup.strip}\""
      
      case @parse_context.error_mode
      when :strict
        raise error
      when :warn
        @parse_context.warnings << error
      end
    end

    def catch
      begin
        yield
      rescue => e
        handle(e)
      end
    end
  end
end