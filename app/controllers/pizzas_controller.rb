class PizzasController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :validate_token, except: [:index, :show]

  def index
    render_success(Pizza.all)
  end

  # Create a new pizza
  #
  # == Parameters
  # name::
  #   Name of pizza
  # description::
  #   Ingredients of pizza
  #
  def create
    Pizza.create(pizza_parameters)
    render_success
  end

  def show
    render_success(Pizza.find(params[:id]))
  end

  def destroy
    render_success(Pizza.find(params[:id]).destroy)
  end

  private

  def pizza_parameters
    params.permit(:name, :description, :price)
  end

end
