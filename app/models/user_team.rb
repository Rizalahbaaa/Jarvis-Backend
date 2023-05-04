class UserTeam < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :team_id, presence: true
  validates :user_id, uniqueness: { scope: :team, message: 'user already join the team' }

  def new_attributes
    {
      user: user.email,
      team: team.title
    }
  end
end
