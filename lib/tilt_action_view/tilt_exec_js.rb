require 'execjs'
require 'tilt'
require 'json'

module TiltActionView
  class TiltExecJS < Tilt::Template

    def self.default_mime_type
      'text/html'
    end

    def prepare
      # pass
    end

    def evaluate(scope, locals, &block)
      context = self.class.instance_variable_get(:@context)
      js_fn_code = self.class.instance_variable_get(:@tilt_template_class).new(file).render(scope, locals, &block)
      js_eval_string = "(function() { return #{js_fn_code} }).call(this)(#{JSON.dump(locals)})"
      context.eval(js_eval_string)
    end

    def self.new_handler_for(tilt_template, context=ExecJS.compile(""))
      # TODO: potentially the tilt_template will have access to the context...
      handler = Class.new(TiltExecJS)
      handler.instance_variable_set :@tilt_template_class, tilt_template
      handler.instance_variable_set :@context, context
      handler
    end
  end

end
