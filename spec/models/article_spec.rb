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

    it 'tests if title is valid' do
      article.title = ''
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'tests if content is valid' do
      article.content = ''
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end

    it 'tests if slug is valid' do
      article.slug = ''
      expect(article).not_to be_valid
      expect(article.errors[:slug]).to include("can't be blank")
    end

    it 'tests if slug is unique' do
      article_one = create(:article)
      expect(article_one).to be_valid
      article_two = build(:article, slug: article_one.slug)
      expect(article_two).not_to be_valid
      expect(article_two.errors[:slug]).to include('has already been taken')
    end
  end
end
