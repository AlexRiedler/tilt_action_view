# TiltActionView

An ActionView Template Handler for Tilt

## Installation

Add this line to your application's Gemfile:

    gem 'tilt_action_view'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tilt_action_view

## Usage

Since this does not register any extensions with ActionView Handler you need to either:

- Iterate over the set of extensions in Tilt and register them using the adapter
- Choose the extensions you care about and register them with ActionView using the adapter

(more details to come)

```
# create a handlebars handler, from its tilt template
module HBSHandler
  context = ::ExecJS::compile(File.new("/Users/ariedler/devl/personal/handlebars_assets/vendor/assets/javascripts/handlebars.js").read)
  # do this in a module since it NEEDS a name due to limitation of rails actionview pipeline
  HandlebarsTemplateJS = ::TiltActionView::TiltExecJS.new_handler_for(::HandlebarsAssets::HandlebarsTemplate, context)
end
av_handler = ::TiltActionView::ActionViewHandler.handler_for(HBSHandler::HandlebarsTemplateJS)
::ActionView::Template.register_template_handler(:hbs, av_handler)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

I would like to thank Les Hill (github.com/leshill) for creating handlebars\_assets which is a big inspiration of why I am writing this gem

# Where this gem IS going

- Handling JS templating engines server-side (server-side + client side template sharing)
- Replacing ActionView Templating with Tilt/Sprockets potentially

