class ChangeDefaultUserTypeUnconfirmed < ActiveRecord::Migration
  def change
  	change_column :users, :user_type, :string, default: "UNCONFIRMED"
  end
end
