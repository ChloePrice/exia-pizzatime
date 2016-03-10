class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token


  def index
    render json: User.all
  end

  def create
    render json: User.create(user_parameters)
  end

  def show
    render json: User.find(params[:id])
  end

  def destroy
    render json: User.find(params[:id]).destroy
  end

  private

  def user_parameters
    params.permit(:email, :name)
  end
end
