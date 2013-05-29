require 'execjs'

module TiltActionView
  class TiltExecJS < Tilt::Template

    def self.default_mime_type
      "text/html"
    end

    def evaluate(scope, locals, &block)
      ExecJS.compile("#{@tilt_template_class.evaluate(scope, locals, &block)}\nthis.JST[#{file}]()")
    end

    def self.handler_for(tilt_template)
      handler = Class.new(TiltExecJS)
      handler.instance_variable_set :@tilt_template_class, tilt_template
      handler
    end
  end
end
