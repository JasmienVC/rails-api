require 'rails_helper'

RSpec.describe Article, type: :model do
  it 'tests article object' do
    article = FactoryBot.create(:article)
    expect(article.title).to eq 'Sample article'
    # expect(1).to be_positive ## _positive appends .positive? on tested number
  end
end
