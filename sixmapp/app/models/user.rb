class User < ActiveRecord::Base
	attr_accessor :name, :email, :password
  VALID_TYPES = %w{ REGULAR PREMIUM } 

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/
  validates_inclusion_of :type, in: VALID_TYPES  

  after_create :deliver_confirmation

  VALID_TYPES.each do |user_type|
    scope user_type.to_s.downcase, -> { where(user_type: user_type)
    define_method("#{user_type.downcase}?".to_sym) { self.user_type.to_s.upcase == user_type.to_s.upcase }
    define_method("#{user_type.downcase}!".to_sym) { self.user_type = user_type.to_s.upcase; self.save! }
  end

  def self.valid_types
    VALID_TYPES
  end

end


