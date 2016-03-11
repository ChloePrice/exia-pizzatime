class AdminsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :validate_token

  def index
    render_success(User.admins.all)
  end

  def create
    admin = User.create(admin_parameters)
    admin.change_password(admin_parameters[:password], admin_parameters[:password_confirmation])
    rescue_from InvalidPasswdConfirmation
    admin.delete
    render_errors(['Your password and confirmation doesn\'t match, fat fingers!'], )
  end

  def destroy
    User.find(params[:id]).delete
    render_success()
  rescue
    render_errors(['Failed to delete user. Likely to be a wrong ID.'])
  end

  def login

  end


  private
  def admin_parameters
    params.permit(:email, :name, :password, :password_confirmation)
  end
end