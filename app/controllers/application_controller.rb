class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def render_404
	render :file => 'public/404.html', :status => :not_found, :layout => false
  end

end
