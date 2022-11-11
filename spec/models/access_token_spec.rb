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
end
