require 'rails_helper'

RSpec.describe Article, type: :model do
  it 'tests a number to be positive' do
    expect(1).to be_positive # _positive appends .positive? on tested number
  end
end
