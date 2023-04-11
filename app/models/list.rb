class List < ApplicationRecord
  belongs_to :team
  has_many :notes

  validates :title, presence: true, length: { maximum: 100 }
  validates :team_id, presence: true

  def new_attributes
    {
      id:,
      title:,
      team: team.new_attributes
    }
  end
end
