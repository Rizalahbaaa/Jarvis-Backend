class User < ApplicationRecord
  has_secure_password

  has_one :profile, dependent: :destroy

  has_many :user_team
  has_many :team, through: :user_team

  has_many :user_notes
  has_many :notes, through: :user_notes, source: :note, dependent: :destroy

  validates :email, presence: true, length: { maximum: 50 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  validates :password, length: { minimum: 8 }
  validates :password_requirements, confirmation: true
  validates :password_confirmation, presence: true

  def new_attr
    {
      id:,
      email:
    }
  end

  def password_requirements
    rules = {
      ' must contain at least one lowercase letter' => /[a-z]+/,
      ' must contain at least one uppercase letter' => /[A-Z]+/,
      ' must contain at least one digit' => /\d+/,
      ' must contain at least one special character' => /[^A-Za-z0-9]+/
    }

    rules.each do |message, regex|
      errors.add(:password, message) unless password.match(regex)
    end
  end
end
