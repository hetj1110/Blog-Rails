class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable

  extend FriendlyId

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy#through: :articles
  has_many :likes, dependent: :destroy


  has_many :active_relationships, foreign_key: "follower_id",class_name: 'Relationship' ,dependent: :destroy
  has_many :passive_relationships, foreign_key: "followee_id",class_name: 'Relationship' ,dependent: :destroy
  has_many :following, through: :active_relationships, source: :followee
  has_many :followers,through: :passive_relationships, source: :follower

  def follow(user)
    active_relationships.create(followee_id: user.id)
  end
  
  def unfollow(user)
    active_relationships.find_by(followee_id: user.id).destroy
  end

  def following?(user)
    following.include?(user)
  end



  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable,
         :confirmable,:trackable, authentication_keys: [:login], reset_password_keys: [:login]        
         
  attr_accessor :login
       
  def login
    @login || self.username || self.email
  end

  friendly_id :username, use: %i[slugged history finders]

  def should_generate_new_friendly_id?
    username_changed? || slug.blank?
  end
              
  has_one_attached :avatar  

  validates :username, presence: true, uniqueness: true
  validates :username, format: { with: /\A[a-z0-9_]{4,16}\z/ }
  validates :first_name,:last_name, :date_of_birth, presence: true
  validates :first_name,:last_name, length: {minimum:2, maximum:20}
  validates :first_name,:last_name, format: { with:/\A[a-zA-Z]+\z/, message: "Only letters are allowed" }
  validates :contact_number , presence: true, length: {minimum: 10, maximum: 10}
  validates :address , presence: true, length: {minimum: 5 , maximum:300}
  
  def fullname
    "#{first_name} #{last_name}"
  end



  enum role: [:user, :approver, :admin]
  after_initialize :set_default_role, :if => :new_record?
  def set_default_role
    self.role ||= :user
  end
         
  # ROLES.each do |role_name|
  #   define_method(role_name) do
  #     role == role_name
  #   end
  # end
  
  VALID_GENDER = ['male', 'female', 'unknown']
  
  validates :gender, presence: true
  validates :gender, inclusion: { in: VALID_GENDER }

  validates :country, presence: true

  def countries
    CS.countries.with_indifferent_access
  end

  def country_name
    countries[country]
  end


  validates :date_of_birth, presence: true

  def age
    if date_of_birth.present?
        Date.today.year - date_of_birth.year
    else
        nil
    end
  end

  def formatted_date
    date_of_birth.strftime('%A, %b %d, %Y')
  end

  def avatar_as_thumbnail
    avatar.variant(resize_to_limit: [500,500]).processed
  end

  private

  def after_confirmation
    WelcomeMailer.send_greetings(self).deliver_now
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
     else
       if (conditions[:username].nil?)
         where(conditions).first
         else
           where(username: conditions[:username]).first
         end
    end
  end

end
