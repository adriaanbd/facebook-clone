class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.integer :requester_id
      t.integer :requestee_id

      t.timestamps
    end

    add_index :friendships, :requester_id
    add_index :friendships, :requestee_id
    add_index :friendships, [:requester_id, :requestee_id], unique: true
  end
end
