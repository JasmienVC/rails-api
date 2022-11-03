class Article < ApplicationRecord
  validates :title, :content, :slug, presence: true
end
