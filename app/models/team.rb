class Team < ApplicationRecord
  has_many :user_team
  has_many :user, through: :user_team, source: :user, dependent: :destroy
  has_many :column

  validates :title, presence: true, length: { maximum: 100 }

  scope :join_userteam, -> { joins(:user_team) }
  scope :notefunc, -> (team_id) { join_userteam.where(user_team: { team_id: team_id })}
  scope :owners?, -> (user_id){ join_userteam.where(user_team: { role: 'owner', user_id: user_id }).limit(1).present?}

  def new_attr
    {
      id:,
      title:,
      participant: user.map { |user| user.username }
    }
  end
end
