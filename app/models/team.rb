class Team < ApplicationRecord
  has_many :user_team
  has_many :profile, through: :user_team
  has_many :list

  validates :title, presence: true, length: { maximum: 100 }

  def new_attributes
    {
      id:,
      title:,
      participant: profile.map { |profile| profile.username }
    }
  end
end
