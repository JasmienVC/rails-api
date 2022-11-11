require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe '#validations' do
    let(:access_token) { build(:access_token) }

    it 'tests if factory is valid' do
      expect(access_token).to be_valid
    end

    it 'should validate presence of attributes' do
      access_token = build :access_token, token: nil, user: nil
      expect(access_token).not_to be_valid
      expect(access_token.errors.messages[:token]).to include("can't be blank")
    end

    it 'should validate uniqueness of token' do
      first_access_token = create :access_token
      second_access_token = build :access_token, token: first_access_token.token
      expect(second_access_token).not_to be_valid
      second_access_token = create :access_token
      expect(second_access_token).to be_valid
    end
  end

  describe '#new' do
    it 'should have a token present after initialize' do
      expect(AccessToken.new.token).to be_present
    end

    it 'should generate unique token' do
      user = create :user
      expect { user.create_access_token }.to change { AccessToken.count }.by(1)
      expect { user.build_access_token }.to be_valid
    end
  end
end
