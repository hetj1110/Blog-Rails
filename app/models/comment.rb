class Comment < ApplicationRecord
  extend FriendlyId
  
  belongs_to :article
  belongs_to :user

  friendly_id :content, use: %i[slugged history finders]

  def should_generate_new_friendly_id?
    content_changed? || slug.blank?
  end

end
