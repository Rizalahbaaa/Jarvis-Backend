class UserTeam < ApplicationRecord
  belongs_to :team
  belongs_to :profile

  validates :profile_id, presence: true
  validates :team_id, presence: true
  validates :profile, uniqueness: { scope: :team, message: 'user already join the team' }

  def new_attributes
    {
      profile: profile.user.email,
      team: team.title
    }
  end
end
