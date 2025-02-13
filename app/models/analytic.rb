class Analytic < ApplicationRecord
  belongs_to :url

  validates :visits, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def increment_visits!
    ActiveRecord::Base.transaction do
      increment(:visits)
      touch(:last_visit_at)
      save!
    end
  end
end