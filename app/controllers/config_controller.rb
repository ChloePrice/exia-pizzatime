class ConfigController < ApplicationController
    before_action :validate_token
    before_action :validate_admin, except: [:currentEndDate]

    #get
    def currentEndDate
        render_success(getCurrentEndDate)
    end

    #post
    def nextEndDate
        render_success(OrderEndDay.create!(endDays_parameters))
    end

    private

    def endDays_parameters
        params.permit(:datetime)
    end

end
