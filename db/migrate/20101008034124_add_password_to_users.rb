class AddPasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :encrypted_pass, :string
  end

  def self.down
    remove_column :users, :encrypted_pass
  end
end
