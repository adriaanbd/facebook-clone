class CommentsController < ApplicationController
  before_action :find_comment, only: [:edit, :update, :destroy]

  def create 
    if user_signed_in?
      @comment = Comment.new(comment_params)
      @comment.user_id = current_user.id
      @comment.post_id = params[:post_id]
      if @comment.save
        if session[:source] == 'home'
          redirect_to root_path
        else
          redirect_to profile_path(@comment.post.user.username)
        end

        # appropriate flash message should be rendered
      else
        redirect_to profile_posts_path
      end
    else
      redirect_to profile_posts_path
    end
  end

  def edit
    if not_comment_owner?
      redirect_to profile_post_path
      render status: :unauthorized 
    end
  end

  def update 
    render status: :unauthorized if not_comment_owner?
    @comment.update(comment_params) if is_comment_owner?
  end

  def destroy
    if is_comment_owner? && @comment.destroy
      # corresponding flash message for view
      if session[:source] == 'home'
        redirect_to root_path 
      else
        redirect_to profile_path(@comment.post.user.username)
      end
    else
      redirect_to profile_path(@comment.post.user.username)
    end
  end

  private 

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def is_comment_owner?
    current_user == @comment.user
  end

  def not_comment_owner?
    !current_user == @comment.user
  end

  def comment_params
    params.require(:comment).permit(:message)
  end
end
