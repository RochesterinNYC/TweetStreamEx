class User < ActiveRecord::Base
  VALID_TYPES = %w{ REGULAR PREMIUM ADMIN UNCONFIRMED }

  # validates :email, presence: true, uniqueness: true
  # validates :name, presence: true
  # validates :password_digest, presence: true
  # validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/
  # validates_inclusion_of :user_type, in: VALID_TYPES
  # has_secure_password

  # after_create :deliver_confirmation_email
  # after_create :mark_old_broadcasts

  VALID_TYPES.each do |user_type|
    scope user_type.to_s.downcase, -> { where(user_type: user_type) }
    define_method("#{user_type.downcase}?".to_sym) { self.user_type.to_s.upcase == user_type.to_s.upcase }
    define_method("#{user_type.downcase}!".to_sym) { self.user_type = user_type.to_s.upcase; self.save! }
  end

  def self.valid_types
    VALID_TYPES
  end

  def self.find_or_create_by_oauth(auth_data)
    user = self.find_or_create_by(provider: auth_data["provider"],
      uid: auth_data["uid"])
    if user.name != auth_data["info"]["name"]
      user.name = auth_data["info"]["name"]
      user.save
    end
    user
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

  def reset_password(password)
    self.password_digest = password
    self.save!
  end

  def update_attr(params)
    self.name = params[:user][:name]
    self.save
  end

  def get_new_broadcasts
    newBroadcasts = []
    BroadcastMessage.all.each do |broadcast|
      if !broadcast.user_has_viewed(self.id)
        newBroadcasts << broadcast
      end
    end
    newBroadcasts
  end

  def mark_old_broadcasts
    BroadcastMessage.all.each do |broadcast|
      broadcast.users_viewed << self.id
      broadcast.save
    end
  end
end


