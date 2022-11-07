class ArticlesController < ApplicationController
  include Paginable

  def index
    paginated_articles = paginate(Article.recent)
    render_collection(paginated_articles)
  end

  def paginator
    JSOM::Pagination::Paginator.new
  end

  def pagination_params
    params.permit![:page]
  end
end
