class Article < ApplicationRecord
  extend FriendlyId

  validates :title, presence: true, length: { minimum: 3, maximum: 40 }
  validates :subject, presence: true, length: { minimum: 50 }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  has_rich_text :body

  def self.search(search)
    if search
      joins(:user)
      .joins(:comments)
      .where("articles.title LIKE :search OR 
              articles.subject LIKE :search OR 
              articles.status LIKE :search OR 
              users.username LIKE :search OR 
              users.first_name LIKE :search OR 
              users.last_name LIKE :search OR 
              comments.content LIKE :search", 
              search: "%#{search.strip}%")
    else
      all
    end
  end

  friendly_id :title, use: %i[slugged history finders]

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end
  
  
  VALID_STATUSES = ['public', 'private', 'archived']


  validates :status, inclusion: { in: VALID_STATUSES }

  private

  def after_creation
    WelcomeMailer.send_greetings(self).deliver_now
  end

end
