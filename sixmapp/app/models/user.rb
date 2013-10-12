class User < ActiveRecord::Base
	attr_accessor :password, :password_confirmation
	validates_presence_of :name
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  # validates :password, length: { minimum: 7 }
end


