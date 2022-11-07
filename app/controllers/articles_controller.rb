class ArticlesController < ApplicationController
  def index
    articles = Article.recent
    paginated_articles = paginator.call(
      articles,
      params: pagination_params,
      base_url: request.url
    )
    options = { meta: paginated_articles.meta.to_h, links: paginated_articles.links.to_h }
    render json: ArticleSerializer.new(paginated_articles.items, options), status: :ok
  end

  def paginator
    JSOM::Pagination::Paginator.new
  end

  def pagination_params
    params.permit![:page]
  end
end
