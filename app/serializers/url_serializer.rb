class UrlSerializer < ActiveModel::Serializer
  attributes :slug, :original_url, :visits, :last_visit_at

  def visits
    object.analytic.visits
  end

  def last_visit_at
    object.analytic.last_visit_at
  end
end