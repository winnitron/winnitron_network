class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parent, only: [:create]
  before_action :require_commenter!, only: [:create]

  def create
    @comment = Comment.new(user: current_user,
                        comment: params[:comment][:comment],
                    commentable: @parent)
    if @comment.save
      render partial: "shared/comment", locals: { comment: @comment }, layout: nil, status: :created
    else
      render json: { errors: @comment.errors.full_messages }
    end
  end

  def destroy
  end

  private

  def set_parent
    @parent = Game.find(params[:parent_id])
  end

  def require_commenter!
    head :forbidden if !current_user.can_comment?(@parent)
  end
end
