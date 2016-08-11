class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence:    true,
                       uniqueness:  true,
                       length:      { minimum: 2, maximum: 20 }
  validates :password, presence:    true,
                       length:      { minimum: 5 },
                       on:          :create

  before_create :generate_slug

  def to_param
    self.slug
  end

  def generate_slug(increment = 0)
    new_slug = self.username.gsub(/\W+/, '-').gsub(/\A-+|-+\z/, '').downcase
    new_slug += increment > 0 ? "-#{increment}" : ''

    if self.class.where(slug: new_slug).any?
      self.generate_slug(increment + 1)
    else
      self.slug = new_slug
    end
  end
end
