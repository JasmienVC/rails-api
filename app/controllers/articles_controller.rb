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
    article = current_user.articles.build(article_params)
    article.save!
    render json: article, status: 201
  rescue
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

  def update
    article = current_user.articles.find(params[:id])
    article.update(article_params)
    article.save!
    render json: article, status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue
    errors = {
      errors: [
        {
          source: { pointer: "/data/attributes/title" },
          detail: "can't be blank"
        },
        {
          source: { pointer: "/data/attributes/content" },
          detail: "can't be blank"
        }
      ]
    }
    render json: errors, status: :unprocessable_entity
  end

  def destroy
    article = current_user.articles.find(params[:id])
    article.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    authorization_error
  end

  private

  def article_params
    params.require(:data).require(:attributes).permit(:title, :content, :slug) || ActionController::Parameters.new
  end
end
