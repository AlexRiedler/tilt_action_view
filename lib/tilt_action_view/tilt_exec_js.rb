require 'execjs'
require 'tilt'
require 'debugger'
module TiltActionView
  class TiltExecJS < Tilt::Template

    include Unindent

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

  class TiltHandlebars < Tilt::Template

    include Unindent

    def self.default_mime_type
      'application/javascript'
    end

    def evaluate(scope, locals, &block)
      template_namespace = HandlebarsAssets::Config.template_namespace

      compiled_hbs = HandlebarsAssets::Handlebars.precompile(data, HandlebarsAssets::Config.options)

      if template_path.is_partial?
        unindent <<-PARTIAL
          (function() {
            Handlebars.registerPartial(#{template_path.name}, Handlebars.template(#{compiled_hbs}));
          }).call(this);
          PARTIAL
      else
        unindent <<-TEMPLATE
          (function() {
            this.#{template_namespace} || (this.#{template_namespace} = {});
            this.#{template_namespace}[#{template_path.name}] = Handlebars.template(#{compiled_hbs});
            return this.#{template_namespace}[#{template_path.name}];
          }).call(this);
        TEMPLATE
      end
    end
  end

end
