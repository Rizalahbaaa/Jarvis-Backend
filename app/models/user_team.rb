class UserTeam < ApplicationRecord
  belongs_to :team
  belongs_to :profile

  validates :user_id, presence: true
  validates :team_id, presence: true
  validates :user, uniqueness: { scope: :team, message: 'user already join the team' }

  def new_attributes
    {
      user: user.email,
      team: team.title
    }
  end
end
