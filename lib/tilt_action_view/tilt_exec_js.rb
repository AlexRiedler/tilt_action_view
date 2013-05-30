require 'execjs'
require 'tilt'
require 'debugger'

module TiltActionView
  class TiltExecJS < Tilt::Template

    def self.default_mime_type
      'text/html'
    end

    def evaluate(scope, locals, &block)
      preamble = self.class.instance_variable_get(:@preamble)
      js_fn_code = self.class.instance_variable_get(:@tilt_template_class).new(file).render(scope, locals, &block)
      postamble = self.class.instance_variable_get(:@postamble)
      # TODO: this performance will not be good due to creating ExecJS engines...; need some sort of context
      #       also the javascript libraries they needed are required to be put in preamble ... which is slow
      self.class.instance_variable_get(:@context).eval("#{preamble}#{js_fn_code}#{postamble}(#{variables.to_json})")
    end

    def self.new_handler_for(tilt_template, context=ExecJS.compile(""), preamble="", postamble="")
      # TODO: potentially the tilt_template will have access to the context...
      handler = Class.new(TiltExecJS)
      handler.instance_variable_set :@preamble, preamble
      handler.instance_variable_set :@tilt_template_class, tilt_template
      handler.instance_variable_set :@postamble, postamble
      handler.instance_variable_set :@context, context
      handler
    end
  end

end
