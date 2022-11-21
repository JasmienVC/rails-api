class CommentsController < ApplicationController
  skip_before_action :authorize!, only: :index
  before_action :load_article

  # GET /comments
  def index
    comments = @article.comments.all
    render json: comments, status: :ok
  end

  # POST /comments
  def create
    comment = @article.comments.build(comment_params.merge(user: current_user))
    comment.save!
    render json: comment, status: 201
  rescue ActiveRecord::RecordNotFound
    authorization_error
  end

  private

  def load_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
