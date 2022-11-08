class ArticlesController < ApplicationController
  include Paginable

  def index
    paginated_articles = paginate(Article.recent)
    render_collection(paginated_articles)
  end
end
