class BasesController < ApplicationController
    skip_before_filter :verify_authenticity_token
    before_action :validate_token
    
    def index
        result = Base.all.map do |b|
            {id: b.id, name: b.name}
        end 
        render_success(result)
    end

    def create
        render_success(Base.create!(base_parameters))
    end

    def update
        render_success(Base.find(params[:id]).update!(base_parameters))
    end

    def destroy
        render_success(Base.find(params[:id]).destroy)
    end

    private
    def base_parameters
        params.permit(:name)
    end
end
