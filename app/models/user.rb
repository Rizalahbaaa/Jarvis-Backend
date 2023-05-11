require 'carrierwave/orm/activerecord'
class User < ApplicationRecord
  mount_uploader :photo, PhotoUploader

  before_create :confirmation_token
  has_secure_password

  attr_accessor :is_forgot
  attr_accessor :current_password

  has_many :transactions
  has_many :products, through: :transactions

  has_many :user_notes
  has_many :notes, through: :user_notes, source: :note, dependent: :destroy

  # has_many :user_team
  # has_many :team, through: :user_team, dependent: :destroy

  # has_many :invitation
  # has_many :notification
  PASSWORD_REGEX = /\A
    (?=.*\d)
    (?=.*[a-z])
    (?=.*[A-Z])
  /x

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PHONE_REGEX = /\A\d+\z/
  USERNAME_REGEX = /\A[a-zA-Z ]+\z/
  JOB_REGEX = /\A[a-zA-Z ]+\z/

  validate :username_format, :email_format, :phone_format, :job_format, on: %i[create update]
  validates_presence_of :email, :username, :phone, :job, message: "can't be blank"
  validates_uniqueness_of :username, :email, :phone, message: 'has already been taken'
  validates :username, length: { maximum: 50 }
  validates :email, length: { maximum: 50 }
  validates :phone, length: { minimum: 10, maximum: 13, message: 'must be between 10-13 digits' }
  validates :job, length: { maximum: 50 }
  validates :password, confirmation: true, on: :create, length: { minimum: 8, message: 'minimum is 8 characters' },
                       format: { with: PASSWORD_REGEX,
                                 message: 'password must contain digit, uppercase and lowercase' }
  validates :password_confirmation, presence: true, on: :create

  validates :password, confirmation: true,
                       length: { minimum: 8, message: 'minimum is 8 characters' },
                       format: { with: PASSWORD_REGEX, message: 'password must contain digit, uppercase and lowercase' },
                       if: :forgot_password_validate
  validates :password_confirmation, presence: true, if: :forgot_password_validate

  validates :password, confirmation: true, on: :forgot_password_validate, length: { minimum: 8, message: 'minimum is 8 characters' },
                       format: { with: PASSWORD_REGEX,
                                 message: 'password must contain digit, uppercase and lowercase' }
  validates :password_confirmation, presence: true, on: :forgot_password_validate

  def new_attr
    {
      id:,
      username:,
      email:,
      phone:,
      job:,
      photo: self.photo.url
    }
  end

  def forgot_password_validate
    is_forgot
  end

  def point
    earned = Transaction.where(user_id: self.id, point_type: 'earned' ).sum(:point) 
    redeemed = Transaction.where(user_id: self.id, point_type: 'redeemed' ).sum(:point) 
    earned - redeemed
  end

  def username_format
    return unless username.present?

    validates_format_of :username, with: USERNAME_REGEX, message: 'username is invalid'
  end

  def email_format
    return unless email.present?

    validates_format_of :email, with: EMAIL_REGEX, message: 'email is invalid'
  end

  def phone_format
    return unless phone.present?

    validates_format_of :phone, with: PHONE_REGEX, message: 'phone is invalid'
  end

  def job_format
    return unless job.present?

    validates_format_of :job, with: JOB_REGEX, message: 'job is invalid'
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  def generate_password_token!
    self.password_reset_token = reset_token
    self.password_reset_sent_at = Time.now.utc
    save!(validate: false)
  end

  def name
    username
  end

  # def reset_password!(password)
  #   validate :password
  #   self.password = password
  #   save!
  # end

  def password_token_valid?
    (password_reset_sent_at + 1.hours) > Time.now.utc
  end

  rails_admin do
    field :id
    field :username
    field :email
    field :point
    field :transactions
  end
  private

  def confirmation_token
    return unless confirm_token.blank?

    self.confirm_token = SecureRandom.urlsafe_base64.to_s
  end

  def reset_token
    SecureRandom.urlsafe_base64.to_s
  end
end
