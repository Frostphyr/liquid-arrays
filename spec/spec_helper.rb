lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'liquid'
require 'liquid-arrays'

def render(text, variables = {})
  context = Liquid::Context.new(variables)
  Liquid::Template.error_mode = :strict
  Liquid::Template.parse(text).render(context)
  context['values']
end