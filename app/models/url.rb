class Url < ApplicationRecord
  has_one :analytic, dependent: :destroy

  validates :original_url, presence: true, uniqueness: true, url_format: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: :new_record?
  after_create :create_associated_analytic

  private

  def generate_slug
    self.slug = GenerateString.call
  end

  def create_associated_analytic
    build_analytic
    analytic.save!
  end
end
