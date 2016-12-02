module Exceptions
  class UnAuthorized < StandardError
  end
  class NotAuthenticated < StandardError
  end
  class TokenExpired < StandardError
  end
  class BadCredentials < StandardError
  end
  class InvalidPasswdConfirmation < StandardError
  end
  class SalesAreClosed < StandardError
  end
  class BadRequest < StandardError
  end
  class OrderLock < StandardError
  end
end
