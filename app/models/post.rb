class Post < ActiveRecord::Base
  include Voteable

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: { minimum: 5 }
  validates :description, presence: true
  validates :url, presence: true, uniqueness: { case_sensitive: false }

  before_create :generate_slug

  def to_param
    self.slug
  end

  def generate_slug(increment = 0)
    new_slug = self.title.gsub(/\W+/, '-').gsub(/\A-+|-+\z/, '').downcase
    new_slug += increment > 0 ? "-#{increment}" : ''

    if self.class.where(slug: new_slug).any?
      self.generate_slug(increment + 1)
    else
      self.slug = new_slug
    end
  end
end
