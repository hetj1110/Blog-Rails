class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, notice: exception.message }
      # format.html { redirect_to request.original_url, notice: exception.message }
    end
  end

  def like_text
    return @like_exists ? "Unlike" : "Like"
  end

  # For 404 error but dont use because Profile image does not load
  # def not_found_method
  #   render file: Rails.public_path.join("404.html"), status: 404, layout: false
  # end

  helper_method :like_text
end
