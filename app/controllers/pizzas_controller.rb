require 'json'

class PizzasController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :validate_token, except: [:index, :show]

  def index
    result = Pizza.all.map do |p| 
      {id: p.id, name: p.name, base: {id: p.base.id, name: p.base.name}, price: p.price }
    end
    render_success(result)
  end

  def create
    Pizza.create!(pizza_parameters)
    render_success
  end

  def show
    render_success(Pizza.find(params[:id]))
  end

  def destroy
    render_success(Pizza.find(params[:id]).destroy)
  end

  def update
    render_success(Pizza.find(params[:id]).update(pizza_parameters))
  end

  private

  def pizza_parameters
    params.permit(:name, :description, :price, :base_id)
  end

end
