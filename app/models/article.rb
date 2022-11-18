class Article < ApplicationRecord
  validates :title, :content, :slug, presence: true
  validates :slug, uniqueness: true
  belongs_to :user
  scope :recent, -> { order(created_at: :desc) }
end
