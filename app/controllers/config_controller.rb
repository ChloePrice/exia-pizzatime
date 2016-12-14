class ConfigController < ApplicationController
    before_action :validate_token
    before_action :validate_admin, except: [:currentEndDate]

    #get
    def currentEndDate
        render_success({maxOrderDate: OrderEndDay.last.end_day, deliveryDate: OrderEndDay.last.deliver_date})
    end

    #post
    def nextEndDate
        Order.live.map(&:lock)
        datetime = Date.iso8601(endDays_parameters[:datetime]).strftime
        render_success(OrderEndDay.create!(datetime: datetime))
    end

    private

    def endDays_parameters
        params.permit(:datetime)
    end

end
