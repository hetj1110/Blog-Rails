class Article < ApplicationRecord
  extend FriendlyId

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :subject, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  has_rich_text :body

  friendly_id :title, use: %i[slugged history finders]

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end
  
  
  VALID_STATUSES = ['public', 'private', 'archived']


  validates :status, inclusion: { in: VALID_STATUSES }

  def archived?
    status == 'archived'
  end
  def public?
    status == 'public'
  end
  def private?
    status == 'private'
  end

end
