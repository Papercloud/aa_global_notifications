class CreateAgnPushNotifications < ActiveRecord::Migration
  def change
    create_table :agn_push_notifications do |t|
      t.string :message
      t.string :state
      t.timestamps
    end
  end
end
