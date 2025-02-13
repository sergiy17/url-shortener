class Url < ApplicationRecord
  validates :original_url, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
end