class UserTeam < ApplicationRecord
  include ActionView::Helpers::DateHelper
  
  belongs_to :team
  belongs_to :user

  validates :team_id, presence: true
  validates :user_id, uniqueness: { scope: :team, message: 'user already join the team' }

  enum :teaminvitation_status, {Pending: 0, Accepted: 1, Rejected: 2 }


  # def invitation_valid?
  #     self.teaminvitation_status == "Pending" && self.teaminvitation_expired > Time.now
  # end

  def invitation_valid?
    return unless self.teaminvitation_status == "Pending"
      validates_comparison_of :teaminvitation_expired, greater_than: Time.now
  
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

  def owner_team
    UserTeam.find_by(team_id: self.team_id, team_role: "owner")
  end

  def message_teaminv
    'mengajak anda bergabung team'
  end

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

  def sending
    time_send = Time.now - owner_team&.updated_at
    time_ago = distance_of_time_in_words(owner_team&.updated_at, Time.now, locale: :id)
    
    {
      time_send: time_send,
      time_ago: time_ago
    }
  end

  BACKEND_DOMAIN = if Rails.env.development?
    'http://localhost:3000/api'
  else
    'https://bantuin.fly.dev/api'
  end

  def inv_reqteam
  {
    id:,
    from: owner_team&.user&.username,
    photo: owner_team&.user&.photo&.url,
    message: message_teaminv,
    team: team.title,
    actions: [
      { action: "accept", url: "#{BACKEND_DOMAIN}/team/inv/accept_invitation/#{self.teaminvitation_token}" },
      { action: "reject", url: "#{BACKEND_DOMAIN}/team/inv/decline_invitation/#{self.teaminvitation_token}" }
    ],
    date_invite: "#{sending[:time_ago]} yang lalu"
  }
  end

end
