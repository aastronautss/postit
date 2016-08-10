class CommentsController < ApplicationController
  before_action :set_comment, except: [:create]
  before_action :set_post, only: [:create]

  def create
    @comment = @post.comments.build comment_params
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = 'Your comment was submitted.'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    vote = Vote.create voteable: @comment, creator: current_user, vote: params[:vote]

    respond_to do |format|
      format.html do
        if vote.valid?
          flash[:notice] = 'Your vote has been counted.'
        else
          flash[:error] = 'You can only vote on a comment once.'
        end

        redirect_to :back
      end

      format.js do
        if vote.valid?
          flash.now[:notice] = 'Your vote has been counted.'
        else
          flash.now[:error] = 'You can only vote on a comment once.'
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit :body
  end

  def set_post
    @post = Post.find params[:post_id]
  end

  def set_comment
    @comment = Comment.find params[:id]
  end
end
