class UrlSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :shortened_link, :slug, :original_url, :visits, :last_visit_at

  def shortened_link
    short_url_url({ slug: Url.first.slug }.merge(Rails.application.config.action_controller.default_url_options))
  end

  def visits
    object.analytic.visits
  end

  def last_visit_at
    object.analytic.last_visit_at
  end
end