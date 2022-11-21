class Article < ApplicationRecord
  validates :title, :content, :slug, presence: true
  validates :slug, uniqueness: true
  belongs_to :user
  has_many :comments, dependent: :destroy
  scope :recent, -> { order(created_at: :desc) }
end
