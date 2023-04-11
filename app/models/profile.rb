class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :job


  has_many :user_notes
  has_many :notes, through: :user_notes, source: :note, dependent: :destroy

  has_many :progresses
  has_many :transactions
  has_many :product, through: :transaction
  has_many :user_team
  has_many :team, through: :user_team, dependent: :destroy


  validates :username, presence: true, length: { maximum: 50 }
  validates :job_id, presence: true
  validates :phone, presence: true, length: { minimum: 11 }, uniqueness: true, numericality: true,
                    format: { with: /\+?([ -]?\d+)+|\(\d+\)([ -]\d+)/ }
  validates :photo, presence: false
  validates :user_id, presence: true, uniqueness: true

  def new_attr
    {
      id:,
      username:,
      job: job.new_attr,
      phone:,
      photo:,
      user: user.new_attr
    }
  end
end
