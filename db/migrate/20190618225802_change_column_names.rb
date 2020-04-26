class ChangeColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :friendships, :requester_id, :active_friend_id
    rename_column :friendships, :requestee_id, :passive_friend_id
  end
end
