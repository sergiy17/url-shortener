class Url < ApplicationRecord
  validates :original_url, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: :new_record?

  private

  def generate_slug
    self.slug = GenerateString.call
  end
end
