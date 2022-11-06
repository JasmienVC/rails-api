class ArticlesController < ApplicationController
  def index
    render json: Article.all, status: :ok
  end
end
