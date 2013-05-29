module TiltActionView
  class ActionViewHandler

    def self.call(template)
      template_source = template.source
      variable_names = controller.instance_variable_names
      variable_names -= %w[@template]
      if controller.respond_to?(:protected_instance_variables)
        variable_names -= controller.protected_instance_variables
      end
      variable_names.reject! { |name| name.starts_with '@_' }

      variable_names.each do |name|
        variables[name.sub(/^@/, '')] = controller.instance_variable_get(name)
      end
      @tilt_template_class.new(template.identifier).render(template_source, variables).html_safe
    end

    def self.handler_for(tilt_template)
      handler = Class.new(ActionViewHandler)
      handler.instance_variable_set :@tilt_template_class, tilt_template
      handler
    end
  end
end
