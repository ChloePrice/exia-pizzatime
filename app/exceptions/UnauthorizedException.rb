module Exceptions
    class UnAuthorized < StandardError
        def initialize(data)
            @data = data
        end
    end
    class NotAuthenticated < StandardError
        def initialize(data)
            @data = data
        end
    end
    class TokenExpired < StandardError
        def initialize(data)
            @data = data
        end
    end
    class BadCredentials < StandardError
        def initialize(data)
            @data = data
        end
    end

    class SalesAreClosed < StandardError
        def initialize(data)
            @data = data
        end
    end
end