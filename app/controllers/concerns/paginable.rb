module Paginable
  extend ActiveSupport::Concern

  def paginate(collection)
    paginator.call(
      collection,
      params: pagination_params,
      base_url: request.url
    )
  end

  def paginator
    JSOM::Pagination::Paginator.new
  end

  def pagination_params
    params.permit![:page]
  end
end
