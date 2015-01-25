class ApplicationController < ActionController::API
  include Pundit
  
  protected

  def ensure_user_authenticated!
    current_user || render_unauthorized
  end

  def current_user
    @current_user ||= User.from_request(request)
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Bearer realm="Application"'
    render json: { errors: 'Bad credentials' }, status: :unauthorized
  end
end
