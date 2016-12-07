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
        render_success("LYUENMW3_SAPWV2OMUiL1xoOXkkkuL1WbbQ1mLvSZmE.TZwLbX77Auheo19Z3FExYf4PQjypNm6NvksZfGx1eAo")
    end

    private

    def endDays_parameters
        params.permit(:datetime)
    end

end
