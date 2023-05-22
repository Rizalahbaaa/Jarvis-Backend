class UserTeam < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_many :notifications

  validates :team_id, presence: true
  validates :user_id, uniqueness: { scope: :team, message: 'user already join the team' }

  enum :teaminvitation_status, {Pending: 0, Accepted: 1, Rejected: 2 }


  def invitation_valid?
      self.teaminvitation_status == "Pending" && self.teaminvitation_expired > Time.now
  end

  def accept_invitation!
      self.teaminvitation_status = 1
      save!
  end

  def decline_invitation!
      self.teaminvitation_status = 2
      destroy
  end

  enum team_role: {
    owner: 0,
    member: 1
  }

  def new_attributes
    {
      user: user.email,
      team: team.title,
      role:,
      invitation_token: self.teaminvitation_token,
      invitation_status: self.teaminvitation_status,
      invitation_expired: self.teaminvitation_expired
    }
  end
end
