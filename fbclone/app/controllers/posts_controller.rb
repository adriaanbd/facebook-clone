class PostsController < ApplicationController
  before_action :set_post, except: [:new, :create]
	
  def index
  end

  def show
    redirect_to profile_posts_path if not_signed_in?
  end

  def new 
    redirect_to profile_posts_path if not_signed_in?
  end

  def create
    if user_signed_in?
      @post = Post.new(post_params)
      @post.user_id = current_user.id
      if @post.save
        redirect_to profile_posts_path
      else
        render :new
      end
    else
      redirect_to profile_posts_path
    end
  end

  def edit 
    if not_post_owner? && not_signed_in?
      redirect_to profile_posts_path
    elsif not_post_owner?
      redirect_to profile_post_path
    end
  end

  def update
    if @post.update(post_params)
      redirect_to profile_posts_path
    else
      render :edit
    end
  end


  def destroy
    if post_owner? && @post.destroy
      # corresponding flash message for view
    end
    redirect_to profile_posts_path
  end

  private 

  def set_post 
    @post = Post.find_by(id: params[:id])
  end

  def not_post_owner?
    current_user != @post.user
  end

  def post_owner?
    current_user == @post.user
  end

  def post_params
    params.require(:post).permit(:message)
  end
end
