module TiltActionView
  class ActionViewHandler

    # Return the rendered contents in which to run from the context of the ActionView::Template
    def self.call(template)
      <<-source
        variable_names = controller.instance_variable_names
        variable_names -= %w[@template]
        if controller.respond_to?(:protected_instance_variables)
          variable_names -= controller.protected_instance_variables
        end
        variable_names.reject! { |name| name.starts_with? '@_' }

        variables = {}
        variable_names.each do |name|
          variables[name] = controller.instance_variable_get(name)
        end
        #{@tilt_template_class.name}.new('#{template.identifier}').render(self, variables.merge(local_assigns)).html_safe
      source
    end

    def self.handler_for(tilt_template)
      handler = Class.new(ActionViewHandler)
      handler.instance_variable_set :@tilt_template_class, tilt_template
      handler
    end
  end

  module HandlebarsTemplateHandler
    def self.call(template)
      <<-HBS
      variable_names = controller.instance_variable_names
      variable_names -= %w[@template]
      if controller.respond_to?(:protected_instance_variables)
        variable_names -= controller.protected_instance_variables
      end
      variable_names.reject! { |name| name.starts_with? '@_' }

      variables = variable_names.inject({}) { |acc,name| acc[name.sub(/^@/, "")] = controller.instance_variable_get(name); acc }
      variables.merge!(local_assigns)

      TiltActionView::HandlebarsTemplateHandler.render_template(#{template.source.inspect}, variables).html_safe
      HBS
    end

    def self.render_template(data, variables)
      precompiled_template = HandlebarsAssets::Handlebars.precompile(data)
      HandlebarsAssets::Handlebars.runtime_context.call("Handlebars.template(#{precompiled_template})(#{variables.to_json}")
    end
  end
end
