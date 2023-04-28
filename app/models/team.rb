class Team < ApplicationRecord
  has_many :user_team
  has_many :user, through: :user_team
  has_many :list
has_many :invitation, as: :invitetable

  validates :title, presence: true, length: { maximum: 100 }

  def new_attributes
    {
      id:,
      title:,
      participant: user.map { |user| user.username }
    }
  end
end
