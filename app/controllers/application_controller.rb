class ApplicationController < ActionController::API
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

  private

  def authentication_error
    error = {
      "status" => "401",
      "source" => { "pointer" => "/code" },
      "title" => "Invalid authentication code",
      "detail" => "You must provide valid code in order to exchange it for token."
    }
    render json: { "errors": [error] }, status: 401
  end
end
