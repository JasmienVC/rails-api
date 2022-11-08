class ArticlesController < ApplicationController
  include Paginable

  def index
    paginated_articles = paginate(Article.recent)
    render_collection(paginated_articles)
  end

  def show
    article = Article.find(params[:id])
    render json: ArticleSerializer.new(article), status: :ok
  end
end
