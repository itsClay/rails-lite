require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    # @params = route_params.merge(req.params)
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise 'double render error' if @already_built_response

    @res['Location'] = url
    @res.status = 302
    @already_built_response = true

    nil
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise 'double render error' if @already_built_response

    @res['Content-Type'] = content_type
    @res.write(content)
    # p @res.body
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    # find controller and template names to construct a path
    path = File.dirname(__FILE__)

    # new_template_name = 'views/#{controller_name}/#{template_name}.html.erb'
    new_template_name = File.join(
      path,                       # current path
      '..',                       # go back one level
      'views',                    # views
      self.class.name.underscore, # convert class name to my_controller
      "#{template_name}.html.erb" # show.html.erb
    )
    f = File.read(new_template_name) # must be in the erb tag format

    render_content(ERB.new(f).result(binding), 'text/html')
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :shob w, :create...)
  def invoke_action(name)
  end
end

