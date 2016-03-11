class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :validate_token, except: [:show, :authenticate]

  def index
    render json: User.all
  end

  # Create a new user
  #
  # == Parameters
  # name::
  #   Name of user
  # email::
  #   email of user
  # promo::
  #   label of user's school class
  #
  def create
    render json: User.create!(user_parameters)
  rescue
    render_errors(user.errors.full_messages, :unprocessable_entity)
  end

  def show
    return self.index if(params[:id].to_i == 0)
    render json: User.find(params[:id])
  rescue => e
    render_errors([e.message], :unprocessable_entity)
  end

  def destroy
    user = User.find(params[:id])
    render json: user.destroy
  rescue
    render_errors(user.errors.full_messages, :unprocessable_entity)
  end

  def authenticate
    u = User.find_by(email: password_parameters[:email])
    if u.authenticated?(password_parameters[:password])
      render_success([u.authenticate(password_parameters[:password])])
    else
      render_errors([u.errors.full_messages], :unauthorized)
    end
  end




  private

  def user_parameters
    params.permit(:email, :name, :promo)
  end

  def password_parameters
    params.permit(:email, :password)
  end
end
