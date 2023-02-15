class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable,
         :confirmable,:trackable, authentication_keys: [:login], reset_password_keys: [:login] 


  validates :username, presence: true, uniqueness: true
  validates :username, format: { with: /\A[a-z0-9_]{4,16}\z/ }
  validates :first_name,:last_name, :date_of_birth, presence: true
  validates :first_name,:last_name, length: {minimum:2, maximum:20}
  validates :first_name,:last_name, format: { with:/\A[a-zA-Z]+\z/, message: "Only letters are allowed" }


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
    CS.countries.with_indifferent_access
  end

  def country_name
    countries[country]
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  def age
    if date_of_birth.present?
        Date.today.year - date_of_birth.year
    else
        nil
    end
  end

  private

  def after_confirmation
    WelcomeMailer.send_greetings(self).deliver_now
  end

  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   if (login = conditions.delete(:login))
  #     where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", {value: login.downcase }]).first
  #   elsif conditions.has_key?(:username) || conditions.has_key?(:email)
  #     where(conditions.to_h).first
  #   end
  # end

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
