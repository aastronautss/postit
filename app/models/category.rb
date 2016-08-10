class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: 2 }

  before_create :generate_slug

  def to_param
    self.slug
  end

  def generate_slug(increment = 0)
    new_slug = self.name.gsub(/\W+/, '-').gsub(/\A-+|-+\z/, '').downcase
    new_slug += increment > 0 ? "-#{increment}" : ''

    if self.class.where(slug: new_slug).any?
      self.generate_slug(increment + 1)
    else
      self.slug = new_slug
    end
  end
end
