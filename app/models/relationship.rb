class Relationship < ApplicationRecord

    # extend FriendlyId

    belongs_to :follower, class_name: 'User'
    belongs_to :followee, class_name: 'User'

    validates :follower_id, presence: true
    validates :followee_id, presence: true
    
    # friendly_id :user_id, use: %i[slugged history finders]

    # def should_generate_new_friendly_id?
    #     user_id_changed? || slug.blank?
    # end

end
