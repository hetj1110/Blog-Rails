class Comment < ApplicationRecord
  extend FriendlyId
  
  belongs_to :article
  belongs_to :user

  def self.search(search)
    if search
      joins(:user)
      # .joins(:article)
      .where("users.username LIKE :search OR 
              users.first_name LIKE :search OR 
              users.last_name LIKE :search OR 
              comments.content LIKE :search
              ", search: "%#{search.strip}%")
              # article.title LIKE :search OR 
              # article.subject LIKE :search OR 
              # article.status LIKE :search OR 
    else
      all
    end
  end

  validates :content, presence: true, length: { maximum: 50 }

  friendly_id :content, use: %i[slugged history finders]

  def should_generate_new_friendly_id?
    content_changed? || slug.blank?
  end

end
