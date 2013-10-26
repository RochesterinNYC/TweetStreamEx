class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_type, :string, default: "REGULAR"
  end
end
