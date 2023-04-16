class User < ApplicationRecord
  has_secure_password

  has_many :transactions
  has_many :products, through: :transactions

  has_many :user_notes
  has_many :notes, through: :user_notes, source: :note, dependent: :destroy

  has_many :user_team
  has_many :team, through: :user_team, dependent: :destroy

  has_many :user_team
  has_many :user_team_note
  has_many :invitation
  has_many :notification

  validates :email, presence: true, length: { maximum: 50 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: 'email format is invalid' },
                    uniqueness: true
  validates :username, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :phone, presence: true, length: { minimum: 11 }, uniqueness: true, numericality: true,
                    format: { with: /\+?([ -]?\d+)+|\(\d+\)([ -]\d+)/, message: 'phone format is invalid' }
  validates :job, presence: true, length: { maximum: 50 }
  validates :photo, presence: false
  validates :password, confirmation: true, length: { minimum: 8 },
                       format: { with: PASSWORD_FORMAT,
                                 message: 'password must contain digit, uppercase, lowercase, and symbol' }
  validates :password_confirmation, presence: true

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
end
