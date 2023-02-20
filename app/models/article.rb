class Article < ApplicationRecord
  belongs_to :user
  # has_many :comments, dependent: :destroy

  VALID_STATUSES = ['public', 'private', 'archived']


  validates :status, inclusion: { in: VALID_STATUSES }

  def archived?
    status == 'archived'
  end


  def public_count
      where( status: 'public' ).count
  end



end
