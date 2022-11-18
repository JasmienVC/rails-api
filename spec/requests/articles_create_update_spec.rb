require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe '#create' do
    context 'when no code provided' do
      subject { post :create }
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      subject { post :create }
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      let(:access_token) { create :access_token }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'when invalid parameters provided' do
        let(:invalid_attributes) do
          {
            data: {
              attributes: {
                title: '',
                content: ''
              }
            }
          }
        end

        subject { post :create, params: invalid_attributes }

        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return proper error json' do
          subject
          expect(json[:errors]).to include(
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
          )
        end
      end

      context 'when success request sent' do
        let(:valid_attributes) do
          {
            data: {
              attributes: {
                title: 'This is some title',
                content: 'This is some content',
                slug: 'this-is-some-title'
              }
            }
          }
        end

        subject { post :create, params: valid_attributes }

        it 'should have 201 status code' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'should have proper json body' do
          subject
          expect(json).to include(valid_attributes[:data][:attributes])
        end

        it 'should create the article' do
          expect { subject }.to change{ Article.count }.by(1)
        end
      end
    end
  end

  describe '#update' do
    let(:article) { create :article }

    context 'when no code provided' do
      subject { patch :update, params: { id: article.id } }
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      subject { patch :update, params: { id: article.id } }
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      let(:access_token) { create :access_token }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'when invalid parameters provided' do
        let(:invalid_attributes) do
          {
            data: {
              attributes: {
                title: '',
                content: ''
              }
            }
          }
        end

        subject { patch :update, params: invalid_attributes.merge(id: article.id) }

        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return proper error json' do
          subject
          expect(json[:errors]).to include(
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
          )
        end
      end
    end
  end


end
