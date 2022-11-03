require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '#validations' do
    # prepend tests linked with specific instances with #
    # prepend tests linked with class with .
    let(:article) { build(:article) } # define article instance with let method to reuse
    it 'tests if factory is valid' do
      expect(article).to be_valid
      # expect(1).to be_positive ## _positive appends .positive? on tested number
    end

    it 'has an invalid title' do
      article.title = ''
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end
  end
end
