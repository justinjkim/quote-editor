class ApplicationController < ActionController::Base
  # Devise's `authenticate_user!` method will first check if the user
  # is authenticated (logged in). If not, it will redirect the user
  # to the sign-in page.
  before_action :authenticate_user!, unless: :devise_controller?

  private

  def current_company
    @current_company ||= current_user.company if user_signed_in? # user_signed_in? is from devise
  end

  helper_method :current_company
end
