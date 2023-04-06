class User < ApplicationRecord
  has_secure_password
  belongs_to :job

  has_many :user_notes
  has_many :notes, through: :user_notes, source: :note

  validates :username, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  validates :phone, presence: true, length: { minimum: 12 }, uniqueness: true, numericality: true,
                    format: { with: /\+?([ -]?\d+)+|\(\d+\)([ -]\d+)/ }
  validates :job_id, presence: true
  validates :password, length: { minimum: 8 }
  validates :password_requirements, confirmation: true
  validates :password_confirmation, presence: true

  def new_attr
    {
      id:,
      username:,
      email:,
      phone:,
      job: job.new_attr
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
