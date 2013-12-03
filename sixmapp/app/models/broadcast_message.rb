class BroadcastMessage < ActiveRecord::Base
  validates :message, presence: true
  validates :admin_id, presence: true
  serialize :users_viewed
  after_create :create_users_viewed

  #Returns whether a specific user has viewed this message
  def user_has_viewed(user_id) 
    user_viewed = false
    if self.users_viewed.include? user_id
      user_viewed = true
    end
    user_viewed
  end
 
  def create_users_viewed
    self.users_viewed = [0]
    self.save!
  end

  #Mark message as read for a user
  def message_read(id)
    self.users_viewed << id 
    self.save!
  end
end
