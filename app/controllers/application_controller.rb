class ApplicationController < ActionController::API
  rescue_from Errors::NetworkError, with: :render_network_error
  rescue_from Errors::IpStackError, with: :render_ipstack_error

  def render_network_error(_)
    render json: "problems accessing geolocation provider, check your internet connection", status: :service_unavailable
  end

  def render_ipstack_error(exception)
    render json: exception.message, status: :unprocessable_entity
  end
end
