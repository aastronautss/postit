module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable
  end

  def vote_count
    upvotes_count - downvotes_count
  end

  def upvotes_count
    self.votes.where(vote: true).size
  end

  def downvotes_count
    self.votes.where(vote: false).size
  end
end
