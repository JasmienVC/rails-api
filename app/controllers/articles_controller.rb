class ArticlesController < ApplicationController
  def index
    articles = Article.all
    render json: ArticleSerializer.new(articles), status: :ok
  end
end
