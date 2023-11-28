class ApplicationController < ActionController::Base
  # Devise's `authenticate_user!` method will first check if the user
  # is authenticated (logged in). If not, it will redirect the user
  # to the sign-in page.
  before_action :authenticate_user!, unless: :devise_controller?
end
