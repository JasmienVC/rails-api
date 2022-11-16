class ArticlesController < ApplicationController
  include Paginable
  skip_before_action :authorize!, only: %i[index show]

  def index
    paginated_articles = paginate(Article.recent)
    render_collection(paginated_articles)
  end

  def show
    article = Article.find(params[:id])
    render json: ArticleSerializer.new(article), status: :ok
  end
end
