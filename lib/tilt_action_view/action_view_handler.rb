module TiltActionView
  class TiltActionViewHandler < ActionView::TemplateHandler
    class_attribute :default_format
    self.default_format = Mime::HTML

    def self.call(template)
    end
  end
end
