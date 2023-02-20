class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  has_rich_text :body
  
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
