require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe '#create' do
    context 'when invalid request' do
      let(:error) do
        {
          "status" => "401",
          "source" => { "pointer" => "/code" },
          "title" => "Invalid authentication code",
          "detail" => "You must provide valid code in order to exchange it for token."
        }
      end

      it 'should return 401 status' do
        post :create
        expect(response).to have_http_status(401)
      end

      it 'should return proper error body' do
        post :create
        expect(json["errors"]).to include(error)
      end
    end

    context 'when valid request' do
    end
  end
end
