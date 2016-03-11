class User < ActiveRecord::Base
  has_and_belongs_to_many :pizzas

  scope :admins, -> { where.not(password_hash: nil) }


  def change_password(password, confirmation)
    raise Exceptions::InvalidPasswdConfirmation.new if password != confirmation
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, self.password_salt)
    self.save!
  end

  def authenticated?(password)
    if self.password_hash.blank?
      self.errors.add(:base, 'Who are ya? Get out.')
      return false
    end
    self.password_hash == BCrypt::Engine.hash_secret(password, self.password_salt)
  end

  def authenticate(password)
    if self.authenticated?(password)
      return Token.create(self)
    else
      raise('User failed to authenticate.')
    end
  end

end
