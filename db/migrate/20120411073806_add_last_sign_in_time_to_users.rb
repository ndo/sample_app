class AddLastSignInTimeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_sign_in_time, :DateTime
  end

  def self.down
    remove_column :users, :last_sign_in_time
  end
end
