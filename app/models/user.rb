class User < ApplicationRecord
  has_secure_password

  has_many :transactions
  has_many :products, through: :transactions

  has_many :user_notes
  has_many :notes, through: :user_notes, source: :note, dependent: :destroy

  has_many :user_team
  has_many :team, through: :user_team, dependent: :destroy

  has_many :invitation
  has_many :notification

  PASSWORD_REGEX = /\A
    (?=.*\d)
    (?=.*[a-z])
    (?=.*[A-Z])
    (?=.*[[:^alnum:]])
  /x

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PHONE_REGEX = /\+?([ -]?\d+)+|\(\d+\)([ -]\d+)/
  USERNAME_REGEX = /\A[^\W\d_]+\z/
  JOB_REGEX = /\A[^\W\d_]+\z/

  validate :username_format, :email_format, :phone_format, :job_format
  validates_presence_of :email, :username, :phone, :job, message: "can't be blank"
  validates_uniqueness_of :email, :username, :phone, message: 'has already been taken'
  validates :username, length: { maximum: 50 }
  validates :email, length: { maximum: 50 }
  validates :phone, length: { maximum: 13 }
  validates :job, length: { maximum: 50 }
  validates :photo, presence: false
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
end
