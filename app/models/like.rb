class Like < ApplicationRecord
  belongs_to :user
  belongs_to :article
  # Already done in db side
  validates :user_id, uniqueness: { scope: :article_id } # This give that one user can like single time to a particuler article
end
