module Sluggable
  extend ActiveSupport::Concern

  included do
    before_create :generate_slug
    class_attribute :slug_column
  end

  def to_param
    self.slug
  end

  def generate_slug(increment = 0)
    new_slug = to_slug(self.send(self.class.slug_column.to_sym))
    new_slug += increment > 0 ? "-#{increment}" : ''

    if self.class.where(slug: new_slug).any?
      self.generate_slug(increment + 1)
    else
      self.slug = new_slug
    end
  end

  def to_slug(col)
    col.gsub(/\W+/, '-').gsub(/\A-+|-+\z/, '').downcase
  end

  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end
end
