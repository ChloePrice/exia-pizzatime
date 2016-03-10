class PizzasController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    pizzas = Pizza.all
    render json: pizzas
  end

  def create
    res = Pizza.create(pizza_parameters)
    render json: res
  end

  def show
    render json: Pizza.find(params[:id])
  end

  def destroy
    render json: Pizza.find(params[:id]).destroy
  end

  private

  def pizza_parameters
    params.permit(:name, :description, :price)
  end

end
