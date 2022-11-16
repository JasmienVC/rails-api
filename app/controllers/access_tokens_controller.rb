class AccessTokensController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
    render json: authenticator.access_token, status: :created
  end

  def destroy
    provided_token = request.authorization&.gsub(/\ABearer\s/, '')
    access_token = AccessToken.find_by(token: provided_token)
    current_user = access_token&.user
    raise AuthorizationError unless current_user
    
    current_user.access_token.destroy
  end
end
