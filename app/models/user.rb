require 'carrierwave/orm/activerecord'
class User < ApplicationRecord
  mount_uploader :photo, PhotoUploader

  before_create :confirmation_token
  has_secure_password

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
    (?=.*[[:^alnum:]])
  /x

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PHONE_REGEX = /\A\d+\z/
  USERNAME_REGEX = /\A[a-zA-Z ]+\z/
  JOB_REGEX = /\A[a-zA-Z ]+\z/

  validate :username_format, :email_format, :phone_format, :job_format, on: [:create, :update]
  validates_presence_of :email, :username, :phone, :job, message: "can't be blank"
  validates_uniqueness_of :username, :email, :phone, message: 'has already been taken'
  validates :username, length: { maximum: 50 }
  validates :email, length: { maximum: 50 }
  validates :phone, length: { maximum: 13 }
  validates :job, length: { maximum: 50 }
  validates :password, confirmation: true, on: :create,
                       format: { with: PASSWORD_REGEX,
                                 message: 'password must contain digit, uppercase, lowercase, and symbol' }
  validates :password_confirmation, presence: true, on: :create

  def new_attr
    {
      id:,
      username:,
      email:,
      phone:,
      job:,
      photo:
    }
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

  private

  def confirmation_token
    return unless confirm_token.blank?

    self.confirm_token = SecureRandom.urlsafe_base64.to_s
  end

end
