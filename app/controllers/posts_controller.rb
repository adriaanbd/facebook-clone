class PostsController < ApplicationController
  before_action :set_post, except: [:new, :create]

  def show
    redirect_to profile_path if not_signed_in?
  end

  def new 
    redirect_to profile_path if not_signed_in?
  end

  def create
    if user_signed_in?
      @post = Post.new(post_params)
      @post.user_id = current_user.id
      if @post.save
        flash[:notice] = 'Post created successfully'
        if session[:source] == 'home'
          redirect_to root_path
        else
          redirect_to profile_path
        end
      else
        flash[:alert] = 'Post could not be created'
        render :new
      end
    else
      redirect_to profile_path
    end
  end

  def edit 
    if not_post_owner? && not_signed_in?
      redirect_to profile_path
    elsif not_post_owner?
      redirect_to profile_post_path
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'Post updated successfully'
    else 
      flash[:alert] = 'Post could not be updated'
      render :edit
    end
    if session[:source] == 'home'
      redirect_to root_path
    else
      redirect_to profile_path
    end
  end


  def destroy
    if post_owner? && @post.destroy
      flash[:notice] = 'Post deleted successfully'
    else 
      flash[:alert] = 'Post could not be deleted'
    end
    if session[:source] == 'home'
      redirect_to root_path
    else
      redirect_to profile_path
    end
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
