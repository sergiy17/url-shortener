class UrlSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :shortened_link, :slug, :original_url, :visits, :last_visit_at, :is_active

  def shortened_link
    short_url_url({ slug: object.slug }.merge(Rails.application.config.action_controller.default_url_options))
  end

  def visits
    object.analytic.visits
  end

  def last_visit_at
    object.analytic.last_visit_at
  end

  def is_active
    object.analytic&.last_visit_at&.>=(1.month.ago) || false
  end
end