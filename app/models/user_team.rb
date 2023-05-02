class UserTeam < ApplicationRecord
  belongs_to :team
  belongs_to :profile
  has_many :invitation, as: :invitable, dependent: :destroy

  validates :profile_id, presence: true
  validates :team_id, presence: true
  validates :user, uniqueness: { scope: :team, message: 'user already join the team' }

  def new_attributes
    {
      profile: profile.user.email,
      team: team.title
    }
  end
end
