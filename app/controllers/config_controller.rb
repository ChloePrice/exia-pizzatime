class ConfigController < ApplicationController
    #before_action :validate_token

    #get
    def currentEndDate
        render_success(getCurrentEndDate)
    end

    #post
    def nextEndDate
        render_success(OrderEndDay.create!(endDays_parameters))
    end

    def ssl_key
        render_success("UkLP8WCGe2DQhWkHz_ogGm6dv7BhsbpDCnZx_s_9EOg.TZwLbX77Auheo19Z3FExYf4PQjypNm6NvksZfGx1eAoblue@Blue")
    end

    private

    def endDays_parameters
        params.permit(:datetime)
    end

end
