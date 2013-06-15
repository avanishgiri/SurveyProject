class User < ActiveRecord::Base
  has_secure_password
  has_many :responses
  has_many :surveys
  has_many :completions

  def check_password(password)
    self.try(:authenticate, password)
  end
end
