class Job < ApplicationRecord
  has_many :profiles

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 300 }

  def new_attr
    {
      id:,
      name:,
      description:
    }
  end
end
