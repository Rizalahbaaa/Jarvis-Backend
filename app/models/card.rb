class Card < ApplicationRecord
  belongs_to :column
  has_many :attaches, dependent: :destroy

  validates :subject, presence: true, length: { maximum:50 }
  validates :description, presence: true, length: { maximum:500 }
  validates :label, presence: false, length: { maximum:30 }
  validates :column_id, presence: true

  def self.check_member(column, current)
    check_column = Column.find_by_id(column)
    member_team = UserTeam.find_by(user_id: current.id, team_id: check_column.team.id)
    if member_team.present?
        return true
    end
  end
  
  def new_attr
    {
      id:, 
      subject:,
      description:,
      label:
    #   column_id:
    }
  end
  
end
