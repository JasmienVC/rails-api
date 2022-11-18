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

  def create
    article = Article.new(article_params)
    if article.save
      render json: article, status: 201
    else
      errors = {
        errors: [
          {
            source: { pointer: "/data/attributes/title" },
            detail: "can't be blank"
          },
          {
            source: { pointer: "/data/attributes/content" },
            detail: "can't be blank"
          },
          {
            source: { pointer: "/data/attributes/slug" },
            detail: "can't be blank"
          }
        ]
      }
      render json: errors, status: :unprocessable_entity
    end
  end

  def update
    article = Article.update(params[:id], article_params)
    if article.save
      render json: article, status: 200
    else
      errors = {
        errors: [
          {
            source: { pointer: "/data/attributes/title" },
            detail: "can't be blank"
          },
          {
            source: { pointer: "/data/attributes/content" },
            detail: "can't be blank"
          },
          {
            source: { pointer: "/data/attributes/slug" },
            detail: "can't be blank"
          }
        ]
      }
      render json: errors, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:data).require(:attributes).permit(:title, :content, :slug) || ActionController::Parameters.new
  end
end
