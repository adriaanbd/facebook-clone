class FriendshipsController < ApplicationController
  def create
    if user_signed_in?
      @friendship = Friendship.new(active_friend_id: params[:active_friend_id], passive_friend_id: current_user.id)
      if @friendship.save
        delete_request
        redirect_to requests_received_requests_path
      else
        redirect_to root_path
      end
    end
  end

  def destroy
    if user_signed_in?
      @friendship = Friendship.find(params[:id])
      @friendship.destroy if are_friends?
    end
  end

  private 

  def are_friends?
    current_user == @friendship.active_friend || current_user == @friendship.passive_friend
  end

  def delete_request
    @request = FriendRequest.where(["requester_id = ? and requestee_id = ?", params[:active_friend_id], current_user.id]).first
    @request.destroy
  end
end
