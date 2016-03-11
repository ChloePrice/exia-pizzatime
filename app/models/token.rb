class Token
  def self.create(user)
    token = "#{BCrypt::Engine.generate_salt}#{DateTime.now.strftime('%d%m%y')}"
    Redis.current.hset('tokens', token, user.id.to_s )
    Redis.current.expire('tokens', 5184000)
    return token
  end

  def self.is_valid?(token)
    Redis.current.hget('tokens', token).present?
  end
end