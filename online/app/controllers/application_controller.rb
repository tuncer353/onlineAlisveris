class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Lutfen giris yapin!"
      end
    end
end
