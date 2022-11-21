class CommentsController < ApplicationController
  skip_before_action :authorize!, only: :index
  # GET /comments
  def index
    @comments = Comment.all

    render json: @comments
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :article_id, :user_id)
    end
end
