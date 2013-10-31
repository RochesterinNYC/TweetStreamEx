class CreateBroadcastMessages < ActiveRecord::Migration
  def change
    create_table :broadcast_messages do |t|
      t.string :message
      t.integer :admin_id
      t.string :users_viewed

      t.timestamps
    end
  end
end
