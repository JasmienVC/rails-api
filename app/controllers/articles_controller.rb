class ArticlesController < ApplicationController
  def index
    articles = Article.recent
    render json: ArticleSerializer.new(articles), status: :ok
  end
end
