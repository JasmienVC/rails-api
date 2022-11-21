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
          expect { subject }.to change { Article.count }.by(1)
        end
      end
    end
  end

  describe '#update' do
    let(:user) { create :user }
    let(:article) { create :article, user: user }
    let(:access_token) { user.create_access_token }

    context 'when no code provided' do
      subject { patch :update, params: { id: article.id } }
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      subject { patch :update, params: { id: article.id } }
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when trying to update not owned article' do
      let(:other_user) { create :user }
      let(:other_article) { create :article, user: other_user }
      subject { patch :update, params: { id: other_article.id } }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }
      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
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
            }
          )
        end
      end

      context 'when success request sent' do

        let(:valid_attributes) do
          {
            data: {
              attributes: {
                title: 'This is some updated title',
                content: 'This is some updated content',
                slug: 'this-is-some-updated-title'
              }
            }
          }
        end

        subject { patch :update, params: valid_attributes.merge(id: article.id) }

        it 'should have 200 status code' do
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'should have proper json body' do
          subject
          expect(json).to include(valid_attributes[:data][:attributes])
        end

        it 'should update the article' do
          subject
          expect { subject }.not_to(change { Article.count })
          expect(json[:title]).to eq('This is some updated title')
          # expect(article.reload.title).to eq(valid_attributes[:data][:attributes][:title])
          expect(json[:content]).to eq('This is some updated content')
          expect(json[:slug]).to eq('this-is-some-updated-title')
        end
      end
    end
  end

  describe '#destroy' do
    let(:user) { create :user }
    let(:article) { create :article, user: user }
    let(:access_token) { user.create_access_token }

    subject { delete :destroy, params: { id: article.id } }

    context 'when no authorization header provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid authorization header provided' do
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when trying to delete not owned article' do
      let(:other_user) { create :user }
      let(:other_article) { create :article, user: other_user }
      subject { delete :destroy, params: { id: other_article.id } }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }
      it_behaves_like 'forbidden_requests'
    end

    context 'when valid request' do

      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      it 'should return 204 status code' do
        subject
        expect(response).to have_http_status(:no_content)
      end

      it 'should remove the proper article' do
        article
        expect { subject }.to change { user.articles.count }.by(-1)
      end
    end
  end
end
