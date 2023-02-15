class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable,
         :confirmable,:trackable, authentication_keys: [:login]


  validates :username, presence: true, uniqueness: true

  attr_accessor :login

  def login
    @login || self.username || self.email
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
  
  validates :gender, inclusion: { in: VALID_GENDER }

  validates :country, presence: true



  def countries
    CS.countries
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  private

  def after_confirmation
    WelcomeMailer.send_greetings(self).deliver_now
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", {value: login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

end
