class User < ActiveRecord::Base
  VALID_TYPES = %w{ REGULAR PREMIUM UNCONFIRMED } 

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  #validates :password_digest, presence: true
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/
  validates_inclusion_of :user_type, in: VALID_TYPES  

  after_create :deliver_confirmation_email

  VALID_TYPES.each do |user_type|
    scope user_type.to_s.downcase, -> { where(user_type: user_type) }
    define_method("#{user_type.downcase}?".to_sym) { self.user_type.to_s.upcase == user_type.to_s.upcase }
    define_method("#{user_type.downcase}!".to_sym) { self.user_type = user_type.to_s.upcase; self.save! }
  end

  def self.valid_types
    VALID_TYPES
  end
  
  def deliver_confirmation_email
    UserMailer.confirmation_email(self).deliver if self.unconfirmed?
  end
  def confirm_user 
    if self.unconfirmed?
      self.regular!
    else
      false
    end
  end
end


